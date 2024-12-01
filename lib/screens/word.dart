import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class WordScreen extends StatefulWidget {
  const WordScreen({super.key, required this.word});

  final String word;

  @override
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  List<String> titles = [];

  @override
  void initState() {
    super.initState();
    scrapeData();
  }

  Future<void> scrapeData() async {
    try {
      final dio = Dio(); // Khởi tạo Dio
      final response = await dio.get(
        'https://www.ldoceonline.com/dictionary/${widget.word}',
        options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
      );

      if (response.statusCode == 200) {
        final document = parse(response.data);

        setState(() {
          titles = document
              .querySelectorAll('.dictionary')
              .map((element) => element.outerHtml)
              .toList();
        });
      } else {
        throw Exception('Failed to scrape data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String word = widget.word;

    return Scaffold(
      appBar: AppBar(title: Text(word)),
      body: titles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: HtmlWidget(
                titles[0],
              ),
            ),
    );
  }
}
