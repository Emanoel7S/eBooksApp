class Book {
  final int id;
  final String? title;
  final String? author;
  final String? coverUrl;
  final String? downloadUrl;
  String? imagePath;
  bool isFavorite;

  Book({
    required this.id,
    this.title,
    this.author,
    this.coverUrl,
    this.downloadUrl,
    this.imagePath,
    this.isFavorite = false,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'] as String?,
      author: json['author'] as String?,
      coverUrl: json['cover_url'] as String?,
      downloadUrl: json['download_url'] as String?,
      imagePath: json['image_path'] as String?,
      isFavorite: false,
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
      'is_favorite': isFavorite ? 1 : 0,
    };
  }
}
