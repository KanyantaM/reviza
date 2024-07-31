import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reviza/widgets/popup.dart';

commingSoon(BuildContext context) {
  showDialog(
    context: context,
    useSafeArea: true,
    builder: (context) {
      return Popup(
        title: 'coming soon',
        imagePath: 'assets/icon/warning.png',
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Okay, thank you',
              style: GoogleFonts.poppins(
                fontSize: (10),
              ),
            ),
          ),
        ],
      );
    },
  );
}
