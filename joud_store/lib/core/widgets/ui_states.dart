import 'package:flutter/material.dart';
import '../../core/localization/localization_service.dart';

/// Loading state widget
class LoadingState extends StatelessWidget {
  final String? message;
  
  const LoadingState({super.key, this.message});
  
  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ] else ...[
            const SizedBox(height: 16),
            Text(
              localizationService.getString('loading'),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state widget
class EmptyState extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final VoidCallback? onRetry;
  
  const EmptyState({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              title ?? localizationService.getString('noProducts'),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(localizationService.getString('retry')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state widget
class ErrorState extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  
  const ErrorState({
    super.key,
    this.title,
    this.message,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              title ?? localizationService.getString('error'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message ?? localizationService.getString('unknownError'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(localizationService.getString('retry')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Offline banner widget
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});
  
  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Theme.of(context).colorScheme.errorContainer,
      child: Row(
        children: [
          Icon(
            Icons.wifi_off,
            color: Theme.of(context).colorScheme.onErrorContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              localizationService.getString('offline'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Generic screen scaffold with common functionality
class ScreenScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  
  const ScreenScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = true,
    this.onBackPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
            : null,
        actions: actions,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
