class User {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? imageUrl;

  const User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.imageUrl,
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return firstName ?? lastName ?? '';
  }
}
