import 'package:ebooks_app/services/database_services.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import '../services/snackbar_service.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<Book> _booksFavorite = [];
  bool _isLoading = false;
  bool _onlyFavorite = false;

  List<Book> get books => _onlyFavorite?_booksFavorite:_books;
  bool get isLoading => _isLoading;
  // Chama a funcao de buscar os livros, e faz controle do estado de books e isLoading
  Future<void> fetchBooks() async {
    _isLoading = true;notifyListeners();

    try {
      List<Book> fetchedBooks = await BookService().fetchBooks();
      _books = fetchedBooks;
    } catch (error) {
      print('Erro ao buscar livros: $error');

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Altera o estado, e salva no banco
  void toggleFavorite(Book book) {
    bool newFavorite = !book.isFavorite;
    book.isFavorite = newFavorite;
    //  Se _onlyFavorite estiver ativo e e um livro favorito for desfavoritado atualzia a lista de favoritos
    if(_onlyFavorite&&!newFavorite){
      print('novo favorito para $newFavorite');
      onlyFavorite();
    }
    DatabaseHelper.updateFavoriteStatus(book);
    notifyListeners();
  }
  // Filtra os favoritos
  void onlyFavorite () {
    _onlyFavorite= true;
    List<Book> booksFav = [];
    for( var book in _books){if(book.isFavorite){
      booksFav.add(book);
     }
    }
    _booksFavorite = booksFav;
    print(_booksFavorite);
    notifyListeners();
  }
  // Retira o filtro
  void noOnlyFavorite(){
    _onlyFavorite = false;
      notifyListeners();
  }
// funcao de download do livro e atualizacao do estado do progresso
  Future<void> downloadBook(Book book) async {
      if (book.downloadInProgress) return;

      book.downloadInProgress = true;
      notifyListeners();

      try {
        bool success = await BookService().bookDownload(book);

        if (!success) {
          book.bookPath = null;
          book.downloadInProgress = false;
        }
      } catch (e) {

        SnackBarHelper.showSnackBar('Falha no Download',Colors.red);
        book.downloadInProgress = false;
      } finally {

        book.downloadInProgress = false;
        notifyListeners();
      }
    }



  }
