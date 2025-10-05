/// Localization service for managing app strings
import 'package:flutter/material.dart';
import 'strings_ar.dart';
import 'strings_en.dart';

class LocalizationService {
  static LocalizationService? _instance;
  static LocalizationService get instance => _instance ??= LocalizationService._();
  
  LocalizationService._();
  
  Locale _currentLocale = const Locale('ar', 'SY');
  
  Locale get currentLocale => _currentLocale;
  
  void setLocale(Locale locale) {
    _currentLocale = locale;
  }
  
  bool get isRTL => _currentLocale.languageCode == 'ar';
  
  TextDirection get textDirection => isRTL ? TextDirection.rtl : TextDirection.ltr;
  
  String getString(String key) {
    switch (_currentLocale.languageCode) {
      case 'ar':
        return _getArabicString(key);
      case 'en':
        return _getEnglishString(key);
      default:
        return _getArabicString(key); // Default to Arabic
    }
  }
  
  String _getArabicString(String key) {
    switch (key) {
      // App
      case 'appName': return AppStringsAr.appName;
      case 'appDescription': return AppStringsAr.appDescription;
      
      // Common
      case 'loading': return AppStringsAr.loading;
      case 'error': return AppStringsAr.error;
      case 'retry': return AppStringsAr.retry;
      case 'cancel': return AppStringsAr.cancel;
      case 'confirm': return AppStringsAr.confirm;
      case 'save': return AppStringsAr.save;
      case 'edit': return AppStringsAr.edit;
      case 'delete': return AppStringsAr.delete;
      case 'add': return AppStringsAr.add;
      case 'remove': return AppStringsAr.remove;
      case 'search': return AppStringsAr.search;
      case 'filter': return AppStringsAr.filter;
      case 'sort': return AppStringsAr.sort;
      case 'clear': return AppStringsAr.clear;
      case 'apply': return AppStringsAr.apply;
      case 'next': return AppStringsAr.next;
      case 'previous': return AppStringsAr.previous;
      case 'done': return AppStringsAr.done;
      case 'close': return AppStringsAr.close;
      case 'back': return AppStringsAr.back;
      case 'home': return AppStringsAr.home;
      case 'profile': return AppStringsAr.profile;
      case 'settings': return AppStringsAr.settings;
      case 'notifications': return AppStringsAr.notifications;
      case 'cart': return AppStringsAr.cart;
      case 'orders': return AppStringsAr.orders;
      case 'categories': return AppStringsAr.categories;
      case 'products': return AppStringsAr.products;
      case 'price': return AppStringsAr.price;
      case 'quantity': return AppStringsAr.quantity;
      case 'total': return AppStringsAr.total;
      case 'subtotal': return AppStringsAr.subtotal;
      case 'delivery': return AppStringsAr.delivery;
      case 'discount': return AppStringsAr.discount;
      case 'coupon': return AppStringsAr.coupon;
      case 'applyCoupon': return AppStringsAr.applyCoupon;
      case 'couponCode': return AppStringsAr.couponCode;
      case 'validCoupon': return AppStringsAr.validCoupon;
      case 'invalidCoupon': return AppStringsAr.invalidCoupon;
      case 'expiredCoupon': return AppStringsAr.expiredCoupon;
      case 'minOrderAmount': return AppStringsAr.minOrderAmount;
      case 'currency': return AppStringsAr.currency;
      
      // Navigation
      case 'splash': return AppStringsAr.splash;
      case 'login': return AppStringsAr.login;
      case 'signup': return AppStringsAr.signup;
      case 'forgotPassword': return AppStringsAr.forgotPassword;
      case 'productDetails': return AppStringsAr.productDetails;
      case 'productList': return AppStringsAr.productList;
      case 'checkout': return AppStringsAr.checkout;
      case 'addressBook': return AppStringsAr.addressBook;
      case 'orderDetails': return AppStringsAr.orderDetails;
      case 'customerSupport': return AppStringsAr.customerSupport;
      case 'termsOfService': return AppStringsAr.termsOfService;
      case 'privacyPolicy': return AppStringsAr.privacyPolicy;
      case 'returnPolicy': return AppStringsAr.returnPolicy;
      
      // Legal
      case 'termsOfServiceTitle': return AppStringsAr.termsOfServiceTitle;
      case 'termsOfServiceIntro': return AppStringsAr.termsOfServiceIntro;
      case 'accountTermsTitle': return AppStringsAr.accountTermsTitle;
      case 'accountTermsContent': return AppStringsAr.accountTermsContent;
      case 'purchaseTermsTitle': return AppStringsAr.purchaseTermsTitle;
      case 'purchaseTermsContent': return AppStringsAr.purchaseTermsContent;
      case 'deliveryTermsTitle': return AppStringsAr.deliveryTermsTitle;
      case 'deliveryTermsContent': return AppStringsAr.deliveryTermsContent;
      case 'cancellationTermsTitle': return AppStringsAr.cancellationTermsTitle;
      case 'cancellationTermsContent': return AppStringsAr.cancellationTermsContent;
      case 'privacyTermsTitle': return AppStringsAr.privacyTermsTitle;
      case 'privacyTermsContent': return AppStringsAr.privacyTermsContent;
      case 'changesTermsTitle': return AppStringsAr.changesTermsTitle;
      case 'changesTermsContent': return AppStringsAr.changesTermsContent;
      case 'termsLastUpdated': return AppStringsAr.termsLastUpdated;
      case 'privacyPolicyTitle': return AppStringsAr.privacyPolicyTitle;
      case 'privacyPolicyIntro': return AppStringsAr.privacyPolicyIntro;
      case 'dataCollectionTitle': return AppStringsAr.dataCollectionTitle;
      case 'dataCollectionContent': return AppStringsAr.dataCollectionContent;
      case 'dataUsageTitle': return AppStringsAr.dataUsageTitle;
      case 'dataUsageContent': return AppStringsAr.dataUsageContent;
      case 'dataProtectionTitle': return AppStringsAr.dataProtectionTitle;
      case 'dataProtectionContent': return AppStringsAr.dataProtectionContent;
      case 'cookiesTitle': return AppStringsAr.cookiesTitle;
      case 'cookiesContent': return AppStringsAr.cookiesContent;
      case 'thirdPartyTitle': return AppStringsAr.thirdPartyTitle;
      case 'thirdPartyContent': return AppStringsAr.thirdPartyContent;
      case 'privacyLastUpdated': return AppStringsAr.privacyLastUpdated;
      case 'returnPolicyTitle': return AppStringsAr.returnPolicyTitle;
      case 'returnPolicyIntro': return AppStringsAr.returnPolicyIntro;
      case 'eligibilityTitle': return AppStringsAr.eligibilityTitle;
      case 'eligibilityContent': return AppStringsAr.eligibilityContent;
      case 'processTitle': return AppStringsAr.processTitle;
      case 'processContent': return AppStringsAr.processContent;
      case 'refundsTitle': return AppStringsAr.refundsTitle;
      case 'refundsContent': return AppStringsAr.refundsContent;
      case 'nonReturnableTitle': return AppStringsAr.nonReturnableTitle;
      case 'nonReturnableContent': return AppStringsAr.nonReturnableContent;
      case 'damagesTitle': return AppStringsAr.damagesTitle;
      case 'damagesContent': return AppStringsAr.damagesContent;
      case 'returnLastUpdated': return AppStringsAr.returnLastUpdated;
      
      // Auth
      case 'phoneNumber': return AppStringsAr.phoneNumber;
      case 'email': return AppStringsAr.email;
      case 'password': return AppStringsAr.password;
      case 'confirmPassword': return AppStringsAr.confirmPassword;
      case 'otpCode': return AppStringsAr.otpCode;
      case 'sendOtp': return AppStringsAr.sendOtp;
      case 'verifyOtp': return AppStringsAr.verifyOtp;
      case 'resendOtp': return AppStringsAr.resendOtp;
      case 'loginSuccess': return AppStringsAr.loginSuccess;
      case 'signupSuccess': return AppStringsAr.signupSuccess;
      case 'logout': return AppStringsAr.logout;
      
      // Address
      case 'address': return AppStringsAr.address;
      case 'governorate': return AppStringsAr.governorate;
      case 'city': return AppStringsAr.city;
      case 'area': return AppStringsAr.area;
      case 'street': return AppStringsAr.street;
      case 'building': return AppStringsAr.building;
      case 'floor': return AppStringsAr.floor;
      case 'apartment': return AppStringsAr.apartment;
      case 'notes': return AppStringsAr.notes;
      case 'defaultAddress': return AppStringsAr.defaultAddress;
      case 'addAddress': return AppStringsAr.addAddress;
      case 'editAddress': return AppStringsAr.editAddress;
      case 'selectAddress': return AppStringsAr.selectAddress;
      
      // Order
      case 'orderNumber': return AppStringsAr.orderNumber;
      case 'orderDate': return AppStringsAr.orderDate;
      case 'orderStatus': return AppStringsAr.orderStatus;
      case 'orderTotal': return AppStringsAr.orderTotal;
      case 'paymentMethod': return AppStringsAr.paymentMethod;
      case 'paymentStatus': return AppStringsAr.paymentStatus;
      case 'deliveryMethod': return AppStringsAr.deliveryMethod;
      case 'deliveryDate': return AppStringsAr.deliveryDate;
      case 'deliveryTime': return AppStringsAr.deliveryTime;
      case 'orderPlaced': return AppStringsAr.orderPlaced;
      case 'orderConfirmed': return AppStringsAr.orderConfirmed;
      case 'orderShipped': return AppStringsAr.orderShipped;
      case 'orderDelivered': return AppStringsAr.orderDelivered;
      case 'orderCancelled': return AppStringsAr.orderCancelled;
      case 'cashOnDelivery': return AppStringsAr.cashOnDelivery;
      case 'placeOrder': return AppStringsAr.placeOrder;
      case 'orderSuccess': return AppStringsAr.orderSuccess;
      
      // Syria Governorates
      case 'damascus': return AppStringsAr.damascus;
      case 'aleppo': return AppStringsAr.aleppo;
      case 'homs': return AppStringsAr.homs;
      case 'latakia': return AppStringsAr.latakia;
      case 'hama': return AppStringsAr.hama;
      case 'deirEzZor': return AppStringsAr.deirEzZor;
      case 'raqqa': return AppStringsAr.raqqa;
      case 'hasaka': return AppStringsAr.hasaka;
      case 'tartus': return AppStringsAr.tartus;
      case 'idlib': return AppStringsAr.idlib;
      case 'quneitra': return AppStringsAr.quneitra;
      case 'daraa': return AppStringsAr.daraa;
      case 'sweida': return AppStringsAr.sweida;
      
      // Settings
      case 'language': return AppStringsAr.language;
      case 'darkMode': return AppStringsAr.darkMode;
      case 'currencyDisplay': return AppStringsAr.currencyDisplay;
      case 'showEquivalent': return AppStringsAr.showEquivalent;
      case 'notificationsEnabled': return AppStringsAr.notificationsEnabled;
      case 'about': return AppStringsAr.about;
      case 'version': return AppStringsAr.version;
      
      // Support
      case 'contactUs': return AppStringsAr.contactUs;
      case 'whatsapp': return AppStringsAr.whatsapp;
      case 'call': return AppStringsAr.call;
      case 'businessHours': return AppStringsAr.businessHours;
      case 'supportMessage': return AppStringsAr.supportMessage;
      
      // Errors
      case 'networkError': return AppStringsAr.networkError;
      case 'serverError': return AppStringsAr.serverError;
      case 'unknownError': return AppStringsAr.unknownError;
      case 'validationError': return AppStringsAr.validationError;
      case 'notFound': return AppStringsAr.notFound;
      case 'unauthorized': return AppStringsAr.unauthorized;
      case 'forbidden': return AppStringsAr.forbidden;
      case 'timeout': return AppStringsAr.timeout;
      case 'offline': return AppStringsAr.offline;
      case 'noInternetConnection': return AppStringsAr.noInternetConnection;
      
      // Empty states
      case 'noProducts': return AppStringsAr.noProducts;
      case 'noOrders': return AppStringsAr.noOrders;
      case 'noNotifications': return AppStringsAr.noNotifications;
      case 'noAddresses': return AppStringsAr.noAddresses;
      case 'noCoupons': return AppStringsAr.noCoupons;
      case 'noSearchResults': return AppStringsAr.noSearchResults;
      case 'emptyCart': return AppStringsAr.emptyCart;
      
      // Success messages
      case 'productAddedToCart': return AppStringsAr.productAddedToCart;
      case 'productRemovedFromCart': return AppStringsAr.productRemovedFromCart;
      case 'addressAdded': return AppStringsAr.addressAdded;
      case 'addressUpdated': return AppStringsAr.addressUpdated;
      case 'addressDeleted': return AppStringsAr.addressDeleted;
      case 'couponApplied': return AppStringsAr.couponApplied;
      case 'settingsSaved': return AppStringsAr.settingsSaved;
      
      default:
        return key; // Return key if not found
    }
  }
  
