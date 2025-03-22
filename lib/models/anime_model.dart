class Anime {
  final int id;
  final String title;
  final String? titleEnglish;
  final String? titleJapanese;
  final String? background;
  final String? synopsis;
  final String imageUrl;
  final double score;
  final List<String> genres;
  final String type;
  final String status;
  final String duration;
  final String rating;
  final int episodes;
  final String? airedDate;

  Anime({
    required this.id,
    required this.title,
    this.titleEnglish,
    this.titleJapanese,
    this.background,
    this.synopsis,
    required this.imageUrl,
    required this.score,
    required this.genres,
    required this.type,
    required this.status,
    required this.duration,
    required this.rating,
    required this.episodes,
    this.airedDate,
  });

  // Factory constructor to parse API data
  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      titleEnglish: json['title_english'],
      titleJapanese: json['title_japanese'],
      background: json['background'] ?? 'No background available.',
      synopsis: json['synopsis'] ?? 'No synopsis available.',
      imageUrl: json['images']['jpg']['image_url'] ??
          'https://via.placeholder.com/150',
      score: json['score']?.toDouble() ?? 0.0,
      genres: List<String>.from(
        json['genres'].map((genre) => genre['name'] ?? ''),
      ),
      type: json['type'] ?? 'Unknown',
      status: json['status'] ?? 'Unknown',
      duration: json['duration'] ?? 'Unknown duration',
      rating: json['rating'] ?? 'N/A',
      episodes: json['episodes'] ?? 0,
      airedDate: json['aired']['string'],
    );
  }
}
