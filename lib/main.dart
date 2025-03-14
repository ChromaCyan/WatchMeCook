import 'package:flutter/material.dart';
import 'package:watchmecook/screens/home_screen.dart';
import 'screens/anime/anime_list.dart'; 
import 'config/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Let-Me-Cook',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), 
    );
  }
}
