import 'package:english_dictionary/screens/word.dart';
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
  bool _isLoading = false;

  void _selectWord(BuildContext context, String word) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => WordScreen(word: word),
      ),
    );
  }

  Future<void> _fetchSearchResults(String query) async {
    if (query.isEmpty) return;
    setState(() => _isLoading = true);

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
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nhập từ để tìm kiếm',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _fetchSearchResults(_controller.text),
                ),
              ),
              onSubmitted: _fetchSearchResults,
            ),
          ),
          if (_isLoading) const CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> item = _searchResults[index];
                return ListTile(
                  onTap: () {
                    _selectWord(context, item['searchtext']);
                  },
                  title: Text(item['searchtext'] ?? 'Không có tiêu đề'),
                  subtitle: Text(item['type'] ?? 'Không có loại'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
