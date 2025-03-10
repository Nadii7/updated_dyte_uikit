import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_uikit/src/tokens/size/app_size.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:dyte_uikit/src/widgets/core/button/dyte_button_controller.dart';
import 'package:dyte_uikit/src/widgets/core/dyte_uikit_component.dart';
import 'package:flutter/material.dart';

part 'dyte_buttons.dart';

/// [IconPosition] is used to position the icon in the button.
/// [left] is used to position the icon to the left of the button.
/// [right] is used to position the icon to the right of the button.
enum IconPosition { left, right }

class DyteButtons {
  /// Returns a [DyteButton] with a solid background color.
  /// [label] is the text to be displayed on the button.
  /// [onPressed] is the callback to be called when the button is pressed.
  /// [designToken] is the individual design token for the button, it has the
  /// same properties as [DyteDesignTokens] but it is optional.

  DyteButtons._();

  static DyteButton solid({
    required String label,
    required VoidCallback? onPressed,
    DyteDesignTokens? designToken,
    DyteButtonController? controller,
    Color? backgroundColor,
    double? width,
    double? height,
  }) =>
      _DyteSolidButton(
        label: label,
        onPressed: onPressed,
        individualDesignToken: designToken,
        height: height,
        width: width,
        backgroundColor: backgroundColor,
        controller: controller ?? DyteButtonController(),
      );

  //TODO: add an expanded button.

  /// Returns a [DyteButton] with a solid background color.
  /// [label] is the text to be displayed on the button.
  /// [onPressed] is the callback to be called when the button is pressed.
  /// [designToken] is the individual design token for the button, it has the
  /// same properties as [DyteDesignTokens] but it is optional.
  /// [icon] is the icon to be displayed on the button.
  /// [iconPostion] is the position of the icon on the button.
  /// [width] is the width of the button.
  /// [height] is the height of the button.
  static DyteButton iconWithLabel({
    required String label,
    required VoidCallback? onPressed,
    required Icon icon,
    IconPosition? iconPostion,
    DyteDesignTokens? designToken,
    DyteButtonController? controller,
    double? width,
    double? height,
  }) =>
      _DyteSolidIconButtonWithLabel(
        height: height,
        iconPosition: iconPostion ?? IconPosition.left,
        individualDesignToken: designToken,
        onPressed: onPressed,
        label: label,
        icon: icon,
        controller: controller ?? DyteButtonController(),
      );

  /// Returns a [DyteButton] with only an icon.
  /// [icon] is the icon to be displayed on the button.
  /// [onPressed] is the callback to be called when the button is pressed.
  /// [designToken] is the individual design token for the button, it has the
  /// same properties as [DyteDesignTokens] but it is optional.

  static DyteButton icon(
    Icon icon, {
    required VoidCallback? onPressed,
    DyteDesignTokens? designToken,
    double? iconSize,
    DyteButtonController? controller,
    bool isDisabled = false,
  }) =>
      _DyteIconButton(
        iconSize: iconSize,
        individualDesignToken: designToken,
        onPressed: onPressed,
        icon: icon,
        controller: controller ?? DyteButtonController(),
        isDisabled: isDisabled,
        label: '',
      );
}
