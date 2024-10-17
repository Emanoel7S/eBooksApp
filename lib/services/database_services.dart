import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/book.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'books.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute(''' 
          CREATE TABLE books (
            id INTEGER PRIMARY KEY,
            title TEXT,
            author TEXT,
            cover_url TEXT,
            download_url TEXT,
            image_path TEXT,
            is_favorite INTEGER DEFAULT 0  -- Adicionado campo para favoritos
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          print('add coluna');
          await db.execute(''' 
            ALTER TABLE books ADD COLUMN is_favorite INTEGER DEFAULT 0
          ''');
        }
      },
    );
  }

  static Future<void> insertBook(Book book) async {
    final db = await getDatabase();
    await db.insert(
      'books',
      book.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertBooks(List<Book> books) async {
    final db = await getDatabase();

    for (var book in books) {
      await db.insert(
        'books',
        book.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<Book>> getBooks() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('books');

    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        title: maps[i]['title'],
        author: maps[i]['author'],
        coverUrl: maps[i]['cover_url'],
        imagePath: maps[i]['image_path'],
        downloadUrl: maps[i]['download_url'],
        isFavorite: maps[i]['is_favorite'] == 1,
      );
    });
  }


  static Future<void> updateFavoriteStatus(Book book) async {
    final db = await getDatabase();
    await db.update(
      'books',
      {'is_favorite': book.isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }
}
