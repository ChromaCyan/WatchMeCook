import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:watchmecook/models/anime_model.dart';
import 'package:watchmecook/screens/anime/anime_detail.dart';
import 'package:watchmecook/services/api.dart';
import 'package:watchmecook/widgets/anime_card.dart';

class AnimeScreen extends StatefulWidget {
  @override
  _AnimeScreenState createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimeScreen> {
  late Future<List<Anime>> _featuredAnimeList;
  late Future<List<Anime>> _trendingAnimeList;
  List<Anime> _searchResults = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _featuredAnimeList = ApiService.fetchCurrentSeasonAnime(); // Carousel Anime
    _trendingAnimeList = ApiService.fetchCurrentSeasonAnime(); // Bottom Cards
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // Dark background
      body: Column(
        children: [
          _buildSearchBar(), // Persistent Search Bar
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Spotlight Anime"),
                      _buildAnimeCarousel(_featuredAnimeList), // Top Carousel
                      const SizedBox(height: 20),
                      _buildSectionTitle(
                          _isSearching ? "Search Results" : "Trending"),
                      _isSearching
                          ? _buildSearchResults()
                          : _buildAnimeGrid(_trendingAnimeList),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: _fetchRandomAnime,
                    backgroundColor: Colors.deepPurple,
                    child: const Icon(Icons.shuffle, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔎 Persistent Search Bar
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF2D2D44), // Darker Background for search bar
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search anime...',
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          filled: true,
          fillColor: const Color(0xFF1F1F2E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _isSearching = false;
                      _searchResults = [];
                    });
                  },
                )
              : null,
        ),
        onChanged: (query) {
          if (query.isNotEmpty) {
            _searchAnime(query);
          } else {
            setState(() {
              _isSearching = false;
              _searchResults = [];
            });
          }
        },
      ),
    );
  }

  /// 🔥 Carousel for Featured Anime
  Widget _buildAnimeCarousel(Future<List<Anime>> animeList) {
    return FutureBuilder<List<Anime>>(
      future: animeList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No anime found'));
        }

        return CarouselSlider.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index, realIndex) {
            final anime = snapshot.data![index];
            return _buildFeaturedAnimeCard(anime);
          },
          options: CarouselOptions(
            height: 320,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            autoPlayInterval: const Duration(seconds: 4),
          ),
        );
      },
    );
  }

  /// 🎥 Featured Anime Card in Carousel
  Widget _buildFeaturedAnimeCard(Anime anime) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimeDetailsScreen(animeId: anime.id),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(
                anime.imageUrl ?? 'https://via.placeholder.com/150'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                anime.title ?? 'Unknown Anime',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🎭 Grid for Trending or Search Results
  Widget _buildAnimeGrid(Future<List<Anime>> animeList) {
    return FutureBuilder<List<Anime>>(
      future: animeList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No anime found'));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 cards per row
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final anime = snapshot.data![index];
              return AnimeCard(anime: anime);
            },
          ),
        );
      },
    );
  }

  /// 🔍 Build Search Results as Grid
  Widget _buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _searchResults.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final anime = _searchResults[index];
          return AnimeCard(anime: anime);
        },
      ),
    );
  }

  /// 🟣 Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// 🎲 Random Anime Navigation
  Future<void> _fetchRandomAnime() async {
    final randomAnime = await ApiService.fetchRandomAnime();
    if (randomAnime != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnimeDetailsScreen(animeId: randomAnime.id),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load random anime")),
      );
    }
  }

  /// 🔎 Search Anime by Title
  Future<void> _searchAnime(String query) async {
    try {
      final results = await ApiService.searchAnime(query);
      setState(() {
        _searchResults = results;
        _isSearching = true;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
    }
  }
}
