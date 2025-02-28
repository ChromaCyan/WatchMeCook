import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:watchmecook/models/meal_model.dart';
import 'package:watchmecook/models/quote_model.dart';
import 'package:watchmecook/models/anime_model.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:5000";

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
}
