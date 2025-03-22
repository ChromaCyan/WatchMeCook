import 'package:flutter/material.dart';
import 'package:watchmecook/models/meal_model.dart';

class MealDetailsScreen extends StatelessWidget {
  final Meal meal;

  const MealDetailsScreen({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible AppBar with Meal Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Meal Image
                  Hero(
                    tag: meal.id,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: Image.network(
                        meal.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported,
                                size: 100, color: Colors.grey),
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                meal.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Meal Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal Name & Category
                  Text(
                    meal.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Category and Area
                  Text(
                    "${meal.category} | ${meal.area}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info Row (Time, Difficulty, Source)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoCard(Icons.timer, "45 min"),
                      _buildInfoCard(Icons.local_fire_department, "Easy"),
                      _buildInfoCard(Icons.link, "Source",
                          isLink: true, url: meal.sourceUrl),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ingredients & Instructions
                  const Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildIngredientsList(meal),

                  const SizedBox(height: 16),
                  const Text(
                    "Instructions",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meal.instructions,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),

                  // Watch on YouTube Button
                  if (meal.youtubeUrl.isNotEmpty)
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Launch YouTube URL
                          _launchUrl(meal.youtubeUrl);
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Watch on YouTube"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Info Card Widget (Time, Difficulty, Source)
  Widget _buildInfoCard(IconData icon, String text,
      {bool isLink = false, String? url}) {
    return GestureDetector(
      onTap: isLink && url != null ? () => _launchUrl(url) : null,
      child: Column(
        children: [
          Icon(icon, size: 30, color: isLink ? Colors.blue : Colors.deepPurple),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isLink ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Build Ingredients List
  Widget _buildIngredientsList(Meal meal) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: meal.ingredients.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.check_circle_outline, color: Colors.green),
          title: Text(
            "${meal.measurements[index]} ${meal.ingredients[index]}",
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  // Launch URL Function
  void _launchUrl(String url) async {
    // Add your URL launching logic here
    debugPrint("Opening URL: $url");
  }
}
