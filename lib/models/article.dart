class Article {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String author;
  final DateTime publishDate;
  final String category;
  final List<String> tags;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.author,
    required this.publishDate,
    required this.category,
    required this.tags,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      author: json['author'],
      publishDate: DateTime.parse(json['publishDate']),
      category: json['category'],
      tags: List<String>.from(json['tags']),
    );
  }
}
