class Student {
  String userId;
  List<String> myCourses;

  Student({
    required this.userId,
    required this.myCourses,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      userId: json['userId'] as String,
      myCourses: (json['myCourses'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'myCourses': myCourses,
    };
  }
}
