import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final DateTime createdAt;
  final String? photoUrl;

  const User({
    required this.id,
    required this.email,
    this.name,
    required this.createdAt,
    this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        photoUrl: json['photo_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'created_at': createdAt.toIso8601String(),
        'photo_url': photoUrl,
      };

  @override
  List<Object?> get props => [id, email, name, createdAt, photoUrl];
}
