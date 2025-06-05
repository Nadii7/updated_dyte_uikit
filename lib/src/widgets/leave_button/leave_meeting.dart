import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/size/app_size.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:dyte_uikit/src/widgets/core/core.dart';
import 'package:dyte_uikit/src/widgets/core/dyte_uikit_component.dart';
import 'package:flutter/material.dart';

class DyteLeaveMeetingDialog extends StatelessWidget implements UiKitElement {
  final Function()? onClose;
  final DyteDesignTokens? designToken;
  final DyteMobileClient dyteMobileClient;

  const DyteLeaveMeetingDialog({
    super.key,
    required this.onClose,
    this.designToken,
    required this.dyteMobileClient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return AlertDialog(
      elevation: 0,
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.all(16),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: fillColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DyteStrings.leave,
              style: theme.textTheme.headlineLarge!.copyWith(
                fontSize: fontSize.s150,
                fontWeight: FontWeight.w600,
              ),
            ),
            vspace2,
            Text(
              DyteStrings.areYouSureYouWantToLeaveTheCall,
              style: theme.textTheme.bodySmall,
            ),
            vspaceHalf,
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: DyteButtons.solid(
                    label: DyteStrings.cancel,
                    height: AppSize.s10,
                    backgroundColor:
                        globalDesignToken.colorToken.backgroundColor.shade800,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ),
                hspace4,
                Expanded(
                  child: DyteButtons.solid(
                    label: DyteStrings.leave,
                    height: AppSize.s10,
                    backgroundColor: globalDesignToken.colorToken.danger,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      dyteMobileClient.leaveRoom();
                      if (onClose != null) onClose!();
                    },
                  ),
                ),
              ],
            ),
            if (dyteMobileClient.permissions.host.canKickParticipant) ...[
              vspaceHalf,
              DyteButtons.solid(
                label: DyteStrings.endMeetingForAll,
                height: AppSize.s10,
                backgroundColor: globalDesignToken.colorToken.danger,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  dyteMobileClient.hostActions.kickAll();
                },
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  double get borderRadius =>
      designToken?.borderToken.getRadius(BorderSize.zero) ??
      globalDesignToken.borderToken.getRadius(BorderSize.zero);

  @override
  double get borderWidth => 0.0;

  @override
  Color get fillColor =>
      designToken?.colorToken.backgroundColor.shade1000 ??
      globalDesignToken.colorToken.backgroundColor.shade1000;

  @override
  Color get textColor =>
      designToken?.colorToken.textColor.shade1000 ??
      globalDesignToken.colorToken.textColor.shade1000;
}
