import 'package:hive/hive.dart';

part 'student_model.g.dart'; // Generated file for Hive TypeAdapter

@HiveType(typeId: 0) // typeId uniquely identifies your class
class Student extends HiveObject {
  @HiveField(0) // HiveField is used to identify fields in your class
  String userId;

  @HiveField(1)
  List<String> myCourses;

  @HiveField(2)
  int? uploadCount;

  @HiveField(3)
  int? downloadCount;

  @HiveField(4)
  int? badUploadCount;

  Student({
    required this.userId,
    required this.myCourses,
    this.uploadCount = 0,
    this.downloadCount = 0,
    this.badUploadCount = 0,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      userId: json['userId'] as String,
      myCourses: List<String>.from(json['myCourses']),
      uploadCount: json['upload_count'] ?? 0,
      downloadCount: json['download_count'] ?? 0,
      badUploadCount: json['bad_upload_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'myCourses': myCourses,
      'upload_count': uploadCount,
      'download_count': downloadCount,
      'bad_upload_count': badUploadCount,
    };
  }

  Student copyWith(
      {List<String>? courses,
      int? uploadCount,
      int? downloadCount,
      int? badUploadCount}) {
    return Student(
      userId: userId,
      myCourses: myCourses,
      uploadCount: uploadCount ?? this.uploadCount,
      downloadCount: downloadCount ?? this.downloadCount,
      badUploadCount: badUploadCount ?? this.badUploadCount,
    );
  }
}
