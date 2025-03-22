import 'package:flutter/material.dart';
import 'package:watchmecook/models/youtube_model.dart';
import 'package:watchmecook/screens/youtube/youtube_details.dart';
import 'package:watchmecook/services/api.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late Future<List<Video>> _videoList;

  @override
  void initState() {
    super.initState();
    _videoList = ApiService.fetchPlaylistVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Video>>(
        future: _videoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No videos found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final video = snapshot.data![index];
              return _buildVideoCard(video);
            },
          );
        },
      ),
    );
  }

  /// 📹 Build a Custom Video Card
  Widget _buildVideoCard(Video video) {
    return GestureDetector(
      onTap: () {
        print("Navigating to video with ID: ${video.id}");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VideoDetailScreen(videoId: video.id, channelId: video.channelId),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🎥 Thumbnail with Rounded Corners
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                video.thumbnailUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 📝 Video Title
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  /// 📚 Video Description
                  Text(
                    video.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  /// ⏰ Published Date & Channel Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Published: ${_formatPublishedDate(video.publishedAt)}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        "By: ${video.channelTitle}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📅 Format Published Date
  String _formatPublishedDate(String publishedAt) {
    DateTime dateTime = DateTime.parse(publishedAt);
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }
}
