import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class TShadowStyle {
  static final verticalProductShadow = BoxShadow(
    color: TColors.darkGrey.withValues(alpha: 0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );
  static final horizontalProductShadow = BoxShadow(
    color: TColors.darkGrey.withValues(alpha: 0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );

  static final primaryShadow = BoxShadow(
    color: TColors.primary.withOpacity(0.3),
    blurRadius: 10,
    offset: const Offset(0, 5),
  );

  static final softShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.1),
    blurRadius: 10,
    spreadRadius: 1,
  );
}
