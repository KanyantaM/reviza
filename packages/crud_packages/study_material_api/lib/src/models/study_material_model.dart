class StudyMaterial {
  ///Whether the material is a pastpaper, notes, books, or link
  String type;

  ///unique ID of material
  String id;

  ///The name of the subect the material belongs to
  String subjectName;

  ///The heading/lecture/name e.t.c
  String title;

  ///The number of uid's that like the documents
  List fans;

  ///The number of uid's that dislike the documents
  List haters;

  ///Number of reports from a particular document
  List reports;

  //info about the document such as year, author, or units
  String description;

  // Assuming you store the file path or URL for the PDF
  String? filePath;

  StudyMaterial(
      {required this.subjectName,
      required this.type,
      required this.id,
      required this.title,
      required this.description,
      required this.filePath,
      required this.fans,
      required this.haters,
      required this.reports});

  factory StudyMaterial.fromJson(Map<String, dynamic> json) {
    print('================================================');
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
