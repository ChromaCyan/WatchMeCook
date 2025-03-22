class Video {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelId;
  final String channelTitle;
  final String publishedAt;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.channelId,
    required this.channelTitle,
    required this.publishedAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
  final snippet = json['snippet'] ?? {};
  final thumbnails = snippet['thumbnails'] ?? {};
  final resourceId = snippet['resourceId'] ?? {}; // ✅ Correctly fetching resourceId

  return Video(
    id: resourceId['videoId'] ?? '', // ✅ Correct videoId path
    title: snippet['title'] ?? 'No Title',
    description: snippet['description'] ?? 'No Description',
    thumbnailUrl: thumbnails['high']?['url'] ?? '', // ✅ Safer path for high-quality thumbnail
    channelId: snippet['channelId'] ?? '',
    channelTitle: snippet['channelTitle'] ?? 'Unknown Channel',
    publishedAt: snippet['publishedAt'] ?? '',
  );
}

}
