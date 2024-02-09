import 'package:hive/hive.dart';

part 'study_material_model.g.dart'; // Generated file for Hive TypeAdapter

@HiveType(typeId: 1) // typeId uniquely identifies your class
class StudyMaterial extends HiveObject {
  @HiveField(0) // HiveField is used to identify fields in your class
  String type;

  @HiveField(1)
  String id;

  @HiveField(2)
  String subjectName;

  @HiveField(3)
  String title;

  @HiveField(4)
  List<dynamic> fans;

  @HiveField(5)
  List<dynamic> haters;

  @HiveField(6)
  List<dynamic> reports;

  @HiveField(7)
  String description;

  @HiveField(8)
  String? filePath;

  @HiveField(9)
  int? size;

  StudyMaterial({
    required this.subjectName,
    required this.type,
    required this.id,
    required this.title,
    required this.description,
    required this.filePath,
    required this.fans,
    required this.haters,
    required this.reports,
    required this.size,
  });

  factory StudyMaterial.fromJson(Map<String, dynamic> json) {
    return StudyMaterial(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      filePath: json['filePath'],
      subjectName: json['subject_name'],
      type: json['type'],
      fans: json['fans'],
      haters: json['haters'],
      reports: json['reports'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'filePath': filePath,
      'subject_name': subjectName,
      'type': type,
      'fans': fans,
      'haters': haters,
      'reports': reports,
    };
  }
}
