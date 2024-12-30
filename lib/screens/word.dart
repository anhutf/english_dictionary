import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WordScreen extends StatefulWidget {
  const WordScreen({
    super.key,
    required this.word,
    required this.onToggleFavorite,
  });

  final String word;
  final void Function(String word) onToggleFavorite;

  @override
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  late String _targetUrl;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();

    _targetUrl = _buildUrl(widget.word);

    _controller.setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (NavigationRequest request) {
        // Allow navigation only if the URL is the target URL
        if (request.url == _targetUrl) {
          return NavigationDecision.navigate;
        } else {
          return NavigationDecision.prevent;
        }
      },
      onPageFinished: (_) => _onPageFinished(),
      onWebResourceError: (error) => _onError(error),
    ));

    _controller.loadRequest(Uri.parse(_targetUrl));
  }

  String reformatWord(String word) {
    final wordParts = word.split(', ');
    if (wordParts.length == 2) {
      return '${wordParts[1].trim()} ${wordParts[0].trim()}';
    }
    return word; // Return original word if it doesn't contain a comma
  } // Change the word format from 'word, the' to 'the word'

  String _buildUrl(String word) {
    word = reformatWord(word);

    // Remove "the" at the beginning or end of the word
    String cleanedWord = word.trim();
    if (cleanedWord.toLowerCase().startsWith('the ')) {
      cleanedWord = cleanedWord.substring(4);
    }
    if (cleanedWord.toLowerCase().endsWith(' the')) {
      cleanedWord = cleanedWord.substring(0, cleanedWord.length - 4);
    }

    final wordChain = cleanedWord
        .toLowerCase()
        .replaceAll(RegExp(r"&amp;"), 'and') // Change &amp; to 'and'
        .replaceAll(RegExp(r"[^\w\s',/-]+"), '') // Keep only allowed characters
        .replaceAll(RegExp(r"[,'/]+"),
            '-') // Replace commas, single quotes and slashes with a single dash
        .replaceAll(RegExp(r'\s+'), '-') // Replace spaces with a single dash
        .replaceAll(
            RegExp(r'--+'), '-') // Replace multiple dashes with a single dash
        .replaceAll(RegExp(r'^-|-$'), ''); // Remove leading or trailing dashes

    print('https://www.ldoceonline.com/dictionary/$wordChain');

    return 'https://www.ldoceonline.com/dictionary/$wordChain';
  }

  Future<void> _onPageFinished() async {
    if (!mounted || _hasError) {
      return;
    } // Avoid error when the widget is disposed or has error

    const jsCode = """
        document.querySelectorAll('iframe').forEach(iframe => iframe.remove());
        
        document.querySelectorAll('body > *').forEach(element => {
          if (!element.classList.contains('content')) element.remove();
        });

        document.querySelectorAll('.column-left, .responsive_cell2, .pagetitle, .parallax-container, .topics_container, title .Tail, .asset > .crossRef, #ad_btmslot')
            .forEach(element => element.remove());

        // Change anchor element to text node
        document.querySelectorAll('a').forEach(anchor => {
          const textNode = document.createTextNode(anchor.textContent || anchor.innerText);
          anchor.replaceWith(textNode);
        });

        // Add custom style
        const style = document.createElement('style');
        style.textContent = `
          .dictionary { padding-top: 20px; }
          .dictionary_intro {
            border-radius: 8px;
            margin-top: 16px;
            padding: 5px 10px;
            background-color: #ff704d;
          }
           .collo.COLLOC {
            word-wrap: break-word;}
        `;
        document.head.appendChild(style);
    """;
    await _controller.runJavaScript(jsCode);

    // Update the state to hide the loading indicator
    setState(() => _isLoading = false);
  }

  void _onError(WebResourceError error) {
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _hasError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              widget.onToggleFavorite(widget.word);
            },
            icon: Icon(
              Icons.favorite,
              color: theme.colorScheme.primaryContainer,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
        child: Stack(
          children: [
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (_hasError)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error,
                          color: theme.colorScheme.error, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        "Sorry, '${widget.word}' is not available. Try searching for a related word.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, color: theme.colorScheme.error),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text(
                          'Back to search',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (!_isLoading && !_hasError)
              WebViewWidget(controller: _controller),
          ],
        ),
      ),
    );
  }
}
