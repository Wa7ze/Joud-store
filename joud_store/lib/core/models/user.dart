class User {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? defaultAddressId;

  User({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.defaultAddressId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      defaultAddressId: json['defaultAddressId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'defaultAddressId': defaultAddressId,
    };
  }
}
