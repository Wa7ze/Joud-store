import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';

class AddressBookScreen extends ConsumerWidget {
  const AddressBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizationService = LocalizationService.instance;

    return ScreenScaffold(
      title: localizationService.getString('addressBook'),
      showBackButton: true,
      currentIndex: 4,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: implement add address flow
        },
        tooltip: localizationService.getString('addAddress'),
        child: const Icon(Icons.add),
      ),
      body: EmptyState(
        title: localizationService.getString('noAddresses'),
        message: localizationService.getString('addressEmptyMessage'),
        icon: Icons.location_on_outlined,
      ),
    );
  }
}
