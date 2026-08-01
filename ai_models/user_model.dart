class UserModel {
  final String uid;
  final String email;
  final String role;
  final String displayName;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.displayName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['user_id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'parent',
      displayName: json['display_name'] ?? '',
    );
  }
}
