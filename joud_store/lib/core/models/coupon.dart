enum CouponType {
  percentage,
  fixed,
}

class Coupon {
  final String code;
  final CouponType type;
  final double value;
  final double minSubtotal;
  final DateTime expiry;
  final int usageLimit;
  final int usageCount;

  Coupon({
    required this.code,
    required this.type,
    required this.value,
    required this.minSubtotal,
    required this.expiry,
    required this.usageLimit,
    this.usageCount = 0,
  });

  bool get isExpired => DateTime.now().isAfter(expiry);
  bool get isUsageLimitReached => usageCount >= usageLimit;
  bool get isValid => !isExpired && !isUsageLimitReached;

  double calculateDiscount(double subtotal) {
    if (!isValid || subtotal < minSubtotal) return 0;
    
    switch (type) {
      case CouponType.percentage:
        return (subtotal * value / 100).roundToDouble();
      case CouponType.fixed:
        return value;
    }
  }

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      code: json['code'] as String,
      type: CouponType.values.firstWhere((e) => e.toString() == json['type']),
      value: json['value'] as double,
      minSubtotal: json['minSubtotal'] as double,
      expiry: DateTime.parse(json['expiry'] as String),
      usageLimit: json['usageLimit'] as int,
      usageCount: json['usageCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'type': type.toString(),
      'value': value,
      'minSubtotal': minSubtotal,
      'expiry': expiry.toIso8601String(),
      'usageLimit': usageLimit,
      'usageCount': usageCount,
    };
  }
}
