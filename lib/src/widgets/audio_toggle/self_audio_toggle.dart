import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/models/media_toggle_state.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/widgets/core/core.dart';
import 'package:dyte_uikit/src/widgets/core/dyte_uikit_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/riverpod_di.dart';
import '../atoms/dyte_bottom_nav_button.dart';

class DyteSelfAudioToggleButton extends ConsumerStatefulWidget
    with UsesStatusColor {
  DyteSelfAudioToggleButton({
    required this.dyteMobileClient,
    DyteDesignTokens? individualDesignToken,
    this.onAudioToggle,
    this.iconSize,
    this.iconColor,
    this.showLabel = false,
    super.key,
  }) : designToken = individualDesignToken ?? globalDesignToken;

  final VoidCallback? onAudioToggle;
  final DyteDesignTokens designToken;
  final DyteMobileClient dyteMobileClient;
  final double? iconSize;
  final Color? iconColor;
  final bool showLabel;

  @override
  ConsumerState<DyteSelfAudioToggleButton> createState() =>
      _DyteSelfAudioToggleButtonState();

  @override
  Color get errorColor => designToken.colorToken.danger;

  @override
  Color get successColor => designToken.colorToken.success;

  @override
  Color get warningColor => designToken.colorToken.warning;
}

class _DyteSelfAudioToggleButtonState
    extends ConsumerState<DyteSelfAudioToggleButton> {
  SelfAudioNotifier? _selfAudioNotifier;
  @override
  void initState() {
    _selfAudioNotifier = SelfAudioNotifier(widget.dyteMobileClient);
    widget.dyteMobileClient.addSelfEventsListener(_selfAudioNotifier!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selfAudioNotifier!,
      builder: (context, value, child) => _buildToggleButton(value),
    );
  }

  void _onAudioToggle() {
    _selfAudioNotifier!.startAudioToggle();
    if (_selfAudioNotifier!.value == MediaToggleState.on) {
      widget.dyteMobileClient.localUser.disableAudio();
    } else {
      widget.dyteMobileClient.localUser.enableAudio();
    }
  }

  Widget _buildToggleButton(MediaToggleState audioToggleState) {
    if (audioToggleState == MediaToggleState.inProgress) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: widget.designToken.colorToken.textColor.shade800,
        ),
      );
    }

    final value = audioToggleState == MediaToggleState.on;
    final isMicGranted = widget
        .dyteMobileClient.localUser.permissions.isMicrophonePermissionGranted;
    final isMicAllowed = widget.dyteMobileClient.permissions.media.audio ==
            DyteMediaPermission.allowed ||
        (widget.dyteMobileClient.permissions.media.audio ==
                DyteMediaPermission.canRequest &&
            ref.watch(stageStatusNotifier) == DyteStageStatus.onStage);

    /// If user is allowed to use mic as per preset permissions
    if (isMicAllowed) {
      /// If user wants to show label (as used in bottom nav bar button)
      if (widget.showLabel) {
        return DyteBottomNavButton(
          icon: value
              ? const Icon(DyteIcons.mic_on)
              : Icon(DyteIcons.mic_off,
                  color: widget.iconColor ?? widget.errorColor),
          label: value ? DyteStrings.micOn : DyteStrings.micOff,
          disabled: !isMicGranted,
          onTap: () {
            _onAudioToggle();
            widget.onAudioToggle?.call();
          },
        );
      } else {
        return DyteButtons.icon(
          value
              ? Icon(DyteIcons.mic_on, color: widget.iconColor)
              : Icon(
                  DyteIcons.mic_off,
                  color: widget.iconColor ?? widget.errorColor,
                ),
          designToken: widget.designToken,
          iconSize: widget.iconSize,
          isDisabled: !isMicGranted,
          onPressed: () {
            _onAudioToggle();
            widget.onAudioToggle?.call();
          },
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    _selfAudioNotifier?.dispose();
    widget.dyteMobileClient.removeSelfEventsListener(_selfAudioNotifier!);
    _selfAudioNotifier = null;
    super.dispose();
  }
}

class SelfAudioNotifier extends ValueNotifier<MediaToggleState>
    implements DyteSelfEventsListener {
  final DyteMobileClient dyteMobileClient;
  SelfAudioNotifier(this.dyteMobileClient)
      : super(dyteMobileClient.localUser.audioEnabled
            ? MediaToggleState.on
            : MediaToggleState.off);

  void startAudioToggle() {
    Future.microtask(() => value = MediaToggleState.inProgress);
  }

  @override
  void onAudioUpdate(bool audioEnabled) {
    value = audioEnabled ? MediaToggleState.on : MediaToggleState.off;
  }

  @override
  void onVideoUpdate(bool videoEnabled) {}

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
  void onWaitListStatusUpdate(DyteWaitListStatus waitListStatus) {}

  @override
  void onUpdate(DyteSelfUser participant) {}

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
