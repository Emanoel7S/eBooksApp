class Book {
  final int id;
  final String? title;
  final String? author;
  final String? coverUrl;
  final String? downloadUrl;
  String? imagePath;
  String? bookPath;
  bool isFavorite;
  bool downloadInProgress;

  Book({
    required this.id,
    this.title,
    this.author,
    this.coverUrl,
    this.downloadUrl,
    this.imagePath,
    this.bookPath,
    this.isFavorite = false,
    this.downloadInProgress = false,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'] as String?,
      author: json['author'] as String?,
      coverUrl: json['cover_url'] as String?,
      downloadUrl: json['download_url'] as String?,
      imagePath: json['image_path'] as String?,
      bookPath: json['book_path'] as String?,
      isFavorite: false,
      downloadInProgress: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'cover_url': coverUrl,
      'download_url': downloadUrl,
      'image_path': imagePath,
      'book_path': bookPath,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }
}
