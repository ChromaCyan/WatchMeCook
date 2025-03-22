class Meal {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String imageUrl;
  final String youtubeUrl;
  final String sourceUrl;
  final List<String> ingredients;
  final List<String> measurements;

  Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.imageUrl,
    required this.youtubeUrl,
    required this.sourceUrl,
    required this.ingredients,
    required this.measurements,
  });

  // Factory constructor to parse JSON data from API
  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> extractedIngredients = [];
    List<String> extractedMeasurements = [];

    // Loop through 1 to 20 to get ingredients and measurements dynamically
    for (int i = 1; i <= 20; i++) {
      String ingredient = json['strIngredient$i']?.trim() ?? '';
      String measure = json['strMeasure$i']?.trim() ?? '';

      // Add only non-empty ingredients and measurements
      if (ingredient.isNotEmpty && ingredient != '') {
        extractedIngredients.add(ingredient);
        extractedMeasurements.add(measure.isNotEmpty ? measure : 'To taste');
      }
    }

    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? 'Unknown',
      category: json['strCategory'] ?? 'Uncategorized',
      area: json['strArea'] ?? 'Unknown Area',
      instructions: json['strInstructions'] ?? 'No instructions provided',
      imageUrl: json['strMealThumb'] ??
          'https://via.placeholder.com/150', // Fallback image
      youtubeUrl: json['strYoutube'] ?? '',
      sourceUrl: json['strSource'] ?? '',
      ingredients: extractedIngredients,
      measurements: extractedMeasurements,
    );
  }
}
