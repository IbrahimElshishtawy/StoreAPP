import 'package:flutter_test/flutter_test.dart';
import 'package:store/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    const tUserModel = UserModel(
      id: '1',
      email: 'test@example.com',
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '123456789',
      imageUrl: 'https://example.com/image.jpg',
      interests: ['electronics', 'watches'],
    );

    test('should be a subclass of UserEntity', () {
      expect(tUserModel, isA<UserModel>());
    });

    test('fromFirestore should return a valid model', () {
      final Map<String, dynamic> jsonMap = {
        'email': 'test@example.com',
        'firstName': 'John',
        'lastName': 'Doe',
        'phoneNumber': '123456789',
        'imageUrl': 'https://example.com/image.jpg',
        'interests': ['electronics', 'watches'],
      };

      final result = UserModel.fromFirestore(jsonMap, '1');

      expect(result, tUserModel);
    });

    test('toJson should return a JSON map containing proper data', () {
      final result = tUserModel.toJson();

      final expectedMap = {
        'email': 'test@example.com',
        'firstName': 'John',
        'lastName': 'Doe',
        'phoneNumber': '123456789',
        'imageUrl': 'https://example.com/image.jpg',
        'interests': ['electronics', 'watches'],
      };

      expect(result, expectedMap);
    });
  });
}
