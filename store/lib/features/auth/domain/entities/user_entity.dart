import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? imageUrl;

  const UserEntity({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, email, firstName, lastName, phoneNumber, imageUrl];
}
