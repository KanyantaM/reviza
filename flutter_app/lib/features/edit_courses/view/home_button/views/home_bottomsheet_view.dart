import 'package:flutter/material.dart';
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
    _isSearching.value = results.isNotEmpty;
    _searchResults.value = results;
  }

  void _onSubjectTapped(String value) {
    setState(() {
      _selectedSubjects.contains(value)
          ? _selectedSubjects.remove(value)
          : _selectedSubjects.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 12),
              SearchWidget(
                searchItems: _filteredCourses.value,
                onChanged: _onSearchChanged,
              ),
              SizedBox(height: 12),
              _buildFilterChips(),
              SizedBox(height: 12),
              Expanded(child: _buildCourseList(scrollController)),
              _buildBottomActionBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.redAccent),
        ),
        const Text(
          'Select Subjects',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: _selectedSubjects.isNotEmpty
              ? () {
                  Navigator.pop(context);
                  widget.onSave(_selectedSubjects);
                }
              : null,
          icon: Icon(
            Icons.check_circle_outline,
            color: _selectedSubjects.isNotEmpty ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildFilterChip('Institution', _university, 1),
        if (_university.isNotEmpty) _buildFilterChip('School', _school, 2),
        if (_school.isNotEmpty) _buildFilterChip('Department', _department, 3),
        if (_department.isNotEmpty) _buildFilterChip('Year', _year, 4),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value, int depth) {
    return GestureDetector(
      onTap: () =>
          showFilterDialogue(context, depth, (uni, sch, dep, yr) async {
        _filteredCourses.value = await filterBy(uni, sch, dep, yr);
        setState(() {
          _university = uni;
          _school = sch;
          _department = dep;
          _year = yr;
        });
      }),
      child: Chip(
        backgroundColor: value.isNotEmpty
            ? Colors.blueAccent.withValues(alpha: 0.2)
            : Colors.grey.shade200,
        label: Text(label),
        avatar: Icon(
          Icons.filter_alt_outlined,
          size: 18,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildCourseList(ScrollController scrollController) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSearching,
      builder: (_, isSearching, __) {
        return ValueListenableBuilder<List<String>>(
          valueListenable: isSearching ? _searchResults : _filteredCourses,
          builder: (_, courses, __) {
            if (courses.isEmpty) return _buildEmptyState();

            return ListView.builder(
              controller: scrollController,
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
        const Text(
          'No courses found.\nPlease contact us to add your course!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _selectedSubjects.isNotEmpty
                  ? () {
                      Navigator.pop(context);
                      widget.onSave(_selectedSubjects);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedSubjects.isNotEmpty
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                "Save Subjects",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
