import 'package:flutter/material.dart';
import 'package:reviza/misc/course_info.dart';

Future<dynamic> showFilterDialogue(
  BuildContext context,
  int depth,
  Function(
    String institution,
    String school,
    String department,
    String year,
  ) fetchCourses,
) {
  return showDialog(
      context: context,
      builder: (context) {
        switch (depth) {
          case 1:
            return AlertDialog(
              content: Wrap(
                children: [
                  _buildDropdown('University', data.keys.toList(), (value) {
                    Navigator.pop(context);

                    fetchCourses(value!, '', '', '');
                    _university = value;
                    _school = '';
                    _department = '';
                    _year = '';
                  }, true),
                ],
              ),
            );
          case 2:
            return AlertDialog(
              content: Wrap(
                children: [
                  _buildSearchableDropdown(
                      'School', data[_university]?.keys.toList() ?? [],
                      (value) {
                    Navigator.pop(context);

                    _school = value;
                    _department = '';
                    _year = '';
                    fetchCourses(_university, value, '', '');
                    //
                  }, (_university.isNotEmpty)),
                ],
              ),
            );
          case 3:
            return AlertDialog(
              content: Wrap(
                children: [
                  _buildSearchableDropdown('Department',
                      data[_university]?[_school]?.keys.toList() ?? [],
                      (value) {
                    Navigator.pop(context);

                    _department = value;
                    _year = '';
                    fetchCourses(_university, _department, value, '');
                    //
                  }, (_school.isNotEmpty)),
                ],
              ),
            );
          case 4:
            return AlertDialog(
              content: Wrap(
                children: [
                  _buildDropdown(
                      'Year',
                      data[_university]?[_school]?[_department]
                              ?.keys
                              .toList()
                              .cast<String>() ??
                          [], (value) {
                    Navigator.pop(context);

                    _year = value ?? '';
                    fetchCourses(_university, _department, _year, value!);
                    //
                  }, (_department.isNotEmpty)),
                ],
              ),
            );

          default:
            return AlertDialog(
              content: Wrap(
                children: [
                  _buildDropdown('University', data.keys.toList(), (value) {
                    Navigator.pop(context);

                    fetchCourses(value!, '', '', '');
                    _university = value;
                    _school = '';
                    _department = '';
                    _year = '';
                  }, true),
                  _buildSearchableDropdown(
                      'School', data[_university]?.keys.toList() ?? [],
                      (value) {
                    Navigator.pop(context);

                    _school = value;
                    _department = '';
                    _year = '';
                    fetchCourses(_university, value, '', '');
                    //
                  }, (_university.isNotEmpty)),
                  _buildSearchableDropdown('Department',
                      data[_university]?[_school]?.keys.toList() ?? [],
                      (value) {
                    Navigator.pop(context);

                    _department = value;
                    _year = '';
                    fetchCourses(_university, _department, value, '');
                    //
                  }, (_school.isNotEmpty)),
                  _buildDropdown(
                      'Year',
                      data[_university]?[_school]?[_department]
                              ?.keys
                              .toList()
                              .cast<String>() ??
                          [], (value) {
                    Navigator.pop(context);

                    _year = value ?? '';
                    fetchCourses(_university, _department, _year, value!);
                    //
                  }, (_department.isNotEmpty)),
                  const SizedBox(height: 20),
                ],
              ),
            );
        }
      });
}

Widget _buildDropdown(String label, List<String> options,
    Function(String?)? onChanged, bool isEnabled) {
  return isEnabled
      ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: label),
            items: options
                .map((option) =>
                    DropdownMenuItem(value: option, child: Text(option)))
                .toList(),
            value: options.isEmpty ? null : options.first, // Set initial value
            onChanged: onChanged,
          ),
        )
      : const Wrap();
}

Widget _buildSearchableDropdown(String label, List<String> options,
    Function(String) onChanged, bool isEnabled) {
  return isEnabled
      ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              return options.where((option) =>
                  option
                      .toLowerCase()
                      .startsWith(textEditingValue.text.toLowerCase()) ||
                  option
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()));
            },
            onSelected: onChanged,
            fieldViewBuilder:
                (context, textEditingController, focusNode, onEditingComplete) {
              return TextFormField(
                decoration: InputDecoration(labelText: label),
                controller: textEditingController,
                focusNode: focusNode,
                onEditingComplete: onEditingComplete,
              );
            },
          ),
        )
      : const Wrap();
}

String _university = '';
String _school = '';
String _department = '';
String _year = '';
