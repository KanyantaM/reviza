import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GenericLoading extends StatelessWidget {
  const GenericLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/lottie/loading.json');
  }
}