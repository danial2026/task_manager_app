import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime? lastLoginAt;

  const Profile({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.lastLoginAt,
  });

  Profile copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) =>
      Profile(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        photoUrl: photoUrl ?? this.photoUrl,
        lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      );

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        photoUrl: json['photo_url'] as String?,
        lastLoginAt: json['last_login_at'] != null ? DateTime.parse(json['last_login_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'photo_url': photoUrl,
        'last_login_at': lastLoginAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, name, email, photoUrl, lastLoginAt];
}
