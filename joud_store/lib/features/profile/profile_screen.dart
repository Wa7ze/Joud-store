import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return ScreenScaffold(
      title: localizationService.getString('profile'),
      body: ListView(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Text(
                    'أ',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'أحمد محمد',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '+963 11 123 4567',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          // Profile Options
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('تعديل الملف الشخصي'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _editProfile,
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(localizationService.getString('addressBook')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: Text(localizationService.getString('orders')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.local_offer),
            title: Text(localizationService.getString('coupons')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(localizationService.getString('settings')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(localizationService.getString('logout')),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    // Navigate to edit profile screen
  }

  void _logout() {
    // Show logout confirmation dialog
  }
}
