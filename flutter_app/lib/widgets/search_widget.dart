import 'dart:async';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final Function(List<String> results) onChanged;
  final List<String> searchItems;

  const SearchWidget({
    super.key,
    required this.searchItems,
    required this.onChanged,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<String> _searchResults = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchResults = List.from(widget.searchItems); // Initialize with all items
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchResults = query.isEmpty
            ? List.from(widget.searchItems)
            : widget.searchItems
                .where(
                    (item) => item.toLowerCase().contains(query.toLowerCase()))
                .toList();

        _searchResults.sort((a, b) {
          int indexA = a.toLowerCase().indexOf(query.toLowerCase());
          int indexB = b.toLowerCase().indexOf(query.toLowerCase());
          return indexA.compareTo(indexB);
        });
      });

      widget.onChanged(_searchResults);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
    _searchFocusNode.unfocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: "Search for a course",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
              : null,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
