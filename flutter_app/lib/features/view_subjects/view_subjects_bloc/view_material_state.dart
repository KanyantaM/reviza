part of 'view_material_bloc.dart';

sealed class ViewMaterialState {
  const ViewMaterialState();
}

final class ViewMaterialInitial extends ViewMaterialState {}

final class FetchingMaterialsState extends ViewMaterialState {}

final class MaterialsFetchedState extends ViewMaterialState {
  final Map<String, List<StudyMaterial>> courseToMaterialsMap;
  final String? courseFilter;
  final String? typeFilter;
  final List<StudyMaterial> filteredMaterials;

  const MaterialsFetchedState(
      {this.courseFilter,
      this.typeFilter,
      this.filteredMaterials = const <StudyMaterial>[],
      required this.courseToMaterialsMap});
}

final class MaterialDownloadedSuccesfully extends ViewMaterialState {}

final class DownloadingCourses extends ViewMaterialState {}

final class StudyMaterialOpened extends ViewMaterialState {
  final StudyMaterial studyMaterial;
  final StudyMaterial originalStudyMaterial;

  const StudyMaterialOpened({
    required this.originalStudyMaterial,
    required this.studyMaterial,
  });
}

final class DownloadedCourse extends ViewMaterialState {}

final class LoadingState extends ViewMaterialState {}

final class ErrorState extends ViewMaterialState {
  final String message;

  const ErrorState({required this.message});
}

final class MaterialBanedState extends ViewMaterialState {}
