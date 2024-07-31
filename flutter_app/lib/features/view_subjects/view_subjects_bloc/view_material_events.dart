part of 'view_material_bloc.dart';

sealed class ViewMaterialEvent extends Equatable {
  const ViewMaterialEvent();

  @override
  List<Object> get props => [];
}

class FetchCourseMaterials extends ViewMaterialEvent {
  final String? course;
  final bool online;
  final String uid;

  const FetchCourseMaterials({required this.course, required this.online, required this.uid});
}

class DownLoadMaterial extends ViewMaterialEvent{
  final StudyMaterial course;
  final String uid;
  const DownLoadMaterial({required this.uid, required this.course});
}

class VoteMaterial extends ViewMaterialEvent{
  final StudyMaterial material;
  final String uid;
  final bool? vote;

  const VoteMaterial({required this.material, required this.uid, required this.vote});
}

class ReportMaterial extends ViewMaterialEvent{
  final StudyMaterial material;
  final String uid;

  const ReportMaterial({required this.material, required this.uid});
}

class DownLoadAndView extends ViewMaterialEvent{
  final String studyMaterialId;

  const DownLoadAndView({required this.studyMaterialId});
}

class ReadStudyMaterial extends ViewMaterialEvent{
  final StudyMaterial offline;
  final StudyMaterial online;
  final String uid;

  const ReadStudyMaterial({required this.offline, required this.online, required this.uid});
}