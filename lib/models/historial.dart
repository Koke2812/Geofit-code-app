class Historial {
  final int? id;
  final int idUsuario;
  final double caloriasTotales;
  final double proteinasTotales;
  final double carbohidratosTotales;
  final double grasasTotales;
  final String detalle;
  final String fecha;

  Historial({
    this.id,
    required this.idUsuario,
    required this.caloriasTotales,
    required this.proteinasTotales,
    required this.carbohidratosTotales,
    required this.grasasTotales,
    required this.detalle,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_usuario': idUsuario,
      'calorias_totales': caloriasTotales,
      'proteinas_totales': proteinasTotales,
      'carbohidratos_totales': carbohidratosTotales,
      'grasas_totales': grasasTotales,
      'detalle': detalle,
      'fecha': fecha,
    };
  }

  factory Historial.fromMap(Map<String, dynamic> map) {
    return Historial(
      id: map['id'],
      idUsuario: map['id_usuario'],
      caloriasTotales: (map['calorias_totales'] as num).toDouble(),
      proteinasTotales: (map['proteinas_totales'] as num).toDouble(),
      carbohidratosTotales: (map['carbohidratos_totales'] as num).toDouble(),
      grasasTotales: (map['grasas_totales'] as num).toDouble(),
      detalle: map['detalle'] ?? '',
      fecha: map['fecha'] ?? '',
    );
  }
}
