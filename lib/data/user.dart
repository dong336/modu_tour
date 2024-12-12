import 'package:firebase_database/firebase_database.dart';

class User {
  String id;
  String pw;
  String createTime;

  User({
    required this.id,
    required this.pw,
    required this.createTime,
  });

  factory User.fromSnapshot(DataSnapshot snapshot) {
    final value = snapshot.value as Map<dynamic, dynamic>?;

    if (value == null) {
      throw Exception('Snapshot value is null');
    }

    return User(
      id: value['id'] as String? ?? '',
      pw: value['pw'] as String? ?? '',
      createTime: value['createTime'] as String? ?? '',
    );
  }

  toJson() {
    return {
      'id': id,
      'pw': pw,
      'createTime': createTime,
    };
  }
}