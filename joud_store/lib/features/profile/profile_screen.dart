import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/widgets/ui_states.dart';
import '../profile/providers/profile_preferences_provider.dart';
import '../settings/providers/settings_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const _sizeOptions = [
    '\u0631\u062c\u0627\u0644\u064a',
    '\u0646\u0633\u0627\u0626\u064a',
    '\u0623\u0637\u0641\u0627\u0644',
  ];

  static const _styleOptions = [
    '\u0633\u062a\u0627\u064a\u0644 \u0639\u0635\u0631\u064a',
    '\u0633\u062a\u0627\u064a\u0644 \u0643\u0644\u0627\u0633\u064a\u0643\u064a',
    '\u0633\u062a\u0627\u064a\u0644 \u0645\u062d\u062a\u0634\u0645',
    '\u0633\u062a\u0627\u064a\u0644 \u0631\u064a\u0627\u0636\u064a',
    '\u0633\u062a\u0627\u064a\u0644 \u0643\u0627\u062c\u0648\u0627\u0644',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencesAsync = ref.watch(profilePreferencesProvider);
    final settings = ref.watch(settingsProvider);

    return ScreenScaffold(
      title: '\u0645\u0644\u0641\u064a',
      showBackButton: false,
      currentIndex: 4,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: preferencesAsync.when(
        loading: () => const LoadingState(),
        error: (_, __) => const EmptyState(
          title: '\u062a\u0639\u0630\u0631 \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0628\u064a\u0627\u0646\u0627\u062a',
          message: '\u062d\u0627\u0648\u0644 \u0645\u0631\u0629 \u0623\u062e\u0631\u0649 \u0644\u0627\u062d\u0642\u0627\u064b.',
        ),
        data: (prefs) => Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildHeader(context),
                const Divider(),
                _buildSectionTitle(context, '\u0627\u0644\u0645\u0642\u0627\u0633\u0627\u062a \u0627\u0644\u0645\u0641\u0636\u0644\u0629'),
                _buildChipWrap(
                  context: context,
                  options: _sizeOptions,
                  isSelected: (value) => prefs.preferredSizes.contains(value),
                  onToggle: (value) => ref
                      .read(profilePreferencesProvider.notifier)
                      .toggleSize(value),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle(context, '\u0627\u0644\u0623\u0646\u0645\u0627\u0637 \u0627\u0644\u0645\u0641\u0636\u0644\u0629'),
                _buildChipWrap(
                  context: context,
                  options: _styleOptions,
                  isSelected: (value) => prefs.preferredStyles.contains(value),
                  onToggle: (value) => ref
                      .read(profilePreferencesProvider.notifier)
                      .toggleStyle(value),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode),
                  title: const Text('الوضع الداكن'),
                  subtitle: const Text('حوّل الواجهة إلى ألوان داكنة مريحة للعين'),
                  value: settings.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                    ref
                        .read(profilePreferencesProvider.notifier)
                        .setDarkMode(value);
                  },
                ),
                const Divider(),
                _buildNavigationTile(
                  context: context,
                  icon: Icons.favorite,
                  title: 'منتجاتي المفضلة',
                  onTap: () => context.push(AppRouter.favorites),
                ),
                _buildNavigationTile(
                  context: context,
                  icon: Icons.location_on,
                  title: 'دفتر العناوين',
                  onTap: () => context.push(AppRouter.addressBook),
                ),
                _buildNavigationTile(
                  context: context,
                  icon: Icons.shopping_bag,
                  title: 'طلباتي',
                  onTap: () => context.push(AppRouter.orders),
                ),
                _buildNavigationTile(
                  context: context,
                  icon: Icons.settings,
                  title: 'الإعدادات',
                  onTap: () => context.push(AppRouter.settings),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('تسجيل الخروج'),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تسجيل الخروج (تجريبي)')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: const Text('\u062c'),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('\u0623\u0647\u0644\u0627\u064b\u060c \u062c\u0648\u062f'),
              SizedBox(height: 4),
              Text('+963 999 123 456'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style:
            Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildChipWrap({
    required BuildContext context,
    required List<String> options,
    required bool Function(String) isSelected,
    required void Function(String) onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options
            .map(
              (option) => FilterChip(
                label: Text(option),
                selected: isSelected(option),
                onSelected: (_) => onToggle(option),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildNavigationTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
