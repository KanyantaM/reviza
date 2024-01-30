import 'package:bloc/bloc.dart';
import 'package:cloud_storage_study_material_api/cloud_storage_study_material_api.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:local_storage_study_material_api/local_storage_study_material_api.dart';
import 'package:local_student_api/local_student_api.dart';
import 'package:reviza/misc/course_info.dart';
import 'package:study_material_api/study_material_api.dart';
import 'package:path_provider/path_provider.dart';

part 'view_material_events.dart';
part 'view_material_state.dart';

class ViewMaterialBloc extends Bloc<ViewMaterialEvent, ViewMaterialState> {
  ViewMaterialBloc(
      {required FirestoreStudyMaterialRepository onlineMaterial,
      required HiveStudyMaterialRepository offlineMaterial})
      : _materialOnlineDataRepository = onlineMaterial,
        _hiveStudyMaterialRepository = offlineMaterial,
        super(ViewMaterialInitial()) {
    on<FetchCourseMaterials>((event, emit) async {
      List<StudyMaterial> materials = [];
      Map<String, List<StudyMaterial>> map = {};
      emit(FetchingMaterialsState());
      emit(LoadingState());
      try {
        if (event.online) {
          map = await _materialOnlineDataRepository
              .getStudyMaterials([event.course]);
        } else {
          List<String> myCourses = [];
          await HiveUserRepository()
              .getUserById(event.uid)
              .then((value) => myCourses = value?.myCourses ?? []);
          map = await _hiveStudyMaterialRepository.getStudyMaterials(myCourses);
        }
        materials = map[event.course] ?? [];
        emit(MaterialsFetchedState(studyMaterials: materials));
      } catch (e) {
        emit(ErrorState(message: 'Failed to fetch user messages\n $e'));
      }
    });

    on<DownLoadMaterial>((event, emit) async {
      //TODO: prevent downloading the same material
      try {
        Future<String> getFilePath(String filename, String subjectName) async {
          final dir = await getApplicationDocumentsDirectory();
          return "${dir.path}/$subjectName/$filename";
        }

        Dio dio = Dio();
        double progress = 0.0;

        String url = event.course.filePath!;
        String fileName = event.course.title;
        String subjectName = event.course.subjectName;
        String path = await getFilePath(fileName, subjectName);

        await dio.download(
          url,
          path,
          onReceiveProgress: (recivedBytes, totalBytes) {
            progress = recivedBytes / totalBytes;
            emit(DownloadingCourses(progress: progress));
          },
          deleteOnError: true,
        ).then((response) {
          StudyMaterial oldMaterial = event.course;
          oldMaterial.filePath = path;
          _hiveStudyMaterialRepository.addStudyMaterial(
            oldMaterial,
          );
          emit(DownloadedCourse());
        });
      } catch (e) {
        emit(ErrorState(message: 'Failed to download material\n $e'));
      }
    });

    on<VoteMaterial>(
      (event, emit) async {
        List<String> haters = event.material.haters;
        List<String> fans = event.material.fans;
        StudyMaterial updateStudyMaterial = event.material;
        if (event.vote == 1) {
          if (fans.contains(event.uid)) {
            updateStudyMaterial.haters.remove(event.uid);
          } else {
            updateStudyMaterial.fans.add(event.uid);
          }
        } else {
          if (haters.contains(event.uid)) {
            updateStudyMaterial.fans.remove(event.uid);
          } else {
            updateStudyMaterial.haters.add(event.uid);
          }
        }
        try {
          await _hiveStudyMaterialRepository
              .updateStudyMaterial(updateStudyMaterial);
          await _materialOnlineDataRepository
              .updateStudyMaterial(updateStudyMaterial);
        } on Exception catch (e) {
          emit(ErrorState(message: 'Voting failed\n ERROR: $e'));
        }
      },
    );

    on<ReportMaterial>(
      (event, emit) async {
        List<String> reports = event.material.reports;
        StudyMaterial updateStudyMaterial = event.material;
        if (!(reports.contains(event.uid))) {
          updateStudyMaterial.reports.add(event.uid);
        }
        try {
          await _hiveStudyMaterialRepository
              .updateStudyMaterial(updateStudyMaterial);
          await _materialOnlineDataRepository
              .updateStudyMaterial(updateStudyMaterial);
        } on Exception catch (e) {
          emit(ErrorState(message: 'Voting failed\n ERROR: $e'));
        }
      },
    );

    on<ReadStudyMaterial>(
      (event, emit) => emit(
        StudyMaterialOpened(
          studyMaterial: event.studyMaterial,
          uid: event.uid,
        ),
      ),
    );
  }

  final HiveStudyMaterialRepository _hiveStudyMaterialRepository;
  final FirestoreStudyMaterialRepository _materialOnlineDataRepository;
}
