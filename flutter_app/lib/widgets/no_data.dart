import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
        LottieBuilder.asset(
          "assets/lottie/indian_searching.json",
          height: 177,
        ),
        Padding(
          padding: const EdgeInsets.all(11.0),
          child: Text(
            issue,
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
