import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScreenshareNotifier extends Notifier<List<DyteMeetingParticipant>>
    implements DyteDataEventsListener {
  @override
  void onScreenShareUpdate(List<DyteJoinedMeetingParticipant> screenShares) {
    state = screenShares;
  }

  @override
  List<DyteMeetingParticipant> build() {
    return dyteMobileClient.participants.screenshares;
  }

  @override
  void onMetaUpdate(
    String roomName,
    String meetingTitle,
    String meetingStartedTimestamp,
    DyteRoomType roomType,
    DyteDesignTokens designTokens,
  ) {}

  @override
  void onPluginUpdate(List<DytePlugin> plugin) {}

  @override
  void onSelfPermissionsUpdate(DytePermissions permissions) {}

  @override
  void onLivestreamUpdate(DyteLivestreamData livestreamData) {}
}

class SelfScreenshareNotifier extends Notifier<bool>
    implements DyteSelfEventsListener {
  late bool isSelfScreensharing;
  @override
  bool build() {
    isSelfScreensharing = dyteMobileClient.participants.screenshares
        .any((peer) => peer.id == dyteMobileClient.localUser.id);
    return isSelfScreensharing;
  }

  @override
  void onAudioDevicesUpdated() {}

  @override
  void onAudioUpdate(bool audioEnabled) {}

  @override
  void onMeetingRoomJoinedWithoutCameraPermission() {}

  @override
  void onMeetingRoomJoinedWithoutMicPermission() {}

  @override
  void onPermissionsUpdated(DytePermissions permissions) {}

  @override
  void onProximityChanged(bool isNear) {}

  @override
  void onRemovedFromMeeting() {}

  @override
  void onRoomMessage(String type, Map<String, dynamic> payload) {}

  @override
  void onScreenShareStartFailed(String reason) {}

  @override
  void onScreenShareStopped() {
    if (isSelfScreensharing) {
      isSelfScreensharing = false;
      state = false;
    }
  }

  @override
  void onScreenShareStarted() {
    if (!isSelfScreensharing) {
      isSelfScreensharing = true;
      state = true;
    }
  }

  @override
  void onStageStatusUpdated(DyteStageStatus stageStatus) {}

  @override
  void onUpdate(DyteSelfUser participant) {}

  @override
  void onVideoDeviceChanged(DyteVideoDevice videoDevice) {}

  @override
  void onVideoUpdate(bool videoEnabled) {}

  @override
  void onWaitListStatusUpdate(DyteWaitListStatus waitListStatus) {}
}

class ScreenshareLimitNotifier extends ValueNotifier<bool>
    implements DyteDataEventsListener {
  ScreenshareLimitNotifier()
      : super(dyteMobileClient.permissions.config.maxScreenShareCount <=
            dyteMobileClient.participants.screenshares.length);

  bool get isLimitReached =>
      dyteMobileClient.permissions.config.maxScreenShareCount <=
      dyteMobileClient.participants.screenshares.length;

  @override
  void onScreenShareUpdate(List<DyteJoinedMeetingParticipant> screenShares) {
    value = isLimitReached;
  }

  @override
  void onLivestreamUpdate(DyteLivestreamData livestreamData) {}

  @override
  void onMetaUpdate(
    String roomName,
    String meetingTitle,
    String meetingStartedTimestamp,
    DyteRoomType roomType,
    DyteDesignTokens designTokens,
  ) {}

  @override
  void onPluginUpdate(List<DytePlugin> plugin) {}

  @override
  void onSelfPermissionsUpdate(DytePermissions permissions) {}
}
