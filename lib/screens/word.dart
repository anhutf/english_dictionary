import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WordScreen extends StatefulWidget {
  const WordScreen({super.key, required this.word});

  final String word;

  @override
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();

    final wordChain = widget.word.toLowerCase().replaceAll(RegExp(r'\s+'), '-');
    final url = 'https://www.ldoceonline.com/dictionary/$wordChain';

    _controller.setNavigationDelegate(NavigationDelegate(
      onPageStarted: (String url) {},
      onPageFinished: (String url) async {
        await _controller.runJavaScript("""
        document.querySelectorAll('iframe').forEach((iframe) => {
        iframe.remove();
        });

        document.querySelectorAll('body > *').forEach((element) => {
        if (!element.classList.contains('content')) {
          element.remove();
        }
        });

        const columnLeft = document.body.querySelectorAll('.column-left');
        columnLeft.forEach(element => element.remove());

        const columnRight = document.body.querySelectorAll('.responsive_cell2');
        columnRight.forEach(element => element.remove());

        const titleElement = document.body.querySelectorAll('.pagetitle');
        titleElement.forEach(element => element.remove());

        const adsElement = document.body.querySelectorAll('.parallax-container');
        adsElement.forEach(element => element.remove());

        const topicElement = document.body.querySelectorAll('.topics_container');
        topicElement.forEach(element => element.remove());

        const tailElement = document.body.querySelectorAll('title .Tail');
        tailElement.forEach(element => element.remove());

        const crossRefElement = document.body.querySelectorAll('.asset > .crossRef');
        crossRefElement.forEach(element => element.remove());

        const adsBottom = document.body.querySelectorAll('#ad_btmslot');
        adsBottom.forEach(element => element.remove());

        // Change anchor element to text
        document.querySelectorAll('a').forEach(anchor => {
        const textNode = document.createTextNode(anchor.textContent || anchor.innerText);
        anchor.replaceWith(textNode);
        });

        """);

        // Complete loading
        setState(() {
          _isLoading = false;
        });
      },
    ));

    _controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.word,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.favorite,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 16),
        child: Stack(
          children: [
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (!_isLoading) WebViewWidget(controller: _controller),
          ],
        ),
      ),
    );
  }
}
