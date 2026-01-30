import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/constants/sizes.dart';

class AppTextField extends StatefulWidget {
  final String labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;

  const AppTextField({
    super.key,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false, // If true, we treat it as a password field with toggle
    this.controller,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(_obscureText ? Iconsax.eye_slash : Iconsax.eye),
              )
            : widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        ),
      ),
    );
  }
}
