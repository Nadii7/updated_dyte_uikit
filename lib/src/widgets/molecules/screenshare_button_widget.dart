import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/data/notifiers/screenshare_notifier.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dyte_uikit.dart';
import '../../di/di.dart';
import '../atoms/dyte_bottom_nav_button.dart';
import '../core/button/dyte_elevated_button.dart';
import '../core/dyte_uikit_component.dart';

class DyteScreenshareWidget extends ConsumerStatefulWidget
    with UsesStatusColor {
  final DyteDesignTokens designTokens;
  final bool showLabel;
  final double? iconSize;
  final Color? iconColor;
  final DyteMobileClient dyteMobileClient;

  DyteScreenshareWidget({
    required this.dyteMobileClient,
    super.key,
    this.showLabel = false,
    this.iconColor,
    this.iconSize,
    DyteDesignTokens? individualDesignToken,
  }) : designTokens = individualDesignToken ?? globalDesignToken;

  @override
  Color get errorColor => designTokens.colorToken.danger;

  @override
  Color get successColor => designTokens.colorToken.success;

  @override
  Color get warningColor => designTokens.colorToken.warning;

  @override
  ConsumerState<DyteScreenshareWidget> createState() =>
      _DyteScreenshareWidgetState();
}

class _DyteScreenshareWidgetState extends ConsumerState<DyteScreenshareWidget> {
  final screenshareLimitNotifier = ScreenshareLimitNotifier();
  @override
  void initState() {
    dyteMobileClient.addDataEventsListener(screenshareLimitNotifier);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    dyteMobileClient.removeDataEventsListener(screenshareLimitNotifier);
  }

  @override
  Widget build(BuildContext context) {
    final selfScreensharePresent = ref.watch(selfScreenshareProvider);
    if (dyteMobileClient.permissions.media.screenshare ==
            DyteMediaPermission.allowed ||
        (dyteMobileClient.permissions.media.screenshare ==
                DyteMediaPermission.canRequest &&
            dyteMobileClient.stage.status == DyteStageStatus.onStage)) {
      return ValueListenableBuilder(
          valueListenable: screenshareLimitNotifier,
          builder: (context, isLimitReached, child) {
            final disabled = isLimitReached && !selfScreensharePresent;
            return widget.showLabel
                ? Center(
                    child: DyteBottomNavButton(
                      disabled: disabled,
                      icon: selfScreensharePresent
                          ? Icon(DyteIcons.share_screen_stop,
                              color: widget.iconColor ?? widget.errorColor)
                          : const Icon(
                              DyteIcons.share_screen_start,
                            ),
                      label: selfScreensharePresent
                          ? DyteStrings.stopSharing
                          : DyteStrings.screenShare,
                      onTap: () {
                        selfScreensharePresent
                            ? dyteMobileClient.localUser.disableScreenshare()
                            : dyteMobileClient.localUser.enableScreenshare();
                      },
                    ),
                  )
                : Center(
                    child: DyteButtons.icon(
                      selfScreensharePresent
                          ? Icon(DyteIcons.share_screen_stop,
                              color: widget.iconColor ?? widget.errorColor)
                          : const Icon(
                              DyteIcons.share_screen_start,
                            ),
                      designToken: widget.designTokens,
                      iconSize: widget.iconSize,
                      isDisabled: disabled,
                      onPressed: () {
                        selfScreensharePresent
                            ? dyteMobileClient.localUser.disableScreenshare()
                            : dyteMobileClient.localUser.enableScreenshare();
                      },
                    ),
                  );
          });
    } else {
      return const SizedBox.shrink();
    }
  }
}
