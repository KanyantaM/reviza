import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UploadBox extends StatelessWidget {
  final Function() onTap;
  const UploadBox({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(10),
          dashPattern: const [10, 4],
          strokeCap: StrokeCap.round,
          color: Colors.blue.shade400,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
                // color: Colors.blue.shade50.withOpacity(.3),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.folder,
                  // color: Colors.blue,
                  size: 40,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Select your file',
                  style: TextStyle(
                    fontSize: 15,
                    // color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
