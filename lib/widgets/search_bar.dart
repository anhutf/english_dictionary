import 'dart:async';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const SearchBarWidget(
      {super.key, required this.controller, required this.onSearch});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _fetchSearchResults(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        widget.onSearch(query);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 236, 236, 236),
        hintText: 'Type to search',
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        suffixIcon: (widget.controller.text.isNotEmpty)
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  widget.controller.clear();
                  widget.onSearch('');
                },
              )
            : Icon(Icons.search),
      ),
      onChanged: _fetchSearchResults,
    );
  }
}
