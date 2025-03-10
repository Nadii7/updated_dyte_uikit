import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:flutter/material.dart';

import 'package:dyte_core/dyte_core.dart';

class DyteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  const DyteButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height,
    this.width,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return MaterialButton(
      onPressed: onPressed,
      color: backgroundColor ?? theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderToken.getRadius(BorderSize.one),
        ),
      ),
      height: height,
      child: child,
    );
  }
}
