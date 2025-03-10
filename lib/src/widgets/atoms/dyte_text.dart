import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:flutter/material.dart';

/// Wrapper over text widget, it uses the defualt UI kit styles.
class DyteText extends StatelessWidget {
  const DyteText(
    this.data, {
    this.dyteTextStyle,
    super.key,
    this.textAlign,
    this.overflow,

    /// [disableOverflow] by default false,
    /// if set to true let's `Text` take any number of lines.
    this.disableOverflow = false,
  });

  final String data;
  final TextAlign? textAlign;
  final TextStyle? dyteTextStyle;
  final bool disableOverflow;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;

    return Text(
      data,
      style: dyteTextStyle ?? theme.textTheme.bodyMedium,
      textAlign: textAlign,
      overflow: disableOverflow ? null : overflow ?? TextOverflow.ellipsis,
    );
  }
}
