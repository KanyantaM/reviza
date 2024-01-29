import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedCourse = '';
  String selectedFilter = '';
  List<String> filters = ['Past papers', 'Notes', 'Syllabus', 'Books'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0,0,16,0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
          padding: EdgeInsets.fromLTRB(0, 12,0, 12),
          child: SearchBar(
            hintText: 'search downloads',
            leading: Icon(Icons.search),
          ),
        ),
            const Text(
              'Filter:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8.0,
              children: [
                for (String course in ['Math', 'Science', 'History'])
                  FilterChip(
                    label: Text(course),
                    selected: selectedCourse == course,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCourse = selected ? course : '';
                        selectedFilter = '';
                      });
                    },
                  ),
              ],
            ),
            if (selectedCourse.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Select Filter:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      for (String filter in filters)
                        FilterChip(
                          label: Text(filter),
                          selected: selectedFilter == filter,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedFilter = selected ? filter : '';
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Perform actions based on selectedCourse and selectedFilter
                      print('Course: $selectedCourse, Filter: $selectedFilter');
                    },
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}