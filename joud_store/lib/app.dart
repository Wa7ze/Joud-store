import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_localization.dart';
import 'core/localization/localization_service.dart';
import 'core/router/app_router.dart';
import 'features/settings/providers/settings_provider.dart';

class SyStoreApp extends ConsumerWidget {
  const SyStoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final localizationService = LocalizationService.instance;
    
    // Set locale from settings
    localizationService.setLocale(settings.locale);
    
    return MaterialApp.router(
      title: localizationService.getString('appName'),
      debugShowCheckedModeBanner: false,
      
      // Router
      routerConfig: AppRouter.router,
      
      // Localization
      locale: settings.locale,
      supportedLocales: AppLocalization.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      
      // RTL Support
      builder: (context, child) {
        return Directionality(
          textDirection: localizationService.textDirection,
          child: child!,
        );
      },
    );
  }
}
