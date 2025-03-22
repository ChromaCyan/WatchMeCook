class Channel {
  final String id;
  final String title;
  final String description;
  final String customUrl;
  final String thumbnailUrl;
  final String country;
  final String publishedAt;

  Channel({
    required this.id,
    required this.title,
    required this.description,
    required this.customUrl,
    required this.thumbnailUrl,
    required this.country,
    required this.publishedAt,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final thumbnails = snippet['thumbnails'];
    
    return Channel(
      id: json['id'] ?? '',
      title: snippet['title'] ?? 'No Title',
      description: snippet['description'] ?? 'No Description',
      customUrl: snippet['customUrl'] ?? '',
      thumbnailUrl: thumbnails['high']['url'] ?? '', // Using high-quality thumbnail
      country: snippet['country'] ?? 'N/A',
      publishedAt: snippet['publishedAt'] ?? '',
    );
  }
}
