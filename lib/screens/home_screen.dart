import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchmecook/models/nav_cubit.dart';
import 'package:watchmecook/screens/anime/anime_list.dart';
import 'package:watchmecook/widgets/navigation/nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  final GlobalKey _animeKey = GlobalKey();
  final GlobalKey _quoteskey = GlobalKey();
  final GlobalKey _recipesKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => BottomNavCubit(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 5, right: 5),
            child: Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(
                  color: theme.iconTheme.color,
                  size: 28.0,
                ),
                title: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _getDynamicTitle(),
                    key: ValueKey<int>(_selectedIndex),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          theme.textTheme.headlineMedium?.color ?? Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                centerTitle: true,
                actions: [
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              AnimeScreen(),
              //DiscoverScreen(),
              //DiscoverScreen(),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onTabSelected,
          animeKey: _animeKey,
          quotesKey: _quoteskey,
          recipesKey: _recipesKey,
        ),
      ),
    );
  }

  String _getDynamicTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Anime';
      case 2:
        return 'Quotes';
      case 3:
        return 'Cooking Recipes';
      default:
        return 'Home';
    }
  }
}
