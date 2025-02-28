import 'package:flutter/material.dart';
import 'package:watchmecook/models/anime_model.dart';
import 'package:watchmecook/services/api.dart';

class AnimeScreen extends StatefulWidget {
  @override
  _AnimeScreenState createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimeScreen> {
  late Future<List<Anime>> _animeList;

  @override
  void initState() {
    super.initState();
    _animeList = ApiService.fetchCurrentSeasonAnime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime List'),
      ),
      body: FutureBuilder<List<Anime>>(
        future: _animeList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load anime: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No anime found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final anime = snapshot.data![index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Image.network(
                    anime.imageUrl ??
                        'https://via.placeholder.com/150', 
                    width: 60,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    anime.title ?? 'No title available',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    anime.synopsis ?? 'No synopsis available',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    anime.score != null ? anime.score.toString() : 'N/A',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
