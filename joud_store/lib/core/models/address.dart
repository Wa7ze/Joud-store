class Address {
  final String id;
  final String userId;
  final String governorate;
  final String city;
  final String streetDetails;
  final String? notes;
  final bool isDefault;

  Address({
    required this.id,
    required this.userId,
    required this.governorate,
    required this.city,
    required this.streetDetails,
    this.notes,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String,
      userId: json['userId'] as String,
      governorate: json['governorate'] as String,
      city: json['city'] as String,
      streetDetails: json['streetDetails'] as String,
      notes: json['notes'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'governorate': governorate,
      'city': city,
      'streetDetails': streetDetails,
      'notes': notes,
      'isDefault': isDefault,
    };
  }

  Address copyWith({
    String? id,
    String? userId,
    String? governorate,
    String? city,
    String? streetDetails,
    String? notes,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      streetDetails: streetDetails ?? this.streetDetails,
      notes: notes ?? this.notes,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
