import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_uikit/src/tokens/color/status_color.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:flutter/material.dart';

class DyteTextButton extends StatelessWidget {
  const DyteTextButton({
    super.key,
    required this.onPressed,
    this.label = "Button",
    this.variant = Variant.primary,
    this.labelStyle,
    this.height = 40,
    this.width = 80,
    this.borderColor,
  });
  final VoidCallback? onPressed;
  final Variant variant;
  final double width;
  final double height;
  final String label;
  final TextStyle? labelStyle;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return _buildBaseButton(variant, context);
  }

  Widget _buildBaseButton(Variant variant, BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderToken.getRadius(BorderSize.one),
          ),
          side: BorderSide(color: borderColor ?? Colors.transparent)),
      height: height,
      minWidth: width,
      // INFO: If color and Variant both are passed, then Color will override the Variant
      color: _mapVariantToColor(variant),
      onPressed: onPressed,
      child: DyteText(
        label,
        dyteTextStyle: labelStyle ??
            AppTheme(globalDesignToken.colorToken)
                .theme
                .textTheme
                .displayMedium,
      ),
    );
  }

  Color _mapVariantToColor(Variant variant) {
    switch (variant) {
      case Variant.danger:
        return StatusColor.error;
      case Variant.ghost:
        return Colors.transparent;
      case Variant.primary:
        return brandColorSwatch.shade500;
      case Variant.secondary:
        // TODO: check for original color.
        return backgroundColorSwatch.shade900;
      default:
        return brandColorSwatch.shade500;
    }
  }
}

enum Variant {
  danger,
  ghost,
  primary,
  secondary,
}
