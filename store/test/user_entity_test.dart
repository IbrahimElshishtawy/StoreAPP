import 'package:flutter_test/flutter_test.dart';
import 'package:store/features/auth/domain/entities/user_entity.dart';

void main() {
  test('UserEntity should support value equality', () {
    const user1 = UserEntity(id: '1', email: 'test@example.com');
    const user2 = UserEntity(id: '1', email: 'test@example.com');
    const user3 = UserEntity(id: '2', email: 'test@example.com');

    expect(user1, equals(user2));
    expect(user1, isNot(equals(user3)));
  });
}
