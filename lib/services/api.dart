import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:watchmecook/models/meal_model.dart';
import 'package:watchmecook/models/quote_model.dart';
import 'package:watchmecook/models/anime_model.dart';
import 'package:watchmecook/models/youtube_channel.dart';
import 'package:watchmecook/models/youtube_model.dart';

class ApiService {
  static const String baseUrl =
      "https://my-motivation-playlist-cooking-a-production.up.railway.app";

  /////////////////////////////////////////////////////////////////////////////////////
  // Anime API

  // Fetch Random Anime
  static Future<Anime> fetchRandomAnime() async {
    final response = await http.get(Uri.parse("$baseUrl/anime/random"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Anime.fromJson(jsonResponse['data']);
    } else {
      throw Exception("Failed to load anime");
    }
  }

  // Fetch Currently Airing Anime
  static Future<List<Anime>> fetchCurrentSeasonAnime() async {
    final response = await http.get(Uri.parse("$baseUrl/anime/season/now"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      List<dynamic> animeList = jsonResponse['data'];
      return animeList.map((anime) => Anime.fromJson(anime)).toList();
    } else {
      throw Exception("Failed to load current season anime");
    }
  }

  // Search Anime by Title
  static Future<List<Anime>> searchAnime(String title) async {
    final response = await http.get(Uri.parse("$baseUrl/anime/search/$title"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      List<dynamic> animeList = jsonResponse['data'];
      return animeList.map((anime) => Anime.fromJson(anime)).toList();
    } else {
      throw Exception("Failed to search anime");
    }
  }

  // Fetch anime details by ID
  static Future<Anime> fetchAnimeById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/anime/$id"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Anime.fromJson(jsonResponse['data']);
    } else {
      throw Exception("Failed to load anime details");
    }
  }
  /////////////////////////////////////////////////////////////////////////////////////
  // Quote API

  // Fetch Random Quote
  static Future<Quote> fetchRandomQuote() async {
    final response = await http.get(Uri.parse("$baseUrl/quotes/random"));
    if (response.statusCode == 200) {
      return Quote.fromJson(jsonDecode(response.body)[0]);
    } else {
      throw Exception("Failed to load quote");
    }
  }

  // Fetch Today's Quote
  static Future<Quote> fetchDailyQuote() async {
    final response = await http.get(Uri.parse("$baseUrl/quotes/today"));
    if (response.statusCode == 200) {
      return Quote.fromJson(jsonDecode(response.body)[0]);
    } else {
      throw Exception("Failed to load daily quote");
    }
  }

  // Fetch Quotes by Author
  static Future<List<Quote>> fetchQuotesByAuthor(String author) async {
    final response =
        await http.get(Uri.parse("$baseUrl/quotes/author/$author"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((quote) => Quote.fromJson(quote)).toList();
    } else {
      throw Exception("Failed to load quotes by author");
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////
  // Meal Recipe API

  // Fetch Random Meal Recipe
  static Future<Meal> fetchRandomMeal() async {
    final response = await http.get(Uri.parse("$baseUrl/meals/random"));
    if (response.statusCode == 200) {
      return Meal.fromJson(jsonDecode(response.body)["meals"][0]);
    } else {
      throw Exception("Failed to load meal");
    }
  }

  // Fetch Meals by Category
  static Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response =
        await http.get(Uri.parse("$baseUrl/meals/category/$category"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["meals"];
      return data.map((meal) => Meal.fromJson(meal)).toList();
    } else {
      throw Exception("Failed to load meals by category");
    }
  }

  // Search Meal by Name
  static Future<List<Meal>> searchMeal(String meal) async {
    final response = await http.get(Uri.parse("$baseUrl/meals/search/$meal"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["meals"];
      return data.map((meal) => Meal.fromJson(meal)).toList();
    } else {
      throw Exception("Failed to search meal");
    }
  }

  // Fetch Full Meal Details by ID
  static Future<Meal> fetchMealById(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/meals/detail/$id"));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return Meal.fromJson(data); // Return full meal details
    } else {
      throw Exception("Failed to load meal details");
    }
  }

  // YouTube API

// Fetch all playlist videos
  static Future<List<Video>> fetchPlaylistVideos() async {
    final response = await http.get(Uri.parse("$baseUrl/youtube/playlist"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['items'];
      return data.map((video) => Video.fromJson(video)).toList();
    } else {
      throw Exception("Failed to load playlist");
    }
  }

// Fetch video details by video_id
  static Future<Video> fetchVideoDetails(String videoId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/youtube/video/$videoId"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['items'][0];
      return Video.fromJson(data);
    } else {
      throw Exception("Failed to load video details");
    }
  }

// Fetch channel details by channel_id
  static Future<Channel> fetchChannelDetails(String channelId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/youtube/channel/$channelId"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['items'][0];
      return Channel.fromJson(data);
    } else {
      throw Exception("Failed to load channel details");
    }
  }
}
