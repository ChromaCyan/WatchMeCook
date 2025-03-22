import 'package:flutter/material.dart';
import 'package:watchmecook/models/youtube_channel.dart';
import 'package:watchmecook/services/api.dart';
import 'package:intl/intl.dart';

class ChannelDetailScreen extends StatelessWidget {
  final String channelId;

  const ChannelDetailScreen({Key? key, required this.channelId})
      : super(key: key);

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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🎵 Channel Title
                      Text(
                        channel.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      /// 📝 Channel Description
                      Text(
                        channel.description.isNotEmpty
                            ? channel.description
                            : 'No description available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// 📡 About Channel Section
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
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        image: DecorationImage(
          image: NetworkImage(thumbnailUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ),
    );
  }

  /// 🕒 About Channel Section
  Widget _buildAboutChannelCard(Channel channel) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 Section Title
            const Text(
              'About Channel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// 📆 Channel Created Date
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Created:',
              value: _formatDate(channel.publishedAt),
            ),
            const SizedBox(height: 8),

            /// 🌍 Country Info
            _buildInfoRow(
              icon: Icons.flag,
              label: 'Country:',
              value: channel.country.isNotEmpty ? channel.country : 'N/A',
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// 🔥 Info Row Widget
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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

  /// 🔢 Format Large Numbers (e.g., 1M views)
  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
