import 'package:flutter/material.dart';
import 'package:reviza/utilities/dialogues/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'Error',
    content: text,
    optionBuilder: () => {
      'ok': null,
    },
  );
}
