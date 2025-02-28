class Anime {
  final String title;
  final String? titleEnglish;
  final String? titleJapanese;
  final String? background;
  final String? synopsis;
  final String? imageUrl;
  final double score;
  final List<String> genres;

  Anime({
    required this.title,
    this.titleEnglish,
    this.titleJapanese,
    this.background,
    this.synopsis,
    required this.imageUrl,
    required this.score,
    required this.genres,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      title: json['title'] ?? '',
      titleEnglish: json['title_english'],
      titleJapanese: json['title_japanese'],
      background: json['background'],
      synopsis: json['synopsis'],
      imageUrl: json['images']['jpg']['image_url'],
      score: json['score']?.toDouble() ?? 0.0,
      genres: List<String>.from(json['genres'].map((genre) => genre['name'] ?? '')),
    );
  }
}
