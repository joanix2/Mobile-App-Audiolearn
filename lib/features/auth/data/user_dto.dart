/// DTO aligné sur la charge utile renvoyée par `login`/`signup`.
/// (Champs: voir Tickets API login → token + user.*)
class UserDto {
  final String id;
  final String email;
  final String? fullName;
  final bool? isEmailVerified;
  final String? createdAt; // ISO
  final String? deletedAt; // ISO

  UserDto({
    required this.id,
    required this.email,
    this.fullName,
    this.isEmailVerified,
    this.createdAt,
    this.deletedAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'] as String,
    email: json['email'] as String,
    fullName: json['fullName'] as String?,
    isEmailVerified: json['isEmailVerified'] as bool?,
    createdAt: json['createdAt'] as String?,
    deletedAt: json['deletedAt'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    if (fullName != null) 'fullName': fullName,
    if (isEmailVerified != null) 'isEmailVerified': isEmailVerified,
    if (createdAt != null) 'createdAt': createdAt,
    if (deletedAt != null) 'deletedAt': deletedAt,
  };
}
