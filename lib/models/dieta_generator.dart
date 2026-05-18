import 'package:geofit/models/info_dieta.dart';

class DietaPlan {
  final double caloriasObjetivo;
  final double proteinasGramos;
  final double carbohidratosGramos;
  final double grasasGramos;
  final String resumenObjetivo;
  final List<Comida> comidas;

  DietaPlan({
    required this.caloriasObjetivo,
    required this.proteinasGramos,
    required this.carbohidratosGramos,
    required this.grasasGramos,
    required this.resumenObjetivo,
    required this.comidas,
  });
}

class Comida {
  final String nombre;
  final String hora;
  final List<String> alimentos;
  final double calorias;

  Comida({
    required this.nombre,
    required this.hora,
    required this.alimentos,
    required this.calorias,
  });
}

class DietaGenerator {
  static DietaPlan generar(InfoDisenoDieta info) {
    double tmb;
    if (info.sexo == 'HOMBRE') {
      tmb = 88.36 + (13.4 * info.peso) + (4.8 * info.altura) - (5.7 * info.edad);
    } else {
      tmb = 447.6 + (9.2 * info.peso) + (3.1 * info.altura) - (4.3 * info.edad);
    }

    double factorActividad;
    switch (info.nivelActividad) {
      case '1-2 días':
        factorActividad = 1.375;
        break;
      case '3-4 días':
        factorActividad = 1.55;
        break;
      case '+4 días':
        factorActividad = 1.725;
        break;
      default:
        factorActividad = 1.375;
    }

    double caloriasMant = tmb * factorActividad;

    double caloriasObjetivo;
    String resumen;
    double pctProteina, pctCarbos, pctGrasa;

    switch (info.objetivo) {
      case 'Bajar peso':
        caloriasObjetivo = caloriasMant - 500;
        resumen = 'Déficit calórico para perder grasa de forma progresiva';
        pctProteina = 0.40;
        pctCarbos = 0.30;
        pctGrasa = 0.30;
        break;
      case 'Subir peso':
        caloriasObjetivo = caloriasMant + 500;
        resumen = 'Superávit calórico para ganar masa muscular';
        pctProteina = 0.30;
        pctCarbos = 0.45;
        pctGrasa = 0.25;
        break;
      case 'Mantener peso':
      default:
        caloriasObjetivo = caloriasMant;
        resumen = 'Mantenimiento del peso corporal actual';
        pctProteina = 0.30;
        pctCarbos = 0.40;
        pctGrasa = 0.30;
        break;
    }

    double proteinasG = (caloriasObjetivo * pctProteina) / 4;
    double carbohidratosG = (caloriasObjetivo * pctCarbos) / 4;
    double grasasG = (caloriasObjetivo * pctGrasa) / 9;

    List<Comida> comidas = generarComidas(info.objetivo, caloriasObjetivo);

    return DietaPlan(
      caloriasObjetivo: caloriasObjetivo,
      proteinasGramos: proteinasG,
      carbohidratosGramos: carbohidratosG,
      grasasGramos: grasasG,
      resumenObjetivo: resumen,
      comidas: comidas,
    );
  }

  static List<Comida> generarComidas(String objetivo, double calTotal) {
    final dist = [0.25, 0.10, 0.30, 0.10, 0.25];

    switch (objetivo) {
      case 'Bajar peso':
        return [
          Comida(nombre: 'Desayuno', hora: '08:00',
            alimentos: ['Tortilla de claras (3 claras)', 'Tostada integral', 'Café sin azúcar'],
            calorias: calTotal * dist[0]),
          Comida(nombre: 'Media Mañana', hora: '11:00',
            alimentos: ['Yogur natural desnatado', 'Puñado de almendras (15g)'],
            calorias: calTotal * dist[1]),
          Comida(nombre: 'Almuerzo', hora: '14:00',
            alimentos: ['Pechuga de pollo a la plancha (150g)', 'Ensalada mixta grande', 'Arroz integral (60g)'],
            calorias: calTotal * dist[2]),
          Comida(nombre: 'Merienda', hora: '17:00',
            alimentos: ['Fruta de temporada', 'Queso fresco bajo en grasa (30g)'],
            calorias: calTotal * dist[3]),
          Comida(nombre: 'Cena', hora: '20:30',
            alimentos: ['Merluza al horno (150g)', 'Verduras salteadas', 'Aceite de oliva (1 cucharada)'],
            calorias: calTotal * dist[4]),
        ];
      case 'Subir peso':
        return [
          Comida(nombre: 'Desayuno', hora: '08:00',
            alimentos: ['Avena con leche entera (80g)', 'Plátano', 'Huevos revueltos (3 huevos)', 'Tostada con mantequilla'],
            calorias: calTotal * dist[0]),
          Comida(nombre: 'Media Mañana', hora: '11:00',
            alimentos: ['Batido de proteínas con plátano', 'Frutos secos (30g)'],
            calorias: calTotal * dist[1]),
          Comida(nombre: 'Almuerzo', hora: '14:00',
            alimentos: ['Ternera a la plancha (200g)', 'Pasta integral (100g)', 'Ensalada con aguacate', 'Pan integral'],
            calorias: calTotal * dist[2]),
          Comida(nombre: 'Merienda', hora: '17:00',
            alimentos: ['Sándwich de pavo y queso', 'Zumo natural'],
            calorias: calTotal * dist[3]),
          Comida(nombre: 'Cena', hora: '20:30',
            alimentos: ['Pollo al horno (180g)', 'Arroz blanco (100g)', 'Verduras al vapor', 'Yogur griego'],
            calorias: calTotal * dist[4]),
        ];
      case 'Mantener peso':
      default:
        return [
          Comida(nombre: 'Desayuno', hora: '08:00',
            alimentos: ['Tostadas integrales con aguacate', 'Huevos cocidos (2)', 'Fruta de temporada'],
            calorias: calTotal * dist[0]),
          Comida(nombre: 'Media Mañana', hora: '11:00',
            alimentos: ['Yogur natural con nueces', 'Manzana'],
            calorias: calTotal * dist[1]),
          Comida(nombre: 'Almuerzo', hora: '14:00',
            alimentos: ['Pollo a la plancha (150g)', 'Arroz integral (80g)', 'Ensalada variada', 'Aceite de oliva'],
            calorias: calTotal * dist[2]),
          Comida(nombre: 'Merienda', hora: '17:00',
            alimentos: ['Queso fresco con membrillo', 'Galletas integrales (2)'],
            calorias: calTotal * dist[3]),
          Comida(nombre: 'Cena', hora: '20:30',
            alimentos: ['Salmón al horno (150g)', 'Patata asada (100g)', 'Brócoli al vapor'],
            calorias: calTotal * dist[4]),
        ];
    }
  }
}
