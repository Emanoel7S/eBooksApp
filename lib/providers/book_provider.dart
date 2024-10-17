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

  void toggleFavorite(Book book) {
    book.isFavorite = !book.isFavorite; // Alterna o estado do favorito
    DatabaseHelper.updateFavoriteStatus(book); // Atualiza o banco de dados
    notifyListeners(); // Notifica os ouvintes para atualizar a interface
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
  // retira o filtro
  void noOnlyFavorite(){
    _onlyFavorite = false;
      notifyListeners();
  }

}
