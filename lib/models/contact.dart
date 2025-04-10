class Contact {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String? email;
  final String? alias;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Contact({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    this.email,
    this.alias,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Contact.fromSupabase(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['nombre'] as String,
      phone: map['telefono'] as String,
      email: map['correo'] as String?,
      alias: map['alias'] as String?,
      notes: map['notas'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toSupabaseMap() {
    return {
      'user_id': userId,
      'nombre': name,
      'telefono': phone,
      'correo': email,
      'alias': alias,
      'notas': notes,
      // Eliminado el campo rol_id
    };
  }

  Contact copyWith({
    String? name,
    String? phone,
    String? email,
    String? alias,
    String? notes,
  }) {
    return Contact(
      id: id,
      userId: userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      alias: alias ?? this.alias,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, phone: $phone)';
  }
}