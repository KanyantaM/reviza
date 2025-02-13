import 'package:flutter/material.dart';
import 'package:study_material_repository/study_material_repository.dart';

Widget widgetSelector(Types type,
    {required Widget pp,
    required Widget notes,
    required Widget ass,
    required Widget book,
    required Widget lab,
    required Widget link}) {
  return type == Types.papers
      ? pp
      : type == Types.notes
          ? notes
          : type == Types.assignment
              ? ass
              : type == Types.books
                  ? book
                  : type == Types.lab
                      ? lab
                      : type == Types.links
                          ? link
                          : const Wrap();
}
