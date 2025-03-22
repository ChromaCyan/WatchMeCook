import 'package:flutter/material.dart';
import 'package:watchmecook/models/anime_model.dart';
import 'package:watchmecook/services/api.dart';

class AnimeDetailsScreen extends StatefulWidget {
  final int animeId;

  const AnimeDetailsScreen({Key? key, required this.animeId}) : super(key: key);

  @override
  _AnimeDetailsScreenState createState() => _AnimeDetailsScreenState();
}

class _AnimeDetailsScreenState extends State<AnimeDetailsScreen> {
  late Future<Anime> _animeDetails;

  @override
  void initState() {
    super.initState();
    _animeDetails = ApiService.fetchAnimeById(widget.animeId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<Anime>(
        future: _animeDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load anime details: ${snapshot.error}',
                style:
                    theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No details available',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          final anime = snapshot.data!;
          return CustomScrollView(
            slivers: [
              // Collapsible AppBar with Anime Image
              SliverAppBar(
                expandedHeight: 350,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: anime.id,
                        child: Image.network(
                          anime.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.broken_image,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    anime.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Anime Details Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Japanese Title
                      Text(
                        anime.title,
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (anime.titleJapanese != null)
                        Text(
                          anime.titleJapanese!,
                          style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600], fontStyle: FontStyle.italic),
                        ),
                      const SizedBox(height: 12),

                      // Info Row (Type, Episodes, Duration)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoChip('Type', anime.type),
                          _buildInfoChip('Episodes', anime.episodes.toString()),
                          _buildInfoChip('Duration', anime.duration),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Aired Date and Status
                      _buildInfoRow('Aired', anime.airedDate ?? 'Unknown'),
                      _buildInfoRow('Status', anime.status),
                      _buildInfoRow('Rating', anime.rating),
                      const SizedBox(height: 16),

                      // Score
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                          const SizedBox(width: 4),
                          Text(
                            '${anime.score.toString()} / 10',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Genres Chips
                      if (anime.genres.isNotEmpty)
                        Wrap(
                          spacing: 8.0,
                          children: anime.genres
                              .map(
                                (genre) => Chip(
                                  label: Text(
                                    genre,
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(color: theme.colorScheme.onPrimary),
                                  ),
                                  backgroundColor: theme.colorScheme.primary,
                                ),
                              )
                              .toList(),
                        ),
                      const SizedBox(height: 16),

                      // Synopsis Section
                      const Text(
                        'Synopsis',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        anime.synopsis ?? 'No synopsis available.',
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 16),

                      // Background Info Section (Optional)
                      if (anime.background != null && anime.background!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Background Info',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              anime.background!,
                              style: theme.textTheme.bodyLarge,
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Build Info Chips
  Widget _buildInfoChip(String label, String value) {
    return Chip(
      label: Text(
        '$label: $value',
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.deepPurple,
    );
  }

  // Build Info Row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
