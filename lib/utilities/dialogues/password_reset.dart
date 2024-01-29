import 'package:flutter/material.dart';
import 'package:reviza/utilities/dialogues/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'password reset',
    content: 'password_reset_dialog_prompt',
    optionBuilder: () => {
      'ok': null,
    },
  );
}
