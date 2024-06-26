import 'dart:convert';

class User {
  String userId;
  String firstName;
  String lastName;
  String token;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.token,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        token: json["token"],
      );
}
