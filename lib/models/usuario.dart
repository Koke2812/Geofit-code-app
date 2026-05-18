class Usuario {
  final int? id;
  final String usuario;
  final String contrasena;
  final double saldo;
  final bool dietaPagada;
  final String? fotoPath;

  Usuario({
    this.id,
    required this.usuario,
    required this.contrasena,
    this.saldo = 15.50,
    this.dietaPagada = false,
    this.fotoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario': usuario,
      'contrasena': contrasena,
      'saldo': saldo,
      'dieta_pagada': dietaPagada ? 1 : 0,
      'foto_path': fotoPath,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      usuario: map['usuario'],
      contrasena: map['contrasena'],
      saldo: (map['saldo'] as num?)?.toDouble() ?? 0,
      dietaPagada: (map['dieta_pagada'] as int?) == 1,
      fotoPath: map['foto_path'],
    );
  }
}
