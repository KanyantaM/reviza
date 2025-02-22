import 'package:study_material_repository/study_material_repository.dart';

String descriptionGenerator({
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
  switch (type) {
    case Types.papers:
      if (isRangeSelected) {
        return 'from $startingYear to $endingYear $category papers';
      } else {
        return '$startingYear $category papers';
      }

    case Types.notes:
      if (startingUnit != endingUnit) {
        return 'from $startingUnit to $endingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      } else {
        return '$startingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      }

    case Types.links:
      return url!;
    case Types.lab:
      if (startingUnit != endingUnit) {
        return 'from $startingUnit to $endingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      } else {
        return '$startingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      }

    case Types.books:
      if (startingUnit != endingUnit) {
        return 'from $startingUnit to $endingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      } else {
        return '$startingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      }

    case Types.assignment:
      if (startingUnit != endingUnit) {
        return 'from $startingUnit to $endingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      } else {
        return '$startingUnit ${(authorName.isNotEmpty) ? 'by $authorName' : ''}';
      }
  }
}
