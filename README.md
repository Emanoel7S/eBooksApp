# E-books App

Um aplicativo Flutter para visualizar e gerenciar e-books, construído seguindo princípios de programação SOLID.

## Requisitos Técnicos

- Flutter versão 3.24.3 / Dart 3.5.3
- Dependências: `Dio`, `Provider`, `sqflite`, `path`, `path_provider`, `vocsy_epub_viewer`.

## Funcionalidades

- Exibição de uma lista de livros com detalhes como título, autor e capa.
- Funcionalidade de marcar livros como favoritos.
- Download de livros para leitura offline.
- Filtro para visualizar apenas os livros favoritos.

## Estrutura do Projeto

- **models/book.dart**: Modelo de dados para livros.
- **services/book_service.dart**: Gerencia requisições HTTP e manipulação de arquivos.
- **services/database_services.dart**: Operações de banco de dados usando SQLite.
- **providers/book_provider.dart**: Gerencia o estado da aplicação e fornece a lista de livros.
- **views/home_page.dart**: Interface principal do aplicativo.
- **widgets/book_widget.dart**: Exibe os detalhes de cada livro.

## Execução

Para instalar e executar este aplicativo, siga os passos abaixo:

1. **Clone o repositório**:
   git clone https://github.com/Emanoel7S/eBooksApp
2. **Instale as dependências**:
   flutter pub get
3. **Execute o aplicativo**:
   flutter run



