/// Modelo User - Usuario autenticado del sistema
/// Equivalente al modelo User de Laravel (app/Models/User.php)
class User {
  final int id;
  final String name;
  final String? apellido;
  final String email;
  final String? telefono;
  final String? ci;
  final String? password;
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    this.apellido,
    required this.email,
    this.telefono,
    this.ci,
    this.password,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      apellido: json['apellido'] as String?,
      email: json['email'] as String,
      telefono: json['telefono'] as String?,
      ci: json['ci'] as String?,
      password: json['password'] as String?,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'apellido': apellido,
      'email': email,
      'telefono': telefono,
      'ci': ci,
      'password': password,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get nombreCompleto => '$name ${apellido ?? ''}'.trim();
}
