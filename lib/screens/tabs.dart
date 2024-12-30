import 'package:english_dictionary/screens/home.dart';
import 'package:english_dictionary/screens/favorite.dart';
import 'package:english_dictionary/screens/setting.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<String> _favoriteWords = [];
  int _selectedIndex = 0;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleWordFavoriteStatus(String word) {
    final isExisting = _favoriteWords.contains(word);

    if (isExisting) {
      setState(() {
        _favoriteWords.remove(word);
      });
      _showInfoMessage("Removed '$word' from favorites!");
    } else {
      setState(() {
        _favoriteWords.add(word);
      });
      _showInfoMessage("Marked '$word' as a favorite!");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        onToggleFavorite: _toggleWordFavoriteStatus,
      ),
      FavoriteScreen(
        words: _favoriteWords,
        onToggleFavorite: _toggleWordFavoriteStatus,
      ),
      SettingScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: 28),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 28),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
