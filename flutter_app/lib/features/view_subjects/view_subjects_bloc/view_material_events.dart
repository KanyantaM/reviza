part of 'view_material_bloc.dart';

sealed class ViewMaterialEvent extends Equatable {
  const ViewMaterialEvent();

  @override
  List<Object> get props => [];
}

class FetchCourseMaterials extends ViewMaterialEvent {
  final String? course;
  final bool online;
  final String? type;

  const FetchCourseMaterials({
    this.type,
    required this.course,
    required this.online,
  });
}

class DownLoadMaterial extends ViewMaterialEvent {
  final StudyMaterial course;
  const DownLoadMaterial({required this.course});
}

class VoteMaterial extends ViewMaterialEvent {
  final StudyMaterial material;
  final bool? vote;

  const VoteMaterial({required this.material, required this.vote});
}

class ReportMaterial extends ViewMaterialEvent {
  final StudyMaterial material;

  const ReportMaterial({
    required this.material,
  });
}

class DownLoadAndView extends ViewMaterialEvent {
  final String studyMaterialId;

  const DownLoadAndView({required this.studyMaterialId});
}

class ReadStudyMaterial extends ViewMaterialEvent {
  final StudyMaterial offline;
  final StudyMaterial online;

  const ReadStudyMaterial({
    required this.offline,
    required this.online,
  });
}
