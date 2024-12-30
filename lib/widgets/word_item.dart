import 'package:flutter/material.dart';

class WordItem extends StatelessWidget {
  const WordItem({
    super.key,
    required this.word,
    required this.onSelectWord,
  });

  final String word;
  final void Function(String word) onSelectWord;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: InkWell(
        onTap: () {
          onSelectWord(word);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            word,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
      ),
    );
  }
}
