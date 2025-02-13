import 'package:flutter/material.dart';
import 'package:study_material_repository/study_material_repository.dart';

Future<dynamic> showFilterDialog(
  BuildContext context,
  int depth,
  Function(String institution, String school, String department, String year)
      fetchCourses,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Filter Courses",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (depth >= 1)
                  _buildDropdown("University", data.keys.toList(), (value) {
                    _university = value!;
                    _school = '';
                    _department = '';
                    _year = '';
                    fetchCourses(_university, '', '', '');
                  }, true),
                if (depth >= 2 && _university.isNotEmpty)
                  _buildSearchableDropdown(
                      "School", data[_university]?.keys.toList() ?? [],
                      (value) {
                    _school = value;
                    _department = '';
                    _year = '';
                    fetchCourses(_university, _school, '', '');
                  }),
                if (depth >= 3 && _school.isNotEmpty)
                  _buildSearchableDropdown("Department",
                      data[_university]?[_school]?.keys.toList() ?? [],
                      (value) {
                    _department = value;
                    _year = '';
                    fetchCourses(_university, _school, _department, '');
                  }),
                if (depth >= 4 && _department.isNotEmpty)
                  _buildDropdown(
                      "Year",
                      data[_university]?[_school]?[_department]
                              ?.keys
                              .toList()
                              .cast<String>() ??
                          [], (value) {
                    _year = value!;
                    fetchCourses(_university, _school, _department, _year);
                  }, _department.isNotEmpty),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text("Apply Filters",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildDropdown(String label, List<String> options,
    Function(String?)? onChanged, bool isEnabled) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: isEnabled ? Colors.white : Colors.grey[200],
      ),
      items: options
          .map((option) => DropdownMenuItem(value: option, child: Text(option)))
          .toList(),
      value: options.isNotEmpty ? options.first : null,
      onChanged: isEnabled ? onChanged : null,
    ),
  );
}

Widget _buildSearchableDropdown(
    String label, List<String> options, Function(String) onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return options;
        }
        return options.where((option) =>
            option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: onChanged,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onEditingComplete) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.white,
          ),
          controller: textEditingController,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
        );
      },
    ),
  );
}

String _university = '';
String _school = '';
String _department = '';
String _year = '';
