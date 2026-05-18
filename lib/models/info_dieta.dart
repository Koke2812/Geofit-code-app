class InfoDisenoDieta {
  final int idUsuario;
  final int edad;
  final double altura;
  final double peso;
  final String sexo;
  final String objetivo;
  final String nivelActividad;

  InfoDisenoDieta({
    required this.idUsuario,
    required this.edad,
    required this.altura,
    required this.peso,
    required this.sexo,
    required this.objetivo,
    required this.nivelActividad,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'edad': edad,
      'altura': altura,
      'peso': peso,
      'sexo': sexo,
      'objetivo': objetivo,
      'nivel_actividad': nivelActividad,
    };
  }

  factory InfoDisenoDieta.fromMap(Map<String, dynamic> map) {
    return InfoDisenoDieta(
      idUsuario: map['id_usuario'],
      edad: map['edad'],
      altura: (map['altura'] as num).toDouble(),
      peso: (map['peso'] as num).toDouble(),
      sexo: map['sexo'],
      objetivo: map['objetivo'],
      nivelActividad: map['nivel_actividad'],
    );
  }
}
