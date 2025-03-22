import 'package:flutter/material.dart';
import 'package:watchmecook/models/youtube_channel.dart';
import 'package:watchmecook/services/api.dart';
import 'package:intl/intl.dart';

class ChannelDetailScreen extends StatelessWidget {
  final String channelId;

  const ChannelDetailScreen({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Channel Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Channel>(
        future: ApiService.fetchChannelDetails(channelId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text(
                'Failed to load channel details',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }

          final channel = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 📸 Channel Banner
                _buildBanner(channel.thumbnailUrl),

                /// 📝 Channel Info Section
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 📚 Channel Title
                      Text(
                        channel.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      /// 📝 Channel Description
                      Text(
                        channel.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// 🕒 About Channel Section
                      _buildAboutChannelCard(channel),
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

  /// 📸 Channel Banner Section
  Widget _buildBanner(String thumbnailUrl) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(thumbnailUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// 🕒 About Channel Section
  Widget _buildAboutChannelCard(Channel channel) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 Section Title
            const Text(
              'About Channel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            /// 📆 Channel Created Date
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Created: ${_formatDate(channel.publishedAt)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// 🌍 Country Info
            Row(
              children: [
                const Icon(Icons.flag, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Country: ${channel.country.isNotEmpty ? channel.country : "N/A"}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 📅 Format Published Date
  String _formatDate(String publishedAt) {
    try {
      final dateTime = DateTime.parse(publishedAt);
      return DateFormat.yMMMd().format(dateTime);
    } catch (e) {
      return 'Unknown';
    }
  }
}
