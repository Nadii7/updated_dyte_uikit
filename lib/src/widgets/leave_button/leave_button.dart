import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_uikit/src/tokens/size/app_size.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/widgets/core/core.dart';
import 'package:dyte_uikit/src/widgets/core/dyte_uikit_component.dart';
import 'package:dyte_uikit/src/widgets/leave_button/leave_meeting.dart';
import 'package:flutter/material.dart';

class DyteLeaveButton extends StatefulWidget with UiKitElement {
  DyteLeaveButton({
    required this.dyteMobileClient,
    final DyteDesignTokens? individualDesignToken,
    super.key,
    this.height,
    this.width,
  }) : designToken = individualDesignToken ?? globalDesignToken;

  final DyteDesignTokens designToken;
  final DyteMobileClient dyteMobileClient;
  final double? height;
  final double? width;

  @override
  State<DyteLeaveButton> createState() => _DyteLeaveButtonState();

  @override
  double get borderRadius => designToken.borderToken.getRadius(BorderSize.one);

  @override
  double get borderWidth => 0.0;

  @override
  Color get fillColor => designToken.colorToken.danger;

  @override
  Color get textColor => designToken.colorToken.textColor.shade1000;
}

class _DyteLeaveButtonState extends State<DyteLeaveButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.adjust(AppSize.s12),
      width: context.adjust(AppSize.s12),
      decoration: BoxDecoration(
        color: widget.fillColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: DyteButtons.icon(
        const Icon(DyteIcons.call_end),
        onPressed: () {
          showDialog(
            builder: (context) {
              return DyteLeaveMeetingDialog(
                  dyteMobileClient: widget.dyteMobileClient);
            },
            context: context,
          );
        },
      ),
    );
  }
}
