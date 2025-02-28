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
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<Anime>(
        future: _animeDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Failed to load anime details: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No details available'));
          }

          final anime = snapshot.data!;
          return ListView(
            padding: EdgeInsets.all(8.0),
            children: [
              // Gradient Background and Anime Image
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purpleAccent, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
              SizedBox(height: 16),

              // Anime Title
              Text(
                anime.title ?? 'No title available',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
              ),
              SizedBox(height: 8),

              // Anime Synopsis
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  anime.synopsis ?? 'No synopsis available',
                  style: TextStyle(fontSize: 16,),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(height: 16),

              // Score and Genres
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Score: ${anime.score ?? 'N/A'}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                  ),
                  Wrap(
                    children: anime.genres
                        .map((genre) => Chip(label: Text(genre, style: TextStyle())))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // More Details (Optional: Add more fields like airing status, background, etc.)
              anime.background != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        anime.background!,
                        style: TextStyle(fontSize: 14,),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
