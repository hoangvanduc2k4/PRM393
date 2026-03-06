import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    required this.title,
    this.showBackArrow = true,
    this.onLeadingPressed,
    this.actions,
  });

  final String title;
  final bool showBackArrow;
  final Function()? onLeadingPressed;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: TColors.primary,
      automaticallyImplyLeading: false,
      leading: showBackArrow
          ? IconButton(
              onPressed: onLeadingPressed ?? () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
