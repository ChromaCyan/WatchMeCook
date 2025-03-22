import 'package:flutter/material.dart';
import 'package:watchmecook/models/meal_model.dart';
import 'package:watchmecook/screens/recipe/recipe_detail.dart';
import 'package:watchmecook/services/api.dart';
import 'package:watchmecook/widgets/meal_card.dart';

class MealListScreen extends StatefulWidget {
  @override
  _MealListScreenState createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  late Future<List<Meal>> _mealList;
  List<Meal> _searchResults = [];
  TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "Seafood"; // Default category

  final List<String> _categories = [
    "Seafood",
    "Vegetarian",
    "Chicken",
    "Beef",
    "Dessert",
    "Pasta",
    "Breakfast"
  ];

  @override
  void initState() {
    super.initState();
    _fetchMealsByCategory(_selectedCategory);
  }

  // Fetch meals by selected category
  void _fetchMealsByCategory(String category) {
    setState(() {
      _mealList = ApiService.fetchMealsByCategory(category);
    });
  }

  // Search for meals by name
  void _searchMeal(String mealName) {
    if (mealName.isEmpty) {
      setState(() {
        _searchResults = [];
        _fetchMealsByCategory(_selectedCategory);
      });
      return;
    }

    ApiService.searchMeal(mealName).then((mealList) {
      setState(() {
        _searchResults = mealList;
      });
    }).catchError((error) {
      setState(() {
        _searchResults = [];
      });
    });
  }

  // Fetch and navigate to random meal details
  void _fetchRandomMeal() async {
    try {
      Meal randomMeal = await ApiService.fetchRandomMeal();
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealDetailsScreen(meal: randomMeal),
        ),
      );
    } catch (e) {
    }
  }

  // Navigate to meal details (fetch full details first)
  void _navigateToMealDetails(Meal meal) async {
    try {
      Meal detailedMeal = await ApiService.fetchMealById(meal.id);
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealDetailsScreen(meal: detailedMeal),
        ),
      );
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar - Pinned at the top
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchMeal,
              decoration: InputDecoration(
                hintText: "Search meals by name",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Dropdown for selecting category
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                    _fetchMealsByCategory(value);
                  });
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Main content (Search results or category meals)
          Expanded(
            child: _searchResults.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final meal = _searchResults[index];
                      return MealCard(
                        meal: meal,
                        onTap: () => _navigateToMealDetails(meal),
                      );
                    },
                  )
                : FutureBuilder<List<Meal>>(
                    future: _mealList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              'Failed to load meals: ${snapshot.error}'),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No meals found'));
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final meal = snapshot.data![index];
                          return MealCard(
                            meal: meal,
                            onTap: () => _navigateToMealDetails(meal),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      // Floating Action Button for Random Meal
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchRandomMeal,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.casino, color: Colors.white), // 🎲 Icon
      ),
    );
  }
}
