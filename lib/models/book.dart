class Book {
  final int id;
  String? title;
  String? author;
  String? coverUrl;
  String? imagePath;
  String? downloadUrl;
  bool isFavorite;

  Book({
    required this.id,
    this.title,
    this.author,
    this.coverUrl,
    this.imagePath,
    this.downloadUrl,
    this.isFavorite = false,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'] as String?,
      author: json['author'] as String?,
      coverUrl: json['cover_url'] as String?,
      imagePath: json['image_path'] as String?,
      downloadUrl: json['download_url'] as String?,
      isFavorite: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'cover_url': coverUrl,
      'image_path': imagePath,
      'download_url': downloadUrl,
      'is_favorite': isFavorite,

    };
  }
}
