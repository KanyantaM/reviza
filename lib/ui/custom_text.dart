
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {this.title,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.fontStyle,
      this.textAlign,
      this.decoration,
      this.maxLines,
      this.lineHeight,
      this.fontFamily,
      super.key});
  final String? title;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final int? maxLines;
  final String? fontFamily;
  final double? lineHeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? "",
      textAlign: textAlign ?? TextAlign.left,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        decoration: decoration,
        fontStyle: fontStyle,
        fontFamily: fontFamily,
        height: lineHeight,
      ),
    );
  }
}
