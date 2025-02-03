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
  State<SearchWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchWidget> {
  PageController controller = PageController();
  ScrollController hideScrollCtr = ScrollController();
  List<String> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  void _resetSearchParameters() {
    _searchResults = [];
  }

  void _startSearch() {
    setState(() {});
  }

  void search(String query, List<String> itemList) {
    if (query.isNotEmpty) {
      _searchResults = [];

      List<String> uniResults = itemList
          .where((item) => item.toLowerCase().startsWith(query.toLowerCase()))
          .toList();

      _searchResults.addAll(uniResults);

      // Custom sorting based on the position of the query in item names
      _searchResults.sort((a, b) {
        int indexA = a.toLowerCase().indexOf(query.toLowerCase());
        int indexB = b.toLowerCase().indexOf(query.toLowerCase());

        // If the query is at the beginning, prioritize it
        if (indexA == 0 && indexB != 0) {
          return -1;
        } else if (indexB == 0 && indexA != 0) {
          return 1;
        }

        // Otherwise, sort based on the index
        return indexA.compareTo(indexB);
      });
    } else {
      _resetSearchParameters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _searchBar(context, widget.searchItems);
  }

  Widget _searchBar(BuildContext context, List<String> courses) {
    return SearchBar(
      controller: _searchController,
      hintText: "Search for course",
      focusNode: _searchFocusNode,
      onChanged: (value) {
        _startSearch();
        search(value, courses);
        widget.onChanged(_searchResults);
      },
      onTap: () {
        _searchFocusNode.requestFocus();
      },
    );
  }
}
