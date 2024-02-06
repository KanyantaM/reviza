// class Student {
//   String userId;
//   List<String> myCourses;

//   Student({
//     required this.userId,
//     required this.myCourses,
//   });

//   factory Student.fromJson(Map<String, dynamic> json) {
//     return Student(
//       userId: json['userId'] as String,
//       myCourses: (json['myCourses'] as List<dynamic>).cast<String>(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'myCourses': myCourses,
//     };
//   }
// }

import 'package:hive/hive.dart';

part 'student_model.g.dart'; // Generated file for Hive TypeAdapter

@HiveType(typeId: 0) // typeId uniquely identifies your class
class Student extends HiveObject {
  @HiveField(0) // HiveField is used to identify fields in your class
  String userId;

  @HiveField(1)
  List<String> myCourses;

  Student({
    required this.userId,
    required this.myCourses,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      userId: json['userId'] as String,
      myCourses: List<String>.from(json['myCourses'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'myCourses': myCourses,
    };
  }
}
