import 'package:geofit/database/database_geo.dart';
import 'package:geofit/models/usuario.dart';

class UsuarioDAO {
  final dbProvider = DatabaseGeo.instance;

  Future<int> insertUsuario(Usuario usuario) async {
    final db = await dbProvider.database;
    return await db.insert('Usuario', usuario.toMap());
  }

  Future<Usuario?> getUsuario(String nombre, String contrasena) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Usuario',
      where: 'usuario = ? AND contrasena = ?',
      whereArgs: [nombre, contrasena],
    );
    if (maps.isNotEmpty) return Usuario.fromMap(maps.first);
    return null;
  }

  Future<Usuario?> getUsuarioByName(String nombre) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Usuario',
      where: 'usuario = ?',
      whereArgs: [nombre],
    );
    if (maps.isNotEmpty) return Usuario.fromMap(maps.first);
    return null;
  }

  Future<int> updateUsuario(Usuario usuario) async {
    final db = await dbProvider.database;
    return await db.update(
      'Usuario', usuario.toMap(),
      where: 'id = ?', whereArgs: [usuario.id],
    );
  }

  Future<int> updateSaldo(int userId, double nuevoSaldo) async {
    final db = await dbProvider.database;
    return await db.update(
      'Usuario', {'saldo': nuevoSaldo},
      where: 'id = ?', whereArgs: [userId],
    );
  }

  Future<double> getSaldoByUserId(int userId) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Usuario', columns: ['saldo'],
      where: 'id = ?', whereArgs: [userId],
    );
    if (maps.isNotEmpty) return (maps.first['saldo'] as num?)?.toDouble() ?? 15.50;
    return 15.50;
  }

  Future<int> updateDietaPagada(int userId, bool pagada) async {
    final db = await dbProvider.database;
    return await db.update(
      'Usuario', {'dieta_pagada': pagada ? 1 : 0},
      where: 'id = ?', whereArgs: [userId],
    );
  }

  Future<int> updateFotoPath(int userId, String path) async {
    final db = await dbProvider.database;
    return await db.update(
      'Usuario', {'foto_path': path},
      where: 'id = ?', whereArgs: [userId],
    );
  }

  Future<Usuario?> getUsuarioById(int userId) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Usuario',
      where: 'id = ?', whereArgs: [userId],
    );
    if (maps.isNotEmpty) return Usuario.fromMap(maps.first);
    return null;
  }
}
