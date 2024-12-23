import 'dart:async';
import 'package:english_dictionary/screens/word.dart';
import 'package:english_dictionary/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _searchResults = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectWord(BuildContext context, String word) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => WordScreen(word: word),
      ),
    );
  }

  Future<void> _fetchSearchResults(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final dio = Dio();
    final url = 'https://www.ldoceonline.com/autocomplete/english/?q=$query';

    try {
      final response = await dio.get(
        url,
        options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
      );

      final Map<String, dynamic> decodedData = jsonDecode(response.data);

      setState(() {
        _searchResults = decodedData['results'] ?? [];
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SearchBarWidget(
          controller: _controller,
          onSearch: _fetchSearchResults,
        ),
        toolbarHeight: 80,
      ),
      body: Stack(
        children: [
          Center(
            child: Text('Home'),
          ),
          if (_searchResults.isNotEmpty)
            Container(
              color: Colors.white,
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> item = _searchResults[index];
                  return ListTile(
                    onTap: () {
                      _selectWord(context, item['searchtext']);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: Text(item['searchtext']),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
