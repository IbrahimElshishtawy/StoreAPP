// ignore_for_file: file_names

class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String address;
  final String email;
  final String phone;
  final String? password;
  final String? imageUrl; // ✅ شيلنا late
  final List<String> interests;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.email,
    required this.phone,
    this.password,
    this.imageUrl,
    this.interests = const [],
  });

  factory UserProfile.fromMap(Map<String, dynamic> data, String documentId) {
    return UserProfile(
      id: documentId,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      address: data['address'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      password: data['password'],
      imageUrl: data['imageUrl'],
      interests: List<String>.from(data['interests'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'email': email,
      'phone': phone,
      if (password != null) 'password': password,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'interests': interests,
    };
  }
}
