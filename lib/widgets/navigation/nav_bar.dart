import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  final GlobalKey animeKey;
  final GlobalKey quotesKey;
  final GlobalKey recipesKey;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.animeKey,
    required this.quotesKey,
    required this.recipesKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
              Icons.tv,
              "Anime",
              0,
              colorScheme.primary,
              animeKey,
              context,
              "Browse the latest anime and trending series"),
          _buildNavItem(
              Icons.featured_video_rounded,
              "Playlist",
              1,
              colorScheme.primary,
              quotesKey,
              context,
              "Get daily motivational and thought-provoking quotes"),
          _buildNavItem(
              Icons.restaurant_menu,
              "Recipes",
              2,
              colorScheme.primary,
              recipesKey,
              context,
              "Discover delicious cooking recipes and meal ideas"),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon,
      String label,
      int index,
      Color primaryColor,
      GlobalKey key,
      BuildContext context,
      String description) {
    bool isSelected = selectedIndex == index;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        onItemTapped(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.grey,
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  label,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
