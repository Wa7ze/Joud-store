import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/widgets/page_container.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/widgets/language_picker.dart';
import '../../core/localization/localization_service.dart';
import '../profile/providers/profile_preferences_provider.dart';
import '../settings/providers/settings_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const List<String> _sizeOptions = ['S', 'M', 'L', 'XL'];
  static const List<String> _styleOptions = [
    'Smart casual',
    'Streetwear',
    'Activewear',
    'Minimalist',
    'Traditional',
  ];
  static const Map<String, String> _styleLabelKeys = {
    'Smart casual': 'profileStyleSmartCasual',
    'Streetwear': 'profileStyleStreetwear',
    'Activewear': 'profileStyleActivewear',
    'Minimalist': 'profileStyleMinimalist',
    'Traditional': 'profileStyleTraditional',
  };
  static const List<String> _colorOptions = [
    'Earth tones',
    'Neutrals',
    'Bold colours',
    'Pastels',
  ];
  static const Map<String, String> _colorLabelKeys = {
    'Earth tones': 'profileColorEarthTones',
    'Neutrals': 'profileColorNeutrals',
    'Bold colours': 'profileColorBoldColours',
    'Pastels': 'profileColorPastels',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencesAsync = ref.watch(profilePreferencesProvider);
    final settings = ref.watch(settingsProvider);
    final localization = LocalizationService.instance;
    final selectedLocale = settings.locale;
    final languageLabel = LanguagePicker.describeLocale(selectedLocale);

    return ScreenScaffold(
      showBackButton: false,
      currentIndex: 3,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: preferencesAsync.when(
        loading: () => const LoadingState(),
        error: (_, __) => PageContainer(
          child: EmptyState(
            title: localization.getString('profileLoadErrorTitle'),
            message: localization.getString('profileLoadErrorMessage'),
          ),
        ),
        data: (prefs) => SingleChildScrollView(
          child: PageContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderCard(
                  name: 'Dana Al-Hassan',
                  email: 'dana.hassan@example.sy',
                  phone: '+963 999 123 456',
                  memberSince: localization.getString('profileMemberSince'),
                ),
                const SizedBox(height: 24),
                _StatsStrip(orders: 12, favorites: 48, vouchers: 3),
                const SizedBox(height: 24),
                _SectionTitle(localization.getString('profileFitPreferences')),
                _ChipWrap(
                  options: _sizeOptions,
                  isSelected: (value) => prefs.preferredSizes.contains(value),
                  onToggle: (value) => ref
                      .read(profilePreferencesProvider.notifier)
                      .toggleSize(value),
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  localization.getString('profileStyleInspiration'),
                ),
                _ChipWrap(
                  options: _styleOptions,
                  isSelected: (value) => prefs.preferredStyles.contains(value),
                  onToggle: (value) => ref
                      .read(profilePreferencesProvider.notifier)
                      .toggleStyle(value),
                  labelBuilder: (value) =>
                      localization.getString(_styleLabelKeys[value] ?? value),
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  localization.getString('profilePaletteFavourites'),
                ),
                _ChipWrap(
                  options: _colorOptions,
                  isSelected: (_) => false,
                  onToggle: (_) {},
                  enabled: false,
                  labelBuilder: (value) =>
                      localization.getString(_colorLabelKeys[value] ?? value),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      SwitchListTile.adaptive(
                        secondary: const Icon(Icons.dark_mode),
                        title: Text(localization.getString('darkMode')),
                        subtitle: Text(
                          localization.getString('profileDarkModeSubtitle'),
                        ),
                        value: settings.themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          final notifier = ref.read(settingsProvider.notifier);
                          notifier.setThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                          ref
                              .read(profilePreferencesProvider.notifier)
                              .setDarkMode(value);
                        },
                      ),
                      const Divider(height: 0),
                      ListTile(
                        leading: const Icon(Icons.translate),
                        title: Text(localization.getString('language')),
                        subtitle: Text(languageLabel),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final selected = await LanguagePicker.show(
                            context,
                            selectedLocale,
                          );
                          if (!context.mounted) {
                            return;
                          }
                          if (selected != null && selected != selectedLocale) {
                            await ref
                                .read(settingsProvider.notifier)
                                .setLocale(selected);
                            messenger
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    LocalizationService.instance.getString(
                                      'settingsSaved',
                                    ),
                                  ),
                                ),
                              );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _SectionTitle(localization.getString('profileQuickLinks')),
                _NavigationTile(
                  icon: Icons.favorite_border,
                  title: localization.getString('profileSavedFavouritesTitle'),
                  description: localization.getString(
                    'profileSavedFavouritesDescription',
                  ),
                  onTap: () => context.push(AppRouter.favorites),
                ),
                _NavigationTile(
                  icon: Icons.location_on_outlined,
                  title: localization.getString(
                    'profileDeliveryAddressesTitle',
                  ),
                  description: localization.getString(
                    'profileDeliveryAddressesDescription',
                  ),
                  onTap: () => context.push(AppRouter.addressBook),
                ),
                _NavigationTile(
                  icon: Icons.shopping_bag_outlined,
                  title: localization.getString('profileOrdersReturnsTitle'),
                  description: localization.getString(
                    'profileOrdersReturnsDescription',
                  ),
                  onTap: () => context.push(AppRouter.orders),
                ),
                _NavigationTile(
                  icon: Icons.settings_outlined,
                  title: localization.getString('profileAccountSettingsTitle'),
                  description: localization.getString(
                    'profileAccountSettingsDescription',
                  ),
                  onTap: () => context.push(AppRouter.settings),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        localization.getString('profileSignOutMessage'),
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: Text(localization.getString('profileSignOutLabel')),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.name,
    required this.email,
    required this.phone,
    required this.memberSince,
  });

  final String name;
  final String email;
  final String phone;
  final String memberSince;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = LocalizationService.instance;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 38,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                name.substring(0, 1),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, size: 18),
                        label: Text(
                          localization.getString('profileEditButton'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(email, style: theme.textTheme.bodyMedium),
                  Text(phone, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Chip(
                    avatar: const Icon(Icons.workspace_premium, size: 18),
                    label: Text(memberSince),
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.08,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({
    required this.orders,
    required this.favorites,
    required this.vouchers,
  });

  final int orders;
  final int favorites;
  final int vouchers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = LocalizationService.instance;

    Widget buildStat(String label, int value, IconData icon) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                '$value',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        buildStat(
          localization.getString('profileStatsOrders'),
          orders,
          Icons.receipt_long,
        ),
        const SizedBox(width: 12),
        buildStat(
          localization.getString('profileStatsFavorites'),
          favorites,
          Icons.favorite_outline,
        ),
        const SizedBox(width: 12),
        buildStat(
          localization.getString('profileStatsVouchers'),
          vouchers,
          Icons.card_giftcard,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _ChipWrap extends StatelessWidget {
  const _ChipWrap({
    required this.options,
    required this.isSelected,
    required this.onToggle,
    this.enabled = true,
    this.labelBuilder,
  });

  final List<String> options;
  final bool Function(String value) isSelected;
  final ValueChanged<String> onToggle;
  final bool enabled;
  final String Function(String value)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final selected = isSelected(option);
        final display = labelBuilder?.call(option) ?? option;
        return ChoiceChip(
          label: Text(display),
          selected: selected,
          onSelected: enabled ? (_) => onToggle(option) : null,
        );
      }).toList(),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
