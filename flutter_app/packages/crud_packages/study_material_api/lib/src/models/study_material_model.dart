import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

part 'study_material_model.g.dart'; // Generated file for Hive TypeAdapter

@HiveType(typeId: 1) // typeId uniquely identifies your class
class StudyMaterial extends HiveObject {
  @HiveField(0)
  final String type;

  @HiveField(1)
  final String id;

  @HiveField(2)
  final String subjectName;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final List<String> fans;

  @HiveField(5)
  final List<String> haters;

  @HiveField(6)
  final List<String> reports;

  @HiveField(7)
  final String description;

  @HiveField(8)
  final String? onlinePath;

  @HiveField(9)
  final int size;

  @HiveField(10)
  final String? localPath;

  @HiveField(11)
  final String uploaderId;

  @HiveField(12)
  final int downloads;

  final double? downloadProgress;

  Future<String?> get revizaStorage async =>
      await _getFilePath(id, subjectName);

  StudyMaterial({
    required this.downloads,
    required this.uploaderId,
    required this.subjectName,
    required this.type,
    required this.id,
    required this.title,
    required this.description,
    required this.onlinePath,
    required this.fans,
    required this.haters,
    required this.reports,
    required this.size,
    required this.localPath,
    this.downloadProgress,
  });

  factory StudyMaterial.fromLocalJson(Map<String, dynamic> json) {
    return StudyMaterial(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? '',
      onlinePath: json['filePath'],
      subjectName: json['subject_name'] ?? 'Unknown Subject',
      type: json['type'] ?? 'Unknown Type',
      fans: List<String>.from(json['fans'] ?? []),
      haters: List<String>.from(json['haters'] ?? []),
      reports: List<String>.from(json['reports'] ?? []),
      size: json['size'] ?? 0,
      localPath: json['local_path'] ?? '',
      uploaderId: json['uploader_id'] ?? '',
      downloads: json['downloads'] ?? 0,
    );
  }

  factory StudyMaterial.fromOnlineJson(Map<String, dynamic> json) {
    return StudyMaterial(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? '',
      onlinePath: json['online_path'],
      subjectName: json['subject_name'] ?? 'Unknown Subject',
      type: json['type'] ?? 'Unknown Type',
      fans: List<String>.from(json['fans'] ?? []),
      haters: List<String>.from(json['haters'] ?? []),
      reports: List<String>.from(json['reports'] ?? []),
      size: json['size'] ?? 0,
      localPath: json['local_path'] ?? '',
      uploaderId: json['uploader_id'] ?? '',
      downloads: json['downloads'] ?? 0,
    );
  }

  Map<String, dynamic> toOnline() {
    final map = {
      'id': id,
      'title': title,
      'description': description,
      'subject_name': subjectName,
      'type': type,
      'fans': fans,
      'haters': haters,
      'reports': reports,
      'size': size,
      'online_path': onlinePath,
      // 'local_path': localPath,
      'uploader_id': uploaderId,
      'downloads': downloads,
    };

    return map;
  }

  Map<String, dynamic> toLocal() {
    final map = {
      'id': id,
      'title': title,
      'description': description,
      'subject_name': subjectName,
      'type': type,
      'fans': fans,
      'haters': haters,
      'reports': reports,
      'size': size,
      'filePath': onlinePath,
      'local_path': localPath,
      'uploader_id': uploaderId,
      'downloaders': downloads,
      'online_path': onlinePath,
    };

    return map;
  }

  Future<bool> get isOnDevice async {
    final String cloudLocal = await _getFilePath(id, subjectName);
    return (File(localPath!).existsSync() || File(cloudLocal).existsSync());
  }

  StudyMaterial copyWith({
    String? type,
    String? id,
    String? subjectName,
    String? title,
    List<String>? fans,
    List<String>? haters,
    List<String>? reports,
    String? description,
    String? onlinePath,
    int? size,
    String? localPath,
    double? downloadProgress,
    int? downloaders,
  }) {
    return StudyMaterial(
      type: type ?? this.type,
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      title: title ?? this.title,
      fans: fans ?? List.from(this.fans),
      haters: haters ?? List.from(this.haters),
      reports: reports ?? List.from(this.reports),
      description: description ?? this.description,
      onlinePath: onlinePath ?? this.onlinePath,
      size: size ?? this.size,
      localPath: localPath ?? this.localPath,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      downloads: downloaders ?? this.downloads,
      uploaderId: uploaderId,
    );
  }
}

Future<String> _getFilePath(String fileId, String subjectName) async {
  final dir = await getApplicationDocumentsDirectory();
  return "${dir.path}/$subjectName/$fileId";
}
