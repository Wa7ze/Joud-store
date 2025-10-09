/// Application configuration and environment flags
class AppConfig {
  static const bool mockMode = true; // Frontend-only mode
  static const String defaultCurrency = 'SYP';
  static const String defaultLanguage = 'en';
  static const String fallbackLanguage = 'ar';
  
  // Syria-specific settings
  static const String countryCode = 'SY';
  static const String phoneCountryCode = '+963';
  
  // Mock delivery fees (per city)
  static const Map<String, double> deliveryFees = {
    'damascus': 5000.0,
    'aleppo': 6000.0,
    'homs': 5500.0,
    'latakia': 7000.0,
    'hama': 5000.0,
    'deir_ez_zor': 8000.0,
    'raqqa': 7500.0,
    'hasaka': 8000.0,
    'tartus': 6000.0,
    'idlib': 6500.0,
    'quneitra': 6000.0,
    'daraa': 7000.0,
    'sweida': 6500.0,
  };
  
  // Business hours for support
  static const String businessHours = '9:00 AM - 6:00 PM';
  static const String supportPhone = '+963-11-123-4567';
  static const String whatsappNumber = '+963-11-123-4567';
}
