import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
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
    book.isFavorite = !book.isFavorite;
    notifyListeners();
  }
}
