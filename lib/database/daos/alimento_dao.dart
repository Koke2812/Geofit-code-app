import 'package:geofit/database/database_geo.dart';
import 'package:geofit/models/alimento.dart';

class AlimentoDAO {
  final dbProvider = DatabaseGeo.instance;

  Future<List<Alimento>> getAllAlimentos() async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query('Alimento');

    return maps.map((map) => Alimento.fromMap(map)).toList();
  }

  Future<Alimento?> getAlimentoByNombre(String nombre) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Alimento',
      where: 'nombre = ?',
      whereArgs: [nombre],
    );

    if (maps.isNotEmpty) {
      return Alimento.fromMap(maps.first);
    }
    return null;
  }
}
