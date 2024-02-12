import 'package:cloud_student_api/cloud_student_api.dart';
import 'package:local_student_api/local_student_api.dart';
import 'package:student_api/student_api.dart';


// Student? currentStudent;

Future<Student?> fetchCurrentStudentOnline( String userId)async{

  Student? student = await HiveUserRepository().getUserById(userId);

  student ??= await FirestoreUserRepository().getUserById(userId);
  
 return  student;
//  print('THE STUDENT:============================= ${student!.myCourses}');
}


