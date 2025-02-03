import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({
    super.key,
    required this.errorText,
    required this.headingText,
    required this.color,
    required this.image,
  });

  final String errorText, headingText;
  final Color? color;
  final Image? image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          height: 90,
          child: Row(
            children: [
              const SizedBox(
                width: 48,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headingText,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      errorText,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
            ),
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/icon/test.svg',
                  height: 48,
                  width: 40,
                  // ignore: deprecated_member_use
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -20,
          left: 12,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image(
                image: image!.image,
                height: 35,
                width: 35,
              ),
              Positioned(
                top: 10,
                child: SvgPicture.asset(
                  'assets/icon/vhat.svg',
                  height: 16,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
