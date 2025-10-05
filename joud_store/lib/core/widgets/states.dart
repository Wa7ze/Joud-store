import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';
import 'buttons.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: DesignTokens.spacing4),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: DesignTokens.spacing4),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: DesignTokens.spacing4),
              AppButton(
                text: 'Retry',
                onPressed: onRetry,
                variant: ButtonVariant.secondary,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyView({
    Key? key,
    required this.message,
    this.icon,
    this.onAction,
    this.actionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 48,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: DesignTokens.spacing4),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: DesignTokens.spacing4),
              AppButton(
                text: actionText!,
                onPressed: onAction,
                variant: ButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class OfflineBanner extends StatelessWidget {
  final VoidCallback? onRetry;

  const OfflineBanner({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.error,
      padding: const EdgeInsets.all(DesignTokens.spacing3),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: DesignTokens.spacing2),
          Expanded(
            child: Text(
              'You are offline',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacing3,
                ),
              ),
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }
}
