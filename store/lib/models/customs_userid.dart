// ignore_for_file: file_names

class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String address;
  final String email;
  final String phone;
  final String? password;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.email,
    required this.phone,
    this.password,
  });

  factory UserProfile.fromMap(Map<String, dynamic> data, String documentId) {
    return UserProfile(
      id: documentId,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      address: data['address'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      password: data['password'] ?? '',
    );
  }
}
