import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/core/dyte_uikit_component.dart';
import 'package:flutter/material.dart';

class DyteMeetingTitle extends StatelessWidget with UiKitElement {
  DyteMeetingTitle({
    super.key,
    required this.dyteMobileClient,
    DyteDesignTokens? individualDesignToken,
  }) : designToken = individualDesignToken ?? globalDesignToken;

  final DyteMobileClient dyteMobileClient;
  final DyteDesignTokens designToken;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Flexible(
      flex: 1,
      child: Text(
        dyteMobileClient.meta.meetingTitle,
        style: theme.textTheme.bodyMedium!.copyWith(color: textColor),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  double get borderRadius => 0.0;

  @override
  double get borderWidth => 0.0;

  @override
  Color get fillColor => designToken.colorToken.brandColor.shade500;

  @override
  Color get textColor => designToken.colorToken.textColor.shade1000;
}
