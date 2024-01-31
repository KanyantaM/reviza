part of 'view_material_bloc.dart';

sealed class ViewMaterialState extends Equatable {
  const ViewMaterialState();

  @override
  List<Object> get props => [];
}

final class ViewMaterialInitial extends ViewMaterialState {}

final class FetchingMaterialsState extends ViewMaterialState {}

final class MaterialsFetchedState extends ViewMaterialState {
  ///This should all the materials that can be fetched if they are form the device else it is the list per subject if it is coming from an online source
  final List<StudyMaterial> studyMaterials;
  final List<String> courses;

  List<StudyMaterial> filterByType(String? course, Types? type) {
    List<StudyMaterial> filteredResults = [];
    if (course?.isNotEmpty ?? false) {
      for (var material in studyMaterials) {
        if (material.subjectName == course) {
          if (type != null) {
            switch (type) {
              case Types.papers:
                if (material.type == 'PAST_PAPERS') {
                  filteredResults.add(material);
                }
                break;
              case Types.notes:
                if (material.type == 'NOTES') {
                  filteredResults.add(material);
                }
                break;
              case Types.links:
                if (material.type == 'LINKS') {
                  filteredResults.add(material);
                }
                break;
              case Types.lab:
                if (material.type == 'LAB') {
                  filteredResults.add(material);
                }
                break;
              case Types.books:
                if (material.type == 'BOOKS') {
                  filteredResults.add(material);
                }
                break;
              case Types.assignment:
                if (material.type == 'ASSIGNMENT') {
                  filteredResults.add(material);
                }
                break;
              default:
                return [];
            }
          } else {
            filteredResults.add(material);
          }
        }
      }
      return filteredResults;
    } else {
      return studyMaterials;
    }
  }

  const MaterialsFetchedState({required this.courses, required this.studyMaterials});
}

final class MaterialDownloadedSuccesfully extends ViewMaterialState {}

final class DownloadingCourses extends ViewMaterialState {
  final double progress;

  const DownloadingCourses({required this.progress});
}

final class StudyMaterialOpened extends ViewMaterialState {
  final StudyMaterial studyMaterial;
  final String uid;

  const StudyMaterialOpened({required this.studyMaterial, required this.uid});
}

final class DownloadedCourse extends ViewMaterialState {}

final class LoadingState extends ViewMaterialState {}

final class ErrorState extends ViewMaterialState {
  final String message;

  const ErrorState({required this.message});
}
