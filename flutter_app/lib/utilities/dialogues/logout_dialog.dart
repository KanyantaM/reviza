import 'package:flutter/cupertino.dart';
import 'package:reviza/utilities/dialogues/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'logout button',
    content: 'logout_dialog',
    optionBuilder: () => {
      'cancel': false,
      'logout ': true,
    },
  ).then((value) => value ?? false);
}
