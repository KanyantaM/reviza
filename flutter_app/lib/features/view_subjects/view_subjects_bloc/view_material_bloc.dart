import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:study_material_repository/study_material_repository.dart';

part 'view_material_events.dart';
part 'view_material_state.dart';

class ViewMaterialBloc extends Bloc<ViewMaterialEvent, ViewMaterialState> {
  ViewMaterialBloc({required StudyMaterialRepo studyMaterial})
      : _materialRepository = studyMaterial,
        super(ViewMaterialInitial()) {
    on<FetchCourseMaterials>((event, emit) async {
      Map<String, List<StudyMaterial>> map = {};
      emit(FetchingMaterialsState());
      emit(LoadingState());
      try {
        if (event.online) {
          map = await _materialRepository.fetchDownloads();
        } else {
          map = await _materialRepository.fetchDownloads();
        }
        emit(MaterialsFetchedState(courseToMaterialsMap: map));
      } catch (e) {
        emit(ErrorState(message: 'Failed to fetch study material\n $e'));
      }
    });

    on<DownLoadMaterial>((event, emit) async {
      try {
        await for (final progressMap
            in _materialRepository.downloadMaterial(event.course)) {
          final entry = progressMap.entries.first;
          final progress = entry.value;

          emit(DownloadingCourses(progress: progress));

          if (progress == 1.0) {
            emit(MaterialDownloadedSuccesfully());
          }
        }
      } catch (e) {
        emit(ErrorState(message: 'Failed to download material\n $e'));
      }
    });

    on<VoteMaterial>(
      (event, emit) async {
        try {
          await _materialRepository.upvoteMaterial(
              vote: event.vote, studyMaterial: event.material);
        } on Exception catch (e) {
          emit(ErrorState(message: 'Voting failed\n ERROR: $e'));
        }
      },
    );

    on<ReportMaterial>(
      (event, emit) async {
        try {
          _materialRepository.reportMaterial(studyMaterial: event.material);
        } on Exception catch (e) {
          emit(ErrorState(message: 'Voting failed\n ERROR: $e'));
        }
      },
    );

    on<ReadStudyMaterial>(
      (event, emit) => emit(
        StudyMaterialOpened(
          studyMaterial: event.offline,
          originalStudyMaterial: event.online,
        ),
      ),
    );
  }

  final StudyMaterialRepo _materialRepository;
}

class DownloadProgressCubit extends Cubit<double> {
  DownloadProgressCubit() : super(0);

  void updateProgress(double value) {
    emit(value);
  }
}

DownloadProgressCubit downLoadProgressCubit = DownloadProgressCubit();
