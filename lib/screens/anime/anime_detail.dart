import 'package:flutter/material.dart';
import 'package:watchmecook/models/anime_model.dart';
import 'package:watchmecook/services/api.dart';

class AnimeDetailsScreen extends StatefulWidget {
  final int animeId;

  AnimeDetailsScreen({required this.animeId});

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
      appBar: AppBar(
        title: const Text('Anime Details'),
        backgroundColor: theme.colorScheme.primary,
      ),
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
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
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
          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              // Gradient Background and Anime Image
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    anime.imageUrl ?? 'https://via.placeholder.com/150',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Anime Title
              Text(
                anime.title ?? 'No title available',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Anime Synopsis
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  anime.synopsis ?? 'No synopsis available',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 16),

              // Score and Genres
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Score: ${anime.score ?? 'N/A'}',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 6.0,
                    children: anime.genres
                        .map(
                          (genre) => Chip(
                            label: Text(
                              genre,
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary),
                            ),
                            backgroundColor: theme.colorScheme.primary,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Background Info (if available)
              if (anime.background != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    anime.background!,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
