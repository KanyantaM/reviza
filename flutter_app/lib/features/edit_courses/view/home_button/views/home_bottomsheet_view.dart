import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  String? _university;
  String? _school;
  String? _department;
  String? _year;

  Future<void> _startFromScratch() async {
    _filteredCourses.value = await filterBy(
      _university ?? '',
      _school ?? '',
      _department ?? '',
      _year ?? '',
    );
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

  void _resetFilter(int depth) {
    setState(() {
      if (depth == 1) _university = null;
      if (depth == 2) _school = null;
      if (depth == 3) _department = null;
      if (depth == 4) _year = null;
      _startFromScratch();
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActionButtons(),
              SizedBox(height: 12.h),
              SearchWidget(
                searchItems: _filteredCourses.value,
                onChanged: _onSearchChanged,
              ),
              SizedBox(height: 12.h),
              _buildFilterChips(),
              SizedBox(height: 12.h),
              Expanded(child: _buildCourseList(scrollController)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        Text(
          'Select Subjects',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: _selectedSubjects.isNotEmpty
              ? () {
                  Navigator.pop(context);
                  widget.onSave(_selectedSubjects);
                }
              : null,
          child: Text("Add",
              style: TextStyle(
                  color: _selectedSubjects.isNotEmpty
                      ? Colors.green
                      : Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _buildFilterChip('Institution', _university, 1),
        if (_university != null) _buildFilterChip('School', _school, 2),
        if (_school != null) _buildFilterChip('Department', _department, 3),
        if (_department != null) _buildFilterChip('Year', _year, 4),
      ],
    );
  }

  Widget _buildFilterChip(String label, String? value, int depth) {
    return GestureDetector(
      onTap: () => value == null
          ? showFilterDialogue(context, depth, (uni, sch, dep, yr) async {
              _filteredCourses.value = await filterBy(uni, sch, dep, yr);
              setState(() {
                if (depth == 1) _university = uni;
                if (depth == 2) _school = sch;
                if (depth == 3) _department = dep;
                if (depth == 4) _year = yr;
              });
            })
          : _resetFilter(depth),
      child: Chip(
        backgroundColor: value != null
            ? Colors.blueAccent.withOpacity(0.2)
            : Colors.grey.shade200,
        label: Text(value ?? label),
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
    return Center(
      child: Text(
        'No courses found. Please contact us to add your course!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
