import 'package:ebooks_app/models/book.dart';
import 'package:ebooks_app/widgets/book_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import '../providers/book_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Book>> futureBooks;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){

      Provider.of<BookProvider>(context, listen: false).fetchBooks();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eBooks'),
        centerTitle: true,
      ),
      body: _bodyPage(),
    );
  }

  Widget _bodyPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child:  TextButton(onPressed: (){
                    Provider.of<BookProvider>(context, listen: false).noOnlyFavorite();

                  }, child: const Text(
                    'Livros',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),)
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child:  TextButton(
                    onPressed: (){
                      Provider.of<BookProvider>(context, listen: false).onlyFavorite();

                    }
                    , child: const Text('Favoritos', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: Consumer<BookProvider>(
              builder: (context, bookProvider, child) {
                if (bookProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (bookProvider.books.isEmpty) {
                  return Center(child: Text('Nenhum livro encontrado.'));
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: bookProvider.books.length,
                  itemBuilder: (context, index) {
                    final book = bookProvider.books[index];
                    return GestureDetector(
                        onTap: () async {

                          await bookProvider.downloadBook(book);

                          if(context.mounted && book.bookPath!=null){

                              openBook(context, book);

                          }
                        },

                      child: BookWidget(
                        book: book,
                        onFavoriteToggle: () {
                          Provider.of<BookProvider>(context, listen: false)
                              .toggleFavorite(book);
                        },

                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void openBook(BuildContext context, Book book) {
      VocsyEpub.setConfig(
        themeColor: Theme.of(context).primaryColor,
        identifier: "androidBook",
        scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
        allowSharing: true,
        enableTts: true,
        nightMode: true,
      );

      VocsyEpub.locatorStream.listen((locator) {
        print('LOCATOR: $locator');
        VocsyEpub.closeReader();

      });

      VocsyEpub.open(
        book.bookPath!,
      );


  }
  // void openBook(BuildContext context, Book book) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => BookReaderScreen(book: book),
  //     ),
  //   );
  // }

}
