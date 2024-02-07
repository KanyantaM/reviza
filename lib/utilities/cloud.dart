import 'package:cloud_student_api/cloud_student_api.dart';
import 'package:student_api/student_api.dart';


// Student? currentStudent;

Future<Student?> fetchCurrentStudentOnline( String userId)async{
  
 return  FirestoreUserRepository().getUserById(userId);
//  print('THE STUDENT:============================= ${student!.myCourses}');
}

void fetchCurrentStudentOffline(Student? student) async{
  //TODO
}
