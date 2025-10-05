import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/router/app_router.dart';
import 'providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authProvider.notifier).sendOtp(_phoneController.text);
      
      if (mounted && !ref.read(authProvider).hasError) {
        setState(() {
          _isOtpSent = true;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocalizationService.instance.getString('sendOtp')),
          ),
        );
      }
    }
  }

  void _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authProvider.notifier).signIn(
        _phoneController.text,
        _otpController.text,
      );
      
      final authState = ref.read(authProvider);
      
      if (mounted && authState.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocalizationService.instance.getString('loginSuccess')),
          ),
        );
        context.go(AppRouter.home);
      } else if (mounted && authState.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.errorMessage ?? LocalizationService.instance.getString('loginError')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    final authState = ref.watch(authProvider);
    
    return ScreenScaffold(
      title: localizationService.getString('login'),
      showBackButton: false,
      body: authState.isLoading
          ? const LoadingState()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    
                    // App Logo
                    Icon(
                      Icons.store,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Text(
                      localizationService.getString('appName'),
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Phone Number Field
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: localizationService.getString('phoneNumber'),
                        prefixText: '+963 ',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizationService.getString('validationError');
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // OTP Field (shown after OTP is sent)
                    if (_isOtpSent) ...[
                      TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: localizationService.getString('otpCode'),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localizationService.getString('validationError');
                          }
                          return null;
                      },
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Submit Button
                    ElevatedButton(
                      onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
                      child: Text(
                        _isOtpSent
                            ? localizationService.getString('verifyOtp')
                            : localizationService.getString('sendOtp'),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Sign Up Link
                    TextButton(
                      onPressed: () => context.go(AppRouter.signup),
                      child: Text(localizationService.getString('signup')),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
