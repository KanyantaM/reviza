import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({
    super.key,
    required this.errorText,
    required this.headingText,
    required this.color,
    required this.type,
  });

  final String errorText, headingText;
  final Color? color;

  final SnackBarType type;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color?.withAlpha(50),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 48,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(headingText,
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(errorText,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -20,
          left: 12,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/icon/${type.name}.png',
                height: 35,
                width: 35,
              ),
            ],
          ),
        )
      ],
    );
  }
}

enum SnackBarType { warning, success, error }
