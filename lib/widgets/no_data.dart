import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoDataCuate extends StatelessWidget {
  const NoDataCuate({
    super.key,
    required this.issue,
  });
  final String issue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Image.asset(
            "assets/images/error404.png",
            height: 177.h,
          ),
        ),
        Text(
           issue,
           textScaleFactor: 2,
        ),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }
}
