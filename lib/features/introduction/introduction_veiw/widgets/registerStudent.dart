import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/features/introduction/introduction_bloc/bloc/introduction_bloc_bloc.dart';

class CourseSelectionWidget extends StatefulWidget {
  final String studentId;
  final Map<String, Map<String, Map<String, Map<String, List<String>>>>> data;

  const CourseSelectionWidget({super.key, required this.data, required this.studentId});

  @override
  State<CourseSelectionWidget> createState() => _CourseSelectionWidgetState();
}

class _CourseSelectionWidgetState extends State<CourseSelectionWidget> {
  String selectedUniversity = '';
  String selectedSchool = '';
  String selectedDepartment = '';
  String selectedYear = '';
  List<String> selectedCourses = [];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildDropdown('University', widget.data.keys.toList(), (value) {
          setState(() {
            selectedUniversity = value?? '';
            selectedSchool = '';
            selectedDepartment = '';
            selectedYear = '';
            selectedCourses = [];
          });
        }),
        if (selectedUniversity.isNotEmpty)
          _buildSearchableDropdown('School', widget.data[selectedUniversity]!.keys.toList(), (value) {
            setState(() {
              selectedSchool = value;
              selectedDepartment = '';
              selectedYear = '';
              // selectedCourses = [];
            });
          }),
        if (selectedSchool.isNotEmpty)
          _buildSearchableDropdown('Department', widget.data[selectedUniversity]![selectedSchool]!.keys.toList(), (value) {
            setState(() {
              selectedDepartment = value;
              selectedYear = '';
              // selectedCourses = [];
            });
          }),
        if (selectedDepartment.isNotEmpty)
          _buildDropdown('Year', widget.data[selectedUniversity]![selectedSchool]![selectedDepartment]!.keys.toList().cast<String>(), (value) {
            setState(() {
              selectedYear = value?? '';
              // selectedCourses = [];
            });
          }),
                if (selectedYear.isNotEmpty)
          _buildCoursesChips('Courses', widget.data[selectedUniversity]![selectedSchool]![selectedDepartment]![selectedYear]!),
        const SizedBox(height: 20),
        _buildSelectedCourses(),
        ElevatedButton(
          onPressed: _saveCourses,
          child: const Text('Save'),
        ),
      ],
    );
  }
  Widget _buildCoursesChips(String label, List<String> options) {
    return Wrap(
      spacing: 8.0,
      children: [
        Text('$label:'),
        for (var option in options)
          FilterChip(
            label: Text(option.split('-').first),
            selected: selectedCourses.contains(option),
            onSelected: (value) {
              setState(() {
                if (selectedCourses.contains(option)) {
                  selectedCourses.remove(option);
                } else {
                  selectedCourses.add(option);
                }
              });
            },
            selectedColor: selectedCourses.contains(option) ? Colors.green : null,
          ),
      ],
    );
  }

  Widget _buildSelectedCourses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selected Courses:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8.0,
          children: [
            for (var course in selectedCourses)
              Chip(
                label: Text(course),
                onDeleted: () {
                  setState(() {
                    selectedCourses.remove(course);
                  });
                },
              ),
          ],
        ),
      ],
    );
  }

  void _saveCourses() {
    context.read<IntroductionBloc>().add(RegisterStudent(studentId: widget.studentId, courses: selectedCourses));
  }
}

Widget _buildDropdown(String label, List<String> options, Function(String?)? onChanged) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(labelText: label),
    items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
    value: options.isEmpty ? null : options.first, // Set initial value
    onChanged: onChanged,
  );
}

Widget _buildSearchableDropdown(String label, List<String> options, Function(String) onChanged) {
  return Autocomplete<String>(
    optionsBuilder: (TextEditingValue textEditingValue) {
      if (textEditingValue.text.isEmpty) {
        return const Iterable<String>.empty();
      }
      return options.where((option) => option.toLowerCase().startsWith(textEditingValue.text.toLowerCase()) || option.toLowerCase().contains(textEditingValue.text.toLowerCase())) ;
    },
    onSelected: onChanged,
    fieldViewBuilder: (context, textEditingController, focusNode, onEditingComplete) {
      return TextFormField(
        decoration: InputDecoration(labelText: label),
        controller: textEditingController,
        focusNode: focusNode,
        onEditingComplete: onEditingComplete,
      );
    },
  );
}
