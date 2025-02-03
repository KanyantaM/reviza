import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:reviza/features/edit_courses/view/home_button/views/components/add_subject_listile.dart';
import 'package:reviza/features/edit_courses/view/home_button/views/components/filter_dialogue.dart';
import 'package:reviza/widgets/search_widget.dart';
import 'package:reviza/utilities/search_filters.dart';
import 'package:student_api/student_api.dart';

class HomeBottomSheetView extends StatefulWidget {
  final Function(List<String> selectedSubjects) onSave;
  final Student student;

  const HomeBottomSheetView({
    super.key,
    required this.student,
    required this.onSave,
  });

  @override
  State<HomeBottomSheetView> createState() => _HomeBottomSheetViewState();
}

class _HomeBottomSheetViewState extends State<HomeBottomSheetView> {
  final List<String> _selectedSubjects = [];
  final ValueNotifier<List<String>> _filteredCourses = ValueNotifier([]);
  final ValueNotifier<List<String>> _searchResults = ValueNotifier([]);
  final ValueNotifier<bool> _isSearching = ValueNotifier(false);

  String _university = '';
  String _school = '';
  String _department = '';
  String _year = '';

  Future<void> _startFromScratch() async {
    _filteredCourses.value =
        await filterBy(_university, _school, _department, _year);
  }

  @override
  void initState() {
    super.initState();
    _startFromScratch();
  }

  void _onSearchChanged(List<String> results) {
    _isSearching.value = true;
    _searchResults.value = results;
    setState(() {});
  }

  void _onSubjectTapped(String value) {
    setState(() {
      _selectedSubjects.contains(value)
          ? _selectedSubjects.remove(value)
          : _selectedSubjects.add(value);
    });
  }

  void _resetFilter(int depth) {
    setState(() {
      if (depth == 1) _university = '';
      if (depth == 2) _school = '';
      if (depth == 3) _department = '';
      if (depth == 4) _year = '';
      _startFromScratch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                Divider(color: Colors.grey[400]),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        SearchWidget(
                          searchItems: _filteredCourses.value,
                          onChanged: _onSearchChanged,
                        ),
                        SizedBox(height: 12),
                        _buildFilterChips(),
                        Divider(color: Theme.of(context).primaryColorDark),
                        _buildCourseList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Text(
            'Courses',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: _selectedSubjects.isNotEmpty
                ? () {
                    Navigator.pop(context);
                    widget.onSave(_selectedSubjects);
                  }
                : null,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Opacity(
                opacity: _selectedSubjects.isNotEmpty ? 1.0 : 0.5,
                child: Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8,
      children: [
        _buildFilterChip('Institution', _university, 1),
        if (_university.isNotEmpty) _buildFilterChip('School', _school, 2),
        if (_school.isNotEmpty) _buildFilterChip('Department', _department, 3),
        if (_department.isNotEmpty) _buildFilterChip('Year', _year, 4),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value, int depth) {
    return FilterChip(
      label: Text(value.isNotEmpty ? "$label: $value" : label,
          style: TextStyle(fontSize: 14)),
      selected: value.isNotEmpty,
      onSelected: (_) {
        if (value.isNotEmpty) {
          _resetFilter(depth);
        } else {
          showFilterDialog(context, depth, (uni, sch, dep, yr) async {
            _filteredCourses.value = await filterBy(uni, sch, dep, yr);
            setState(() {
              _university = uni;
              _school = sch;
              _department = dep;
              _year = yr;
            });
          });
        }
      },
    );
  }

  Widget _buildCourseList() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSearching,
      builder: (_, isSearching, __) {
        return ValueListenableBuilder<List<String>>(
          valueListenable: isSearching ? _searchResults : _filteredCourses,
          builder: (_, courses, __) {
            if (courses.isEmpty) return _buildEmptyState();

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: courses.length,
              itemBuilder: (_, index) => AddSubjectListTile(
                value: courses[index],
                isSelected: _selectedSubjects.contains(courses[index]),
                onTap: _onSubjectTapped,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No courses found.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        Lottie.asset('assets/lottie/indian_searching.json', height: 150),
      ],
    );
  }
}
