import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/AiringTodayScreen.dart';
import 'screens/TVShowsScreen.dart';
import 'providers/movie_provider.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => MovieProvider(), child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const TVShowsScreen(),
    const AiringTodayScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trending Movie Viewer',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.redAccent,
        colorScheme: ColorScheme.dark(
          primary: Colors.redAccent,
          secondary: Colors.redAccent,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(
            255,
            0,
            0,
            0,
          ),
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: Colors.redAccent, 
          unselectedItemColor: Colors.white, 
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.movie),
              label: 'Trending Movies',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'TV Shows'),
            BottomNavigationBarItem(
              icon: Icon(Icons.live_tv),
              label: 'Airing Today',
            ),
          ],
        ),
      ),
    );
  }
}
