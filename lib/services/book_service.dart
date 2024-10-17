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
    print('download da imagem');
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

  Future<List<Book>> fetchBooks() async {
    try {
      // List<Book> bdBooks = await DatabaseHelper.getBooks();
      // if (bdBooks.isNotEmpty) {
      //   return bdBooks;
      // }

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Book> books = jsonData.map((json) => Book.fromJson(json)).toList();


        for (var book in books) {
          if (book.coverUrl != null) {
            String fileName = 'book_${book.id}.png';
            String imagePath = await saveImage(book.coverUrl!, fileName);
            print(imagePath);
            book.imagePath = imagePath;
          }
        }

        await DatabaseHelper.insertBooks(books);

        return books;
      } else {
        throw Exception('Falha ao carregar livros: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
      throw Exception('Erro: $e');
    }
  }
}
