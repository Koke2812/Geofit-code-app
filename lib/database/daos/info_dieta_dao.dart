import 'package:geofit/database/database_geo.dart';
import 'package:geofit/models/info_dieta.dart';
import 'package:sqflite/sqflite.dart';

class InfoDisenoDietaDAO {
  final dbProvider = DatabaseGeo.instance;

  Future<int> insertOrUpdate(InfoDisenoDieta info) async {
    final db = await dbProvider.database;
    return await db.insert(
      'InfoDisenoDieta',
      info.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<InfoDisenoDieta?> getByUsuarioId(int idUsuario) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'InfoDisenoDieta',
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );

    if (maps.isNotEmpty) {
      return InfoDisenoDieta.fromMap(maps.first);
    }
    return null;
  }
}
