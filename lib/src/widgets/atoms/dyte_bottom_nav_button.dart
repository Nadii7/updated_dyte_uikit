import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/tokens/color/status_color.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';

import 'dyte_text.dart';

class DyteBottomNavButton extends StatelessWidget {
  final Icon icon;
  final String? label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final bool disabled;
  final TextStyle? disabledLabelStyle;
  final TextStyle? labelStyle;
  final Color? iconColor;
  final Color? disabledIconColor;
  final Widget? warningIcon;
  final Widget? child;
  final bool showLabel;

  const DyteBottomNavButton({
    Key? key,
    required this.icon,
    this.label,
    required this.onTap,
    this.backgroundColor,
    this.disabled = false,
    this.warningIcon,
    this.iconColor,
    this.labelStyle,
    this.disabledLabelStyle,
    this.disabledIconColor,
    this.showLabel = true,
    this.child,
  })  : assert((showLabel && label != null) || (!showLabel && label == null),
            "If showLabel is false, label has to be null and vice versa"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return GestureDetector(
      onTap: disabled ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          SizedBox(
            child: showLabel && label != null
                ? Container(
                    constraints: const BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                      maxHeight: 32,
                      maxWidth: 32,
                    ),
                    padding: const EdgeInsets.all(0),
                    child: Icon(
                      icon.icon,
                      color: disabled
                          ? disabledIconColor ?? textColorSwatch.shade700
                          : iconColor ?? textColorSwatch.shade1000,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                          maxHeight: 32,
                          maxWidth: 32,
                        ),
                        padding: const EdgeInsets.all(0),
                        child: Icon(
                          icon.icon,
                          color: disabled
                              ? disabledIconColor ?? textColorSwatch.shade700
                              : iconColor ?? textColorSwatch.shade1000,
                        ),
                      ),
                      if (showLabel && label != null) ...[
                        vspace1,
                        DyteText(
                          label!,
                          dyteTextStyle: disabled
                              ? disabledLabelStyle ??
                                  theme.textTheme.bodyMedium!
                                      .copyWith(color: textColorSwatch.shade700)
                              : labelStyle ?? theme.textTheme.bodyMedium,
                        )
                      ]
                    ],
                  ),
          ),
          if (disabled)
            const Positioned(
              right: 0,
              top: 4,
              child: Icon(
                DyteIcons.warning,
                color: StatusColor.warning,
                size: 14,
              ),
            ),
        ],
      ),
    );
  }
}
