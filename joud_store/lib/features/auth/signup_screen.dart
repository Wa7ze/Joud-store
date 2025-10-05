import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/router/app_router.dart';
import 'providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authProvider.notifier).signUp(
        _nameController.text,
        _phoneController.text,
        _emailController.text,
        _passwordController.text,
      );
      
      final authState = ref.read(authProvider);
      
      if (mounted && authState.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocalizationService.instance.getString('signupSuccess')),
          ),
        );
        context.go(AppRouter.home);
      } else if (mounted && authState.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.errorMessage ?? LocalizationService.instance.getString('signupError')),
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
      title: localizationService.getString('signup'),
      showBackButton: false,
      body: authState.isLoading
          ? const LoadingState()
          : SingleChildScrollView(
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
                      localizationService.getString('signup'),
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'الاسم الكامل', // Full Name
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
                    
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: localizationService.getString('email'),
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
                    
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: localizationService.getString('password'),
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
                    
                    // Confirm Password Field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: localizationService.getString('confirmPassword'),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizationService.getString('validationError');
                        }
                        if (value != _passwordController.text) {
                          return 'كلمات المرور غير متطابقة'; // Passwords don't match
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Sign Up Button
                    ElevatedButton(
                      onPressed: _signUp,
                      child: Text(localizationService.getString('signup')),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Login Link
                    TextButton(
                      onPressed: () => context.go(AppRouter.login),
                      child: Text(localizationService.getString('login')),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
