import 'dart:convert';
import 'dart:io';
import 'package:ebooks_app/services/database_services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';

class BookService {
  final String apiUrl = 'https://escribo.com/books.json';

  Future<String> saveImage(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {

      final directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, fileName);
      final file = File(path);


      await file.writeAsBytes(response.bodyBytes);
      return path;
    } else {
      throw Exception('Falha ao baixar a imagem: ${response.statusCode}');
    }
  }
  // Busca  pelos livros na api para garantir que sempre estejam sincronizados caso
  // tenha novos livros fazendo verificacoes a fim de melhorar o desempenho

  Future<List<Book>> fetchBooks() async {
    List<Book> bdBooks = await DatabaseHelper.getBooks();
    try {

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Book> books = jsonData.map((json) => Book.fromJson(json)).toList();
        // Verificar se a imagem ja foi baixada
        await imageExistsLocally(books);


        await DatabaseHelper.insertBooks(books,bdBooks);
        List<Book> updatedBooks = await DatabaseHelper.getBooks();

        return updatedBooks;
      } else {
        if (bdBooks.isNotEmpty) {
          return bdBooks;
        }
        throw Exception('Falha ao carregar livros: ${response.statusCode}');
      }
    } catch (e) {
      if (bdBooks.isNotEmpty) {
        return bdBooks;
      }
      // print('Erro: $e');
      throw Exception('Erro: $e');
    }
  }

  Future<void> imageExistsLocally(List<Book> books) async {
    for (var book in books) {
      if (book.coverUrl != null) {
        String fileName = 'book_${book.id}.png';
        String imagePath = join((await getApplicationDocumentsDirectory()).path, fileName);


        final file = File(imagePath);
        if (await file.exists()) {
          print('Imagem já existe: $imagePath');
          book.imagePath = imagePath;
        } else {

          imagePath = await saveImage(book.coverUrl!, fileName);
          print('Imagem baixada: $imagePath');
          book.imagePath = imagePath;
        }
      }
    }
  }
}
