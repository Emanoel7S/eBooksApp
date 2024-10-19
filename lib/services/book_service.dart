import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ebooks_app/services/database_services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';

class BookService {
  final String apiUrl = 'https://escribo.com/books.json';
  // Faz o download da imagem e salva no diretorio da aplciacao
  Future<String> saveImage(String imageUrl, String fileName) async {
    String imagePath = join((await getApplicationDocumentsDirectory()).path, fileName);

    try{
      await Dio().download(imageUrl, imagePath);

      return imagePath;
    }catch(e){
      return 'fail';
    }

  }

  // Busca  pelos livros na api para garantir que sempre estejam sincronizados caso
  // tenha novos livros fazendo verificacoes a fim de melhorar o desempenho
  Future<List<Book>> fetchBooks() async {
    List<Book> bdBooks = await DatabaseHelper.getBooks();
    try {

      final response = await  Dio().get(apiUrl);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data; // Com o Dio, você pode acessar diretamente `response.data`
        List<Book> books = jsonData.map((json) => Book.fromJson(json)).toList();

        // Verificar se a imagem já foi baixada
        await imageExistsLocally(books);

        await DatabaseHelper.insertBooks(books, bdBooks);
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
      throw Exception('Erro: $e');
    }
  }

  // Verifica se a imagem ja existe local e chama funcao de download se necessario.
  Future<void> imageExistsLocally(List<Book> books) async {
    for (var book in books) {
      if (book.coverUrl != null) {
        String fileName = 'book_${book.id}.png';
        String imagePath = join((await getApplicationDocumentsDirectory()).path, fileName);


        final file = File(imagePath);
        if (await file.exists()) {
          book.imagePath = imagePath;
        } else {
          imagePath = await saveImage(book.coverUrl!, fileName);
          book.imagePath = imagePath;
        }
      }
    }
  }
  //Faz download do livro
  Future<bool>bookDownload(Book book) async {

    if(book.bookPath!=null) {
      return true;
    }
    try{
      print('inicio download');
      Directory? appDocDir = await getExternalStorageDirectory();

      String path = '${appDocDir!.path}/book_${book.id}.epub';
      print('path final$path');
      File file = File(path);
      print(file);
      if (!File(path).existsSync()) {
        print('entrou aqui');
        await file.create();
        try{
          await Dio().download(
            book.downloadUrl!,
            path,
            deleteOnError: true,
            onReceiveProgress: (receivedBytes, totalBytes) {
              print('Download --- ${(receivedBytes / totalBytes) * 100}');
              print('path --- $path');

            },
          );
          book.bookPath = path;
          print('bookpath try${book.bookPath}');
          await DatabaseHelper.insertBook(book);
        }catch(e){
          File file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
          ///mostra snack de falha
          book.bookPath=null;
        }

      }else{
        book.bookPath = path;
        await DatabaseHelper.insertBook(book);

      }
      print('atualizando path');

      return true;
    }catch(e){
      book.bookPath = null;
      return false;
    }

  }
}
