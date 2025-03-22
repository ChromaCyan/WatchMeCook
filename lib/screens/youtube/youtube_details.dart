import 'package:flutter/material.dart';
import 'package:watchmecook/models/youtube_channel.dart';
import 'package:watchmecook/models/youtube_model.dart';
import 'package:watchmecook/screens/youtube/channel_details.dart';
import 'package:watchmecook/services/api.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetailScreen extends StatefulWidget {
  final String videoId;
  final String channelId;

  const VideoDetailScreen({
    Key? key,
    required this.videoId,
    required this.channelId,
  }) : super(key: key);

  @override
  _VideoDetailScreenState createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  late Future<Video> _videoFuture;
  late Future<Channel> _channelFuture;

  @override
  void initState() {
    super.initState();
    _videoFuture = ApiService.fetchVideoDetails(widget.videoId);
    _channelFuture = ApiService.fetchChannelDetails(widget.channelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<Video>(
        future: _videoFuture,
        builder: (context, videoSnapshot) {
          if (videoSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (videoSnapshot.hasError || !videoSnapshot.hasData) {
            return const Center(
              child: Text(
                'Failed to load video details',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }

          final video = videoSnapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 📹 Embedded YouTube Video
                SizedBox(
                  height: 250,
                  child: _buildYouTubePlayer(video.id), // ✅ New YouTube Player
                ),

                /// 📝 Video Info Section
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 📝 Video Title
                      Text(
                        video.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      /// 📚 Video Description
                      Text(
                        video.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// 🔗 View Channel Button & Channel Details
                      _buildChannelSection(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🎥 Build YouTube Player Widget
  Widget _buildYouTubePlayer(String videoId) {
  return YoutubePlayerBuilder(
    player: YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: videoId.toString(), // ✅ Direct use
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          isLive: false,
        ),
      ),
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.red,
    ),
    builder: (context, player) {
      return Column(
        children: [
          SizedBox(height: 250, child: player),
        ],
      );
    },
  );
}


  /// 📡 Fetch Channel Details
  Widget _buildChannelSection() {
    return FutureBuilder<Channel>(
      future: _channelFuture,
      builder: (context, channelSnapshot) {
        if (channelSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (channelSnapshot.hasError || !channelSnapshot.hasData) {
          return const Text(
            'Failed to load channel details',
            style: TextStyle(fontSize: 16, color: Colors.red),
          );
        }

        final channel = channelSnapshot.data!;
        return _buildChannelCard(channel);
      },
    );
  }

    /// 🎥 Build Channel Card with Thumbnail & Button
  Widget _buildChannelCard(Channel channel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChannelDetailScreen(channelId: widget.channelId),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 📸 Channel Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  channel.thumbnailUrl,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              /// 📡 Channel Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🎵 Channel Title
                    Text(
                      channel.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    /// 📝 Full Channel Description (Fixed)
                    Text(
                      channel.description.isNotEmpty
                          ? channel.description
                          : 'No description available',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              /// ➡️ Navigation Icon
              Icon(Icons.chevron_right, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}
