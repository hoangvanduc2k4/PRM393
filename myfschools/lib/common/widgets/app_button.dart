import 'package:flutter/material.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = TColors.sunshade,
    this.textColor = Colors.white,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        child: Text(text),
      ),
    );
  }
}
