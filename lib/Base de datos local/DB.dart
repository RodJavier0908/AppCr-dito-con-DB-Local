import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _iniDatabase();
    return _database!;
  }

  Future<Database> _iniDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database1.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE dinero (
      id INTEGER PRIMARY KEY,
      total REAL,
      cantidad REAL
    )
  ''');
    await db.insert('dinero', {'total': 0});
  }

  Future<double> obtenerdinerototal() async {
    final db = await database;
    final result = await db.query('dinero');


    if (result.isNotEmpty) {
      return result.first['total'] as double;
    } else {
      return 0;
    }
  }

  Future<double> obtenertrancciones() async {
    final db = await database;
    final result = await db.query('dinero');

    if (result.isNotEmpty) {
      return result.first['cantidad'] as double;
    } else {
      return 0;
    }
  }

  Future<void> actualizamontototal(double Total) async {
    final db = await database;
    await db.update('dinero', {'total': Total});
  }

  Future<void> aztualizarmovimiento(double Totall) async {
    final db = await database;
    await db.update('dinero', {'cantidad': Totall});
  }
}

class basededatos2 {
  static Database? _database;
  final String registro = 'myregistro';

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await iniciarbasededatos();
    return _database;
  }

  Future<Database> iniciarbasededatos() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_databasee2.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
              CREATE TABLE $registro(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
    NombreT TEXT,
    Descripcion TEXT,
    Montom REAL,
    TotalP REAL,
    InteresP REAL,
    InteresPpor TEXT,        
    CuotasP TEXT,
    Tiempo TEXT,
    NumCuentaT TEXT,
    NumCiT TEXT
            )
            ''',
        );
      },
    );
  }

  Future<void> insertardatos(Map<String, dynamic> item) async {
    final db = await database;

    final now = DateTime.now();
    final formatearDatos =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    item['Tiempo'] = formatearDatos;
    await db!.insert(registro, item);
  }

  Future<List<Map<String, dynamic>>> traerdatos() async {
    final db = await database;
    return await db!.query(registro);
  }

  Future<void> Actualizardatos(int id, Map<String, dynamic> item) async {
    final db = await database;
    await db!.update(
      registro,
      item,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> borrardatos(int id) async {
    final db = await database;
    await db!.delete(registro, where: 'id = ?', whereArgs: [id]);
  }

}

class Basededatoslogin{

  static Database? _database;
  static const String dbNombre = 'my_database3.db';
  static const String UsuarioTabla = 'usuario';

  Basededatoslogin._();

  static final Basededatoslogin instance = Basededatoslogin._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), dbNombre);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $UsuarioTabla (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario TEXT NOT NULL,
        codigo TEXT NOT NULL
      )
    ''');
  }

  Future<int> crearUserio(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(UsuarioTabla, user);
  }

  Future<Map<String, dynamic>?> traerusuario(String u) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      UsuarioTabla,
      where: 'usuario = ?',
      whereArgs: [u],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }
  Future<List<Map<String, dynamic>>> traerTodosLosUsuarios() async {
    final db = await database;
    return await db.query(UsuarioTabla);
  }
  Future<void> borrardatos(int id) async {
    final db = await database;
    await db!.delete(UsuarioTabla, where: 'usuario = ?', whereArgs: [id]);
  }
}