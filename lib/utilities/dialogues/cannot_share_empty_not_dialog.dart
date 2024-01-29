import 'package:flutter/material.dart';
import 'package:reviza/utilities/dialogues/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'sharing',
    content: 'cannot share empty note',
    optionBuilder: () => {
      'ok': null,
    },
  );
}
