  import 'package:reviza/misc/course_info.dart';

Future<List<String>> filterBy(
  String university, String school, String department, String year,
)async{
  List<String> filteredList = [];

  for (var entry in data.entries) {
    if (university.isNotEmpty && entry.key != university) continue;

    for (var schoolEntry in entry.value.entries) {
      if (school.isNotEmpty && schoolEntry.key != school) continue;

      for (var departmentEntry in schoolEntry.value.entries) {
        if (department.isNotEmpty && departmentEntry.key != department) continue;

        for (var yearEntry in departmentEntry.value.entries) {
          if (year.isNotEmpty && yearEntry.key != year) continue;

          filteredList.addAll(yearEntry.value);
        }
      }
    }
  }

  return filteredList;
}