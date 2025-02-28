import 'dart:convert';

class Meal {
  final String name;
  final String instructions;
  final String imageUrl;

  Meal({
    required this.name,
    required this.instructions,
    required this.imageUrl,
  });

  factory Meal.fromJson(String str) =>
      Meal.fromMap(json.decode(str)["meals"][0]);

  factory Meal.fromMap(Map<String, dynamic> json) => Meal(
        name: json["strMeal"],
        instructions: json["strInstructions"],
        imageUrl: json["strMealThumb"],
      );
}
