import 'package:ebooks_app/services/database_services.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<Book> _booksFavorite = [];
  bool _isLoading = false;
  bool _onlyFavorite = false;

  List<Book> get books => _onlyFavorite?_booksFavorite:_books;
  bool get isLoading => _isLoading;
  // Chama a funcao de buscar os livros, e faz controle do estado de books e isLoading
  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();

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
    book.isFavorite = !book.isFavorite;
    DatabaseHelper.updateFavoriteStatus(book);
    notifyListeners();
  }
  // Filtra os favoritos
  void onlyFavorite () {
    _onlyFavorite= true;
    List<Book> booksFav = [];
    for( var book in _books){
      if(book.isFavorite){
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

}
