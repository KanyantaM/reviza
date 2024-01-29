import 'package:flutter/cupertino.dart';
import 'package:reviza/utilities/dialogues/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'delete',
    content: 'Delete note',
    optionBuilder: () => {
      'cancel': false,
      'yes': true,
    },
  ).then((value) => value ?? false);
}
