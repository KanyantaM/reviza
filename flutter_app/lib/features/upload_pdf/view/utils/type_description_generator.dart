import 'package:study_material_repository/study_material_repository.dart';

Map<String, String> typeDescriptionGenerator({
  required Types type,
  required bool isRangeSelected,
  required int? startingYear,
  required int? endingYear,
  required String? category,
  required double? startingUnit,
  required double? endingUnit,
  required String authorName,
  required String? url,
}) {
  Map<String, String> typeAndDesc = {'type': '', 'desc': ''};

  switch (type) {
    case Types.papers:
      typeAndDesc['type'] = 'PAST_PAPERS';
      if (isRangeSelected) {
        typeAndDesc['data'] =
            'from $startingYear to $endingYear $category papers';
      } else {
        typeAndDesc['data'] = '$startingYear $category papers';
      }
      break;
    case Types.notes:
      typeAndDesc['type'] = 'NOTES';
      if (startingUnit != endingUnit) {
        typeAndDesc['data'] =
            'from $startingUnit to $endingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      } else {
        typeAndDesc['data'] =
            '$startingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      }
      break;
    case Types.links:
      typeAndDesc['type'] = 'LINKS';
      typeAndDesc['data'] = url!;
    case Types.lab:
      typeAndDesc['type'] = 'LAB';
      if (startingUnit != endingUnit) {
        typeAndDesc['data'] =
            'from $startingUnit to $endingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      } else {
        typeAndDesc['data'] =
            '$startingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      }
      break;
    case Types.books:
      typeAndDesc['type'] = 'BOOKS';
      if (startingUnit != endingUnit) {
        typeAndDesc['data'] =
            'from $startingUnit to $endingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      } else {
        typeAndDesc['data'] =
            '$startingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      }
      break;
    case Types.assignment:
      typeAndDesc['type'] = 'ASSIGNMENT';
      if (startingUnit != endingUnit) {
        typeAndDesc['data'] =
            'from $startingUnit to $endingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      } else {
        typeAndDesc['data'] =
            '$startingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      }
      break;
  }

  return typeAndDesc;
}
