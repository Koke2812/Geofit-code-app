import 'package:geofit/database/database_geo.dart';
import 'package:geofit/models/historial.dart';

class HistorialDAO {
  final dbProvider = DatabaseGeo.instance;

  Future<int> insertHistorial(Historial historial) async {
    final db = await dbProvider.database;
    return await db.insert('Historial', historial.toMap());
  }

  Future<List<Historial>> getHistorialByUsuarioId(int idUsuario) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Historial',
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
      orderBy: 'fecha DESC',
    );
    return maps.map((map) => Historial.fromMap(map)).toList();
  }

  Future<List<Historial>> getHistorialByUsuarioNombre(String nombre) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> usuarios = await db.query(
      'Usuario',
      where: 'usuario = ?',
      whereArgs: [nombre],
    );
    if (usuarios.isEmpty) return [];
    final int idUsuario = usuarios.first['id'];
    return await getHistorialByUsuarioId(idUsuario);
  }

  Future<int> deleteHistorial(int id) async {
    final db = await dbProvider.database;
    return await db.delete('Historial', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllHistorialByUsuario(int idUsuario) async {
    final db = await dbProvider.database;
    return await db.delete('Historial', where: 'id_usuario = ?', whereArgs: [idUsuario]);
  }
}
