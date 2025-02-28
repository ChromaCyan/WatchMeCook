import 'package:flutter/material.dart';
import 'package:watchmecook/models/anime_model.dart';
import 'package:watchmecook/screens/anime/anime_detail.dart';
import 'package:watchmecook/services/api.dart';

class AnimeScreen extends StatefulWidget {
  @override
  _AnimeScreenState createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimeScreen> {
  late Future<List<Anime>> _animeList;
  late Future<Anime> _randomAnime;
  List<Anime> _searchResults = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animeList = ApiService.fetchCurrentSeasonAnime();
    _randomAnime =
        ApiService.fetchRandomAnime(); // Initial fetch of random anime
  }

  // Function to fetch random anime
  void _fetchRandomAnime() {
    setState(() {
      _randomAnime = ApiService.fetchRandomAnime(); // Fetch a new random anime
    });
  }

  // Function to clear random anime
  void _clearRandomAnime() {
    setState(() {
      _randomAnime = Future.value(null); // Clear random anime
    });
  }

  // Function to search anime by title
  void _searchAnime(String title) {
    if (title.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    ApiService.searchAnime(title).then((animeList) {
      setState(() {
        _searchResults = animeList;
      });
    }).catchError((error) {
      setState(() {
        _searchResults = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load search results')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Wrap the entire body in a SingleChildScrollView
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _searchAnime,
                decoration: InputDecoration(
                  hintText: "Search anime by title",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  ),
                ),
              ),
            ),

            // Random Anime Section
            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Random Anime",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _fetchRandomAnime,
                    child: Text("Get Random Anime"),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 10),
                  // Display Random Anime
                  FutureBuilder<Anime>(
                    future:
                        _randomAnime, // The Future that fetches the random anime
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Anime searching'));
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Text('No random anime found'));
                      }

                      final randomAnime = snapshot.data!;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AnimeDetailsScreen(animeId: randomAnime.id),
                            ),
                          );
                        },
                        child: _buildAnimeCard(randomAnime),
                      );
                    },
                  ),
                ],
              ),
            ),

            Text(
              "Hottest Anime for this Season!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            // Display Search Results
            if (_searchResults.isNotEmpty)
              ListView.builder(
                shrinkWrap:
                    true, // Allow ListView to take only as much space as it needs
                physics:
                    NeverScrollableScrollPhysics(), // Prevent scrolling inside the ListView
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final anime = _searchResults[index];
                  return _buildAnimeCard(anime);
                },
              )

            // Display Current Season Anime List
            else if (_searchController.text.isEmpty)
              FutureBuilder<List<Anime>>(
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
                    shrinkWrap:
                        true, // Allow ListView to take only as much space as it needs
                    physics:
                        NeverScrollableScrollPhysics(), // Prevent scrolling inside the ListView
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final anime = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AnimeDetailsScreen(animeId: anime.id),
                            ),
                          );
                        },
                        child: _buildAnimeCard(anime),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // Helper function to build anime cards with improved design
  Widget _buildAnimeCard(Anime anime) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purpleAccent, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(15),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                anime.imageUrl ?? 'https://via.placeholder.com/150',
                width: 80,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              anime.title ?? 'No title available',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
                shadows: [
                  Shadow(
                      color: Colors.black45,
                      blurRadius: 3,
                      offset: Offset(1, 1)),
                ],
              ),
            ),
            subtitle: Text(
              anime.synopsis ?? 'No synopsis available',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                shadows: [
                  Shadow(
                      color: Colors.black45,
                      blurRadius: 3,
                      offset: Offset(1, 1)),
                ],
              ),
            ),
            trailing: Text(
              anime.score != null ? anime.score.toString() : 'N/A',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
