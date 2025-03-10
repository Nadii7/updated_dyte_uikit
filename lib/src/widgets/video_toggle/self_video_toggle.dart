import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/models/media_toggle_state.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_bottom_nav_button.dart';
import 'package:dyte_uikit/src/widgets/core/core.dart';
import 'package:dyte_uikit/src/widgets/core/dyte_uikit_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DyteSelfVideoToggleButton extends ConsumerStatefulWidget
    with UsesStatusColor {
  DyteSelfVideoToggleButton({
    required this.dyteMobileClient,
    DyteDesignTokens? individualDesignToken,
    this.onVideoToggle,
    this.iconSize,
    this.iconColor,
    this.showLabel = false,
    super.key,
  }) : designTokens = individualDesignToken ?? globalDesignToken;

  final VoidCallback? onVideoToggle;
  final DyteDesignTokens designTokens;
  final DyteMobileClient dyteMobileClient;
  final double? iconSize;
  final Color? iconColor;
  final bool showLabel;

  @override
  ConsumerState<DyteSelfVideoToggleButton> createState() =>
      _DyteSelfVideoToggleButtonState();

  @override
  Color get errorColor => designTokens.colorToken.danger;

  @override
  Color get successColor => designTokens.colorToken.success;

  @override
  Color get warningColor => designTokens.colorToken.warning;
}

class _DyteSelfVideoToggleButtonState
    extends ConsumerState<DyteSelfVideoToggleButton> {
  SelfVideoNotifier? _selfVideoNotifier;
  @override
  void initState() {
    _selfVideoNotifier = SelfVideoNotifier(widget.dyteMobileClient);
    widget.dyteMobileClient.addSelfEventsListener(_selfVideoNotifier!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selfVideoNotifier!,
      builder: (context, value, child) => _buildToggleButton(value),
    );
  }

  void _onVideoToggle() {
    _selfVideoNotifier!.startVideoToggle();
    if (_selfVideoNotifier!.value == MediaToggleState.on) {
      widget.dyteMobileClient.localUser.disableVideo();
    } else {
      widget.dyteMobileClient.localUser.enableVideo();
    }
  }

  Widget _buildToggleButton(MediaToggleState videoToggleState) {
    if (videoToggleState == MediaToggleState.inProgress) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: widget.designTokens.colorToken.textColor.shade600,
        ),
      );
    }
    final value = videoToggleState == MediaToggleState.on;
    final isCameraGranted =
        widget.dyteMobileClient.localUser.permissions.isCameraPermissionGranted;

    final isCameraAllowed =
        widget.dyteMobileClient.permissions.media.video.permission ==
                DyteMediaPermission.allowed ||
            (widget.dyteMobileClient.permissions.media.video.permission ==
                    DyteMediaPermission.canRequest &&
                ref.watch(stageStatusNotifier) == DyteStageStatus.onStage);

    /// If user is allowed to use camera as per preset permissions
    if (isCameraAllowed) {
      /// If user wants to show label (as used in bottom nav bar button)
      if (widget.showLabel) {
        return Center(
          child: DyteBottomNavButton(
            icon: value
                ? const Icon(DyteIcons.video_on)
                : Icon(
                    DyteIcons.video_off,
                    color: widget.iconColor ?? widget.errorColor,
                  ),
            label: value ? DyteStrings.videoOn : DyteStrings.videoOff,
            disabled: !isCameraGranted,
            onTap: () {
              _onVideoToggle();
              widget.onVideoToggle?.call();
            },
          ),
        );
      } else {
        return Center(
          child: DyteButtons.icon(
            value
                ? const Icon(DyteIcons.video_on)
                : Icon(
                    DyteIcons.video_off,
                    color: widget.errorColor,
                  ),
            designToken: widget.designTokens,
            iconSize: widget.iconSize,
            isDisabled: !isCameraGranted,
            onPressed: () {
              _onVideoToggle();
              widget.onVideoToggle?.call();
            },
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    widget.dyteMobileClient.removeSelfEventsListener(_selfVideoNotifier!);
    _selfVideoNotifier!.dispose();
    _selfVideoNotifier = null;
    super.dispose();
  }
}

class SelfVideoNotifier extends ValueNotifier<MediaToggleState>
    implements DyteSelfEventsListener {
  final DyteMobileClient dyteMobileClient;
  SelfVideoNotifier(this.dyteMobileClient)
      : super(dyteMobileClient.localUser.videoEnabled
            ? MediaToggleState.on
            : MediaToggleState.off);

  void startVideoToggle() {
    // fix: No idea how it worked!
    Future.microtask(() => value = MediaToggleState.inProgress);
  }

  @override
  void onVideoUpdate(bool videoEnabled) {
    value = videoEnabled ? MediaToggleState.on : MediaToggleState.off;
  }

  @override
  void onAudioUpdate(bool audioEnabled) {}

  @override
  void onAudioDevicesUpdated() {}

  @override
  void onMeetingRoomJoinedWithoutCameraPermission() {}

  @override
  void onMeetingRoomJoinedWithoutMicPermission() {}

  @override
  void onProximityChanged(bool isNear) {}

  @override
  void onRemovedFromMeeting() {}

  @override
  void onUpdate(DyteSelfUser participant) {}

  @override
  void onWaitListStatusUpdate(DyteWaitListStatus waitListStatus) {}

  @override
  void onRoomMessage(String type, Map<String, dynamic> payload) {}

  @override
  void onStageStatusUpdated(DyteStageStatus stageStatus) {}

  @override
  void onVideoDeviceChanged(DyteVideoDevice videoDevice) {}

  @override
  void onScreenShareStartFailed(String reason) {}

  @override
  void onScreenShareStarted() {}

  @override
  void onScreenShareStopped() {}

  @override
  void onPermissionsUpdated(DytePermissions permissions) {}
}
