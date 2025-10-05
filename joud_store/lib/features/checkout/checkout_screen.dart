import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep = 0;
  final List<String> _steps = ['العنوان', 'التوصيل', 'الدفع', 'المراجعة'];

  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return ScreenScaffold(
      title: localizationService.getString('checkout'),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Stepper(
              currentStep: _currentStep,
              steps: _steps.map((step) => Step(
                title: Text(step),
                content: Container(),
                isActive: _currentStep >= _steps.indexOf(step),
              )).toList(),
              onStepTapped: (step) {
                setState(() {
                  _currentStep = step;
                });
              },
            ),
          ),
          
          // Step Content
          Expanded(
            child: _buildStepContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildAddressStep();
      case 1:
        return _buildDeliveryStep();
      case 2:
        return _buildPaymentStep();
      case 3:
        return _buildReviewStep();
      default:
        return const EmptyState(title: 'خطأ');
    }
  }

  Widget _buildAddressStep() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('اختر عنوان التوصيل'),
          SizedBox(height: 16),
          Text('قائمة العناوين ستظهر هنا'),
        ],
      ),
    );
  }

  Widget _buildDeliveryStep() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('اختر طريقة التوصيل'),
          SizedBox(height: 16),
          Text('خيارات التوصيل ستظهر هنا'),
        ],
      ),
    );
  }

  Widget _buildPaymentStep() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('اختر طريقة الدفع'),
          SizedBox(height: 16),
          Text('خيارات الدفع ستظهر هنا'),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('مراجعة الطلب'),
          SizedBox(height: 16),
          Text('تفاصيل الطلب ستظهر هنا'),
        ],
      ),
    );
  }
}
