import 'package:english_dictionary/screens/word.dart';
import 'package:english_dictionary/widgets/word_item.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({
    super.key,
    required this.words,
    required this.onToggleFavorite,
  });

  final List<String> words;
  final void Function(String word) onToggleFavorite;

  void _selectWord(BuildContext context, String word) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => WordScreen(
          word: word,
          onToggleFavorite: onToggleFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: words.length + 1, // Add 1 for the header
      itemBuilder: (ctx, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  'New favorite words',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        } else {
          return WordItem(
            word: words[index - 1],
            onSelectWord: (meal) {
              _selectWord(context, meal);
            },
          );
        }
      },
    );

    if (words.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Uh oh ... nothing here!',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Try adding some words to your favorites.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: content,
    );
  }
}
