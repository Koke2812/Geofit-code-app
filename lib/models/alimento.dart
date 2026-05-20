class Alimento {
  final String nombre;
  final double calorias;
  final double proteina;
  final double carbohidratos;
  final double grasas;

  Alimento({
    required this.nombre,
    required this.calorias,
    required this.proteina,
    required this.carbohidratos,
    required this.grasas,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'calorias': calorias,
      'proteina': proteina,
      'carbohidratos': carbohidratos,
      'grasas': grasas,
    };
  }

  factory Alimento.fromMap(Map<String, dynamic> map) {
    return Alimento(
      nombre: map['nombre'],
      calorias: (map['calorias'] as num).toDouble(),
      proteina: (map['proteina'] as num).toDouble(),
      carbohidratos: (map['carbohidratos'] as num).toDouble(),
      grasas: (map['grasas'] as num).toDouble(),
    );
  }
}
