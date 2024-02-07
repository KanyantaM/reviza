import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:reviza/widgets/search_widget.dart';
import 'package:reviza/misc/course_info.dart';
import 'package:reviza/utilities/search_filters.dart';
import 'package:student_api/student_api.dart';

class HomeBottomSheetView extends StatefulWidget {
  final Function(List<String> selectedSubjects) onSave;
  final Student student;
  const HomeBottomSheetView(
      {super.key, required this.student, required this.onSave});

  @override
  State<HomeBottomSheetView> createState() => _HomeBottomSheetViewState();
}

class _HomeBottomSheetViewState extends State<HomeBottomSheetView> {
  List<String> _filteredCourses = [];
  List<String> _searchResults = [];
  final List<String> _selectedSubjects = [];
  bool _isSearching = false;

  String _university = '';
  String _school = '';
  String _department = '';
  String _year = '';

  void _fetchCourses(String uni, String sch, String dep, String yr) async {
    _filteredCourses = await filterBy(uni, sch, dep, yr);
    setState(() {
      
    });
  }

  @override
  void initState() {
    _fetchCourses('', '', '', '');
    _university = '';
    _school = '';
    _department = '';
    _year = '';
    super.initState();
  }

  @override
  void dispose() {
    _filteredCourses = [];
    _searchResults = [];
    _university = '';
    _school = '';
    _department = '';
    _year = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _selectedSubjects.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onSave(_selectedSubjects);
                      },
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      ))
                  : const Wrap(),
              const Text(
                'Add Subjects',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel_outlined))
            ],
          ),
          const Divider(),
          const SizedBox(height: 3.0),
          SearchWidget(
              searchItems: _filteredCourses,
              onChanged: (list) {
                setState(() {
                  _isSearching = true;
                _searchResults = list;
                });
              }),
          const SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0,
            children: [
              selectedFilter('institution', context, _university, 1),
              _university.isNotEmpty
                  ? selectedFilter('school', context, _school, 2)
                  : const Wrap(),
              _school.isNotEmpty
                  ? selectedFilter('dept.', context, _department, 3)
                  : const Wrap(),
              _department.isNotEmpty
                  ? selectedFilter('year', context, _year, 4)
                  : const Wrap(),
            ],
          ),
          Divider(
            color: Theme.of(context).primaryColorDark,
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child:(_isSearching && _searchResults.isEmpty || _filteredCourses.length<2)? Wrap(
                          children: [const Text('We are constantly adding new courses. If you can\'t find your course please contact the team🫡'),
                            Lottie.asset('assets/lottie/indian_searching.json', fit: BoxFit.scaleDown),
                            
                          ],
                        ): ListView.builder(
                shrinkWrap: true,
                itemCount: _isSearching
                    ? _searchResults.length
                    : _filteredCourses.isNotEmpty
                        ? _filteredCourses.length
                        : _filteredCourses
                            .length, // specify the number of items in your list,
                itemBuilder: (context, index) {
                  return _isSearching
                      ? (_searchResults.isNotEmpty?AddSubjectListTile(
                          onTap: (value) {
                            setState(() {
                              if (_selectedSubjects.contains(value)) {
                                _selectedSubjects.remove(value);
                              } else {
                                _selectedSubjects.add(value);
                              }
                            });
                          },
                          value: _searchResults[index],
                          isSelected:
                              _selectedSubjects.contains(_searchResults[index]),
                        ): Column(
                          children: [
                            Lottie.asset('assets/lottie/indian_searching'),
                            const Text('We can\'t find the course\n please contact us to have the course added')
                          ],
                        ))
                      : _filteredCourses.isNotEmpty
                          ? AddSubjectListTile(
                              onTap: (value) {
                                setState(() {
                                  if (_selectedSubjects.contains(value)) {
                                    _selectedSubjects.remove(value);
                                  } else {
                                    _selectedSubjects.add(value);
                                  }
                                });
                              },
                              value: _filteredCourses[index],
                              isSelected: _selectedSubjects
                                  .contains(_filteredCourses[index]),
                            )
                          : AddSubjectListTile(
                              onTap: (value) {
                                setState(() {
                                  if (_selectedSubjects.contains(value)) {
                                    _selectedSubjects.remove(value);
                                  } else {
                                    _selectedSubjects.add(value);
                                  }
                                });
                              },
                              value: _filteredCourses[index],
                              isSelected: _selectedSubjects
                                  .contains(_filteredCourses[index]),
                            );
                },
              ),
              
              ),
              
        ],
      ),
    );
  }

  FilterChip selectedFilter(String filter, BuildContext context, String term, int depth) {
    return FilterChip(
      label: Text(filter),
      selected: term.isNotEmpty,
      onSelected: (bool selected) {
        setState(() {
          showFilterDialogue(context, depth);
        });
      },
    );
  }

  Future<dynamic> showFilterDialogue(BuildContext context, int depth) {
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
                  setState(() {
                    _fetchCourses(value!, '', '', '');
                    _university = value;
                    _school = '';
                    _department = '';
                    _year = '';
                  });
                }, true),
                
              ],
            ),
          );
          case 2:return AlertDialog(
            content: Wrap(
              children: [
                _buildSearchableDropdown(
                    'School', data[_university]?.keys.toList() ?? [], (value) {
                  Navigator.pop(context);
                  setState(() {
                    _school = value;
                    _department = '';
                    _year = '';
                    _fetchCourses(_university, value, '', '');
                    //
                  });
                }, (_university.isNotEmpty)),
              
              ],
            ),
          );
          case 3:
          return AlertDialog(
            content: Wrap(
              children: [
                
                _buildSearchableDropdown('Department',
                    data[_university]?[_school]?.keys.toList() ?? [], (value) {
                  Navigator.pop(context);
                  setState(() {
                    _department = value;
                    _year = '';
                    _fetchCourses(_university, _department, value, '');
                    //
                  });
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
                  setState(() {
                    _year = value ?? '';
                    _fetchCourses(_university, _department, _year, value!);
                    //
                  });
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
                  setState(() {
                    _fetchCourses(value!, '', '', '');
                    _university = value;
                    _school = '';
                    _department = '';
                    _year = '';
                  });
                }, true),
                _buildSearchableDropdown(
                    'School', data[_university]?.keys.toList() ?? [], (value) {
                  Navigator.pop(context);
                  setState(() {
                    _school = value;
                    _department = '';
                    _year = '';
                    _fetchCourses(_university, value, '', '');
                    //
                  });
                }, (_university.isNotEmpty)),
                _buildSearchableDropdown('Department',
                    data[_university]?[_school]?.keys.toList() ?? [], (value) {
                  Navigator.pop(context);
                  setState(() {
                    _department = value;
                    _year = '';
                    _fetchCourses(_university, _department, value, '');
                    //
                  });
                }, (_school.isNotEmpty)),
                _buildDropdown(
                    'Year',
                    data[_university]?[_school]?[_department]
                            ?.keys
                            .toList()
                            .cast<String>() ??
                        [], (value) {
                  Navigator.pop(context);
                  setState(() {
                    _year = value ?? '';
                    _fetchCourses(_university, _department, _year, value!);
                    //
                  });
                }, (_department.isNotEmpty)),
                const SizedBox(height: 20),
              ],
            ),
          );
          
}


        });
  }
}

class AddSubjectListTile extends StatelessWidget {
  const AddSubjectListTile({
    super.key,
    required this.onTap,
    required this.value,
    required this.isSelected,
  });
  final Function(String value) onTap;
  final String value;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            isSelected
                ? InkWell(
                    onTap: () {
                      onTap(value);
                    },
                    child: Icon(
                      Icons.check_box,
                      color: Theme.of(context).primaryColor,
                    ))
                : InkWell(
                    onTap: () {
                      onTap(value);
                    },
                    child: const Icon(Icons.check_box_outline_blank)),
            SizedBox(
              width: 16.h,
              height: 50.h,
            ),
            Expanded(
              child: InkWell(
                child: Text(
                  value,
                  maxLines: 3,
                  overflow:
                      TextOverflow.ellipsis, // Add this line to handle overflow
                ),
                onTap: () {
                  onTap(value);
                },
              ),
            ),
          ],
        ),
        const Divider()
      ],
    );
  }
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
