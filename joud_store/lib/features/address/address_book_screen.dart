import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';

class AddressBookScreen extends ConsumerStatefulWidget {
  const AddressBookScreen({super.key});

  @override
  ConsumerState<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends ConsumerState<AddressBookScreen> {
  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return ScreenScaffold(
      title: localizationService.getString('addressBook'),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAddress,
        child: const Icon(Icons.add),
      ),
      body: const EmptyState(
        title: 'لا توجد عناوين',
        message: 'أضف عنوانك الأول للبدء',
        icon: Icons.location_on_outlined,
      ),
    );
  }

  void _addAddress() {
    // Navigate to add address screen
  }
}
