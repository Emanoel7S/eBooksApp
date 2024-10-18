import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/book.dart';

class DatabaseHelper {
  static Database? _database;
  // Retorna a instância do banco de dados
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }
  // Inicializa o banco e cria a tabela books
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
            is_favorite INTEGER DEFAULT 0  
          )
        ''');
      },
      // Atualiza o banco para a nova versao adicionando a tabela is_favorite
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

  // Insere novos livros
  static Future<void> insertBooks(List<Book> newBooks, List<Book> oldBooks) async {
    final db = await getDatabase();
      final Set<int> oldBookIds = oldBooks.map((book) => book.id).toSet();
    // Verifica se o id do livro ja está nos livros antigos
    for (var book in newBooks) {
        if (oldBookIds.contains(book.id)) {
          continue;
        }

      await db.insert(
        'books',
        book.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Consultar e retorna uma lista de Book do banco
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

 // Atualiza campos is_favorite no banco
  static Future<void> updateFavoriteStatus(Book book) async {
    print('update para ${book.isFavorite}');
    final db = await getDatabase();
    await db.update(
      'books',
      {'is_favorite': book.isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }
}