  String _getEnglishString(String key) {
    switch (key) {
      // App
      case 'appName': return AppStringsEn.appName;
      case 'appDescription': return AppStringsEn.appDescription;
      
      // Common
      case 'loading': return AppStringsEn.loading;
      case 'error': return AppStringsEn.error;
      case 'retry': return AppStringsEn.retry;
      case 'cancel': return AppStringsEn.cancel;
      case 'confirm': return AppStringsEn.confirm;
      case 'save': return AppStringsEn.save;
      case 'edit': return AppStringsEn.edit;
      case 'delete': return AppStringsEn.delete;
      case 'add': return AppStringsEn.add;
      case 'remove': return AppStringsEn.remove;
      case 'search': return AppStringsEn.search;
      case 'filter': return AppStringsEn.filter;
      case 'sort': return AppStringsEn.sort;
      case 'clear': return AppStringsEn.clear;
      case 'apply': return AppStringsEn.apply;
      case 'next': return AppStringsEn.next;
      case 'previous': return AppStringsEn.previous;
      case 'done': return AppStringsEn.done;
      case 'close': return AppStringsEn.close;
      case 'back': return AppStringsEn.back;
      case 'home': return AppStringsEn.home;
      case 'profile': return AppStringsEn.profile;
      case 'settings': return AppStringsEn.settings;
      case 'notifications': return AppStringsEn.notifications;
      case 'cart': return AppStringsEn.cart;
      case 'orders': return AppStringsEn.orders;
      case 'categories': return AppStringsEn.categories;
      case 'products': return AppStringsEn.products;
      case 'price': return AppStringsEn.price;
      case 'quantity': return AppStringsEn.quantity;
      case 'total': return AppStringsEn.total;
      case 'subtotal': return AppStringsEn.subtotal;
      case 'delivery': return AppStringsEn.delivery;
      case 'discount': return AppStringsEn.discount;
      case 'coupon': return AppStringsEn.coupon;
      case 'applyCoupon': return AppStringsEn.applyCoupon;
      case 'couponCode': return AppStringsEn.couponCode;
      case 'validCoupon': return AppStringsEn.validCoupon;
      case 'invalidCoupon': return AppStringsEn.invalidCoupon;
      case 'expiredCoupon': return AppStringsEn.expiredCoupon;
      case 'minOrderAmount': return AppStringsEn.minOrderAmount;
      case 'currency': return AppStringsEn.currency;
      
      // Navigation
      case 'splash': return AppStringsEn.splash;
      case 'login': return AppStringsEn.login;
      case 'signup': return AppStringsEn.signup;
      case 'forgotPassword': return AppStringsEn.forgotPassword;
      case 'productDetails': return AppStringsEn.productDetails;
      case 'productList': return AppStringsEn.productList;
      case 'checkout': return AppStringsEn.checkout;
      case 'addressBook': return AppStringsEn.addressBook;
      case 'orderDetails': return AppStringsEn.orderDetails;
      case 'customerSupport': return AppStringsEn.customerSupport;
      case 'termsOfService': return AppStringsEn.termsOfService;
      case 'privacyPolicy': return AppStringsEn.privacyPolicy;
      case 'returnPolicy': return AppStringsEn.returnPolicy;
      
      // Auth
      case 'phoneNumber': return AppStringsEn.phoneNumber;
      case 'email': return AppStringsEn.email;
      case 'password': return AppStringsEn.password;
      case 'confirmPassword': return AppStringsEn.confirmPassword;
      case 'otpCode': return AppStringsEn.otpCode;
      case 'sendOtp': return AppStringsEn.sendOtp;
      case 'verifyOtp': return AppStringsEn.verifyOtp;
      case 'resendOtp': return AppStringsEn.resendOtp;
      case 'loginSuccess': return AppStringsEn.loginSuccess;
      case 'signupSuccess': return AppStringsEn.signupSuccess;
      case 'logout': return AppStringsEn.logout;
      
      // Address
      case 'address': return AppStringsEn.address;
      case 'governorate': return AppStringsEn.governorate;
      case 'city': return AppStringsEn.city;
      case 'area': return AppStringsEn.area;
      case 'street': return AppStringsEn.street;
      case 'building': return AppStringsEn.building;
      case 'floor': return AppStringsEn.floor;
      case 'apartment': return AppStringsEn.apartment;
      case 'notes': return AppStringsEn.notes;
      case 'defaultAddress': return AppStringsEn.defaultAddress;
      case 'addAddress': return AppStringsEn.addAddress;
      case 'editAddress': return AppStringsEn.editAddress;
      case 'selectAddress': return AppStringsEn.selectAddress;
      
      // Order
      case 'orderNumber': return AppStringsEn.orderNumber;
      case 'orderDate': return AppStringsEn.orderDate;
      case 'orderStatus': return AppStringsEn.orderStatus;
      case 'orderTotal': return AppStringsEn.orderTotal;
      case 'paymentMethod': return AppStringsEn.paymentMethod;
      case 'paymentStatus': return AppStringsEn.paymentStatus;
      case 'deliveryMethod': return AppStringsEn.deliveryMethod;
      case 'deliveryDate': return AppStringsEn.deliveryDate;
      case 'deliveryTime': return AppStringsEn.deliveryTime;
      case 'orderPlaced': return AppStringsEn.orderPlaced;
      case 'orderConfirmed': return AppStringsEn.orderConfirmed;
      case 'orderShipped': return AppStringsEn.orderShipped;
      case 'orderDelivered': return AppStringsEn.orderDelivered;
      case 'orderCancelled': return AppStringsEn.orderCancelled;
      case 'cashOnDelivery': return AppStringsEn.cashOnDelivery;
      case 'placeOrder': return AppStringsEn.placeOrder;
      case 'orderSuccess': return AppStringsEn.orderSuccess;
      
      // Syria Governorates
      case 'damascus': return AppStringsEn.damascus;
      case 'aleppo': return AppStringsEn.aleppo;
      case 'homs': return AppStringsEn.homs;
      case 'latakia': return AppStringsEn.latakia;
      case 'hama': return AppStringsEn.hama;
      case 'deirEzZor': return AppStringsEn.deirEzZor;
      case 'raqqa': return AppStringsEn.raqqa;
      case 'hasaka': return AppStringsEn.hasaka;
      case 'tartus': return AppStringsEn.tartus;
      case 'idlib': return AppStringsEn.idlib;
      case 'quneitra': return AppStringsEn.quneitra;
      case 'daraa': return AppStringsEn.daraa;
      case 'sweida': return AppStringsEn.sweida;
      
      // Settings
      case 'language': return AppStringsEn.language;
      case 'darkMode': return AppStringsEn.darkMode;
      case 'currencyDisplay': return AppStringsEn.currencyDisplay;
      case 'showEquivalent': return AppStringsEn.showEquivalent;
      case 'notificationsEnabled': return AppStringsEn.notificationsEnabled;
      case 'about': return AppStringsEn.about;
      case 'version': return AppStringsEn.version;
      
      // Support
      case 'contactUs': return AppStringsEn.contactUs;
      case 'whatsapp': return AppStringsEn.whatsapp;
      case 'call': return AppStringsEn.call;
      case 'businessHours': return AppStringsEn.businessHours;
      case 'supportMessage': return AppStringsEn.supportMessage;
      
      // Errors
      case 'networkError': return AppStringsEn.networkError;
      case 'serverError': return AppStringsEn.serverError;
      case 'unknownError': return AppStringsEn.unknownError;
      case 'validationError': return AppStringsEn.validationError;
      case 'notFound': return AppStringsEn.notFound;
      case 'unauthorized': return AppStringsEn.unauthorized;
      case 'forbidden': return AppStringsEn.forbidden;
      case 'timeout': return AppStringsEn.timeout;
      case 'offline': return AppStringsEn.offline;
      case 'noInternetConnection': return AppStringsEn.noInternetConnection;
      
      // Empty states
      case 'noProducts': return AppStringsEn.noProducts;
      case 'noOrders': return AppStringsEn.noOrders;
      case 'noNotifications': return AppStringsEn.noNotifications;
      case 'noAddresses': return AppStringsEn.noAddresses;
      case 'noCoupons': return AppStringsEn.noCoupons;
      case 'noSearchResults': return AppStringsEn.noSearchResults;
      case 'emptyCart': return AppStringsEn.emptyCart;
      
      // Success messages
      case 'productAddedToCart': return AppStringsEn.productAddedToCart;
      case 'productRemovedFromCart': return AppStringsEn.productRemovedFromCart;
      case 'addressAdded': return AppStringsEn.addressAdded;
      case 'addressUpdated': return AppStringsEn.addressUpdated;
      case 'addressDeleted': return AppStringsEn.addressDeleted;
      case 'couponApplied': return AppStringsEn.couponApplied;
      case 'settingsSaved': return AppStringsEn.settingsSaved;
      
      default:
        return key; // Return key if not found
    }
  }
}
