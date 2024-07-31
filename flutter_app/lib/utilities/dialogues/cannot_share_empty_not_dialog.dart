import 'package:flutter/material.dart';
import 'package:reviza/utilities/dialogues/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Uploading Error',
    content: 'cannot share material without a course name',
    optionBuilder: () => {
      'ok': null,
    },
  );
}
