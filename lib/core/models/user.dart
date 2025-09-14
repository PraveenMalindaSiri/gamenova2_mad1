class User {
  final int id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String? password;
  final String? confPassword;
  final String? twoFactorSecret;
  final String? twoFactorRecoveryCodes;
  final DateTime? twoFactorConfirmedAt;
  final String? rememberToken;
  final int? currentTeamId;
  final String? profilePhotoPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String role; // 'customer', 'seller', 'admin'
  final String? phone;
  final String? address;
  final DateTime? dob;
  final DateTime? deletedAt;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.password,
    this.confPassword,
    this.twoFactorSecret,
    this.twoFactorRecoveryCodes,
    this.twoFactorConfirmedAt,
    this.rememberToken,
    this.currentTeamId,
    this.profilePhotoPath,
    this.createdAt,
    this.updatedAt,
    required this.role,
    this.phone,
    this.address,
    this.dob,
    this.deletedAt,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      password: json['password'] as String?,
      twoFactorSecret: json['two_factor_secret'],
      twoFactorRecoveryCodes: json['two_factor_recovery_codes'],
      twoFactorConfirmedAt: json['two_factor_confirmed_at'] != null
          ? DateTime.parse(json['two_factor_confirmed_at'])
          : null,
      rememberToken: json['remember_token'],
      currentTeamId: json['current_team_id'],
      profilePhotoPath: json['profile_photo_path'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      role: json['role'] as String,
      phone: json['phone'],
      address: json['address'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      token: json['token'] as String?,
    );
  }
}

class UserValidations {
  static String? validEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value) ? null : 'Enter a valid email address';
  }

  static String? validPassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? validConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? validName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (value.length < 8) return 'Name must be at least 8 characters';
    return null;
  }

  static String? validDob(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final v = value.trim();
    final iso = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!iso.hasMatch(v)) return 'Use format YYYY-MM-DD';
    final dt = DateTime.tryParse(v);
    if (dt == null) return 'Invalid date';
    if (!dt.isBefore(DateTime.now())) return 'DOB must be before today';
    return null;
  }
}
