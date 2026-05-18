import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseGeo {
  static final DatabaseGeo instance = DatabaseGeo.init();
  static Database? db;

  DatabaseGeo.init();

  Future<Database> get database async {
    if (db != null) return db!;
    db = await initDB('geofit.db');
    return db!;
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5,
      onCreate: createDB,
      onUpgrade: onUpgrade,
    );
  }

  Future onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      try {
        await db.execute('ALTER TABLE Usuario ADD COLUMN foto_path TEXT');
      } catch (e) {
      }
    }
  }

  Future createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario TEXT NOT NULL,
        contrasena TEXT NOT NULL,
        saldo REAL NOT NULL DEFAULT 0,
        dieta_pagada INTEGER NOT NULL DEFAULT 0,
        foto_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Alimento (
        nombre TEXT PRIMARY KEY,
        calorias REAL,
        proteina REAL,
        carbohidratos REAL,
        grasas REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE Historial (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER,
        calorias_totales REAL,
        proteinas_totales REAL,
        carbohidratos_totales REAL,
        grasas_totales REAL,
        detalle TEXT,
        fecha TEXT,
        FOREIGN KEY (id_usuario) REFERENCES Usuario (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE InfoDisenoDieta (
        id_usuario INTEGER PRIMARY KEY,
        edad INTEGER,
        altura REAL,
        peso REAL,
        sexo TEXT,
        objetivo TEXT,
        nivel_actividad TEXT,
        FOREIGN KEY (id_usuario) REFERENCES Usuario (id)
      )
    ''');

    await db.insert('Alimento', {
      'nombre': 'Huevos', 'calorias': 155.0, 'proteina': 13.0,
      'carbohidratos': 1.1, 'grasas': 11.0,
    });
    await db.insert('Alimento', {
      'nombre': 'Pollo', 'calorias': 239.0, 'proteina': 27.0,
      'carbohidratos': 0.0, 'grasas': 14.0,
    });
    await db.insert('Alimento', {
      'nombre': 'Arroz', 'calorias': 130.0, 'proteina': 2.7,
      'carbohidratos': 28.0, 'grasas': 0.3,
    });
    await db.insert('Alimento', {
      'nombre': 'Ternera', 'calorias': 250.0, 'proteina': 26.0,
      'carbohidratos': 0.0, 'grasas': 15.0,
    });
    await db.insert('Alimento', {
      'nombre': 'Pasta', 'calorias': 131.0, 'proteina': 5.0,
      'carbohidratos': 25.0, 'grasas': 1.1,
    });
  }
}
