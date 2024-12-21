import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Joke {
  int id;
  String type;
  String setup;
  String punchline;
  bool isFavorite;

  Joke({
    required this.id,
    required this.type,
    required this.setup,
    required this.punchline,
    this.isFavorite = false,
  });

  Joke.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        type = data['type'],
        setup = data['setup'],
        punchline = data['punchline'],
        isFavorite = data['isFavorite'] == 1;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'setup': setup,
      'punchline': punchline,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }
}

class JokeDatabase {
  static final JokeDatabase instance = JokeDatabase._init();
  static Database? _database;

  JokeDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('jokes.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE jokes (
        id INTEGER PRIMARY KEY,
        type TEXT NOT NULL,
        setup TEXT NOT NULL,
        punchline TEXT NOT NULL,
        isFavorite INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertJoke(Joke joke) async {
    final db = await instance.database;
    await db.insert(
      'jokes',
      joke.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Joke>> getAllJokes() async {
    final db = await instance.database;
    final result = await db.query('jokes');

    return result.map((json) => Joke.fromJson(json)).toList();
  }

  Future<List<Joke>> getFavoriteJokes() async {
    final db = await instance.database;
    final result = await db.query(
      'jokes',
      where: 'isFavorite = 1'
    );

    return result.map((json) => Joke.fromJson(json)).toList();
  }

  Future<Joke?> getJokeById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'jokes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Joke.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<void> updateJoke(Joke joke) async {
    final db = await instance.database;
    await db.update(
      'jokes',
      joke.toJson(),
      where: 'id = ?',
      whereArgs: [joke.id],
    );
  }

  Future<void> deleteJoke(int id) async {
    final db = await instance.database;
    await db.delete(
      'jokes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close database
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}