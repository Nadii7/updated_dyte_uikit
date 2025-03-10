import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:flutter/material.dart';

class LocalUserVideoNotifier extends ValueNotifier<bool>
    implements DyteSelfEventsListener {
  LocalUserVideoNotifier() : super(dyteMobileClient.localUser.videoEnabled);

  @override
  void onVideoUpdate(bool videoEnabled) {
    value = videoEnabled;
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
  void onProximityChanged(bool isNear) {}

  @override
  void onRemovedFromMeeting() {}

  @override
  void onRoomMessage(String type, Map<String, dynamic> payload) {}

  @override
  void onScreenShareStartFailed(String reason) {}

  @override
  void onScreenShareStarted() {}

  @override
  void onScreenShareStopped() {}

  @override
  void onStageStatusUpdated(DyteStageStatus stageStatus) {}

  @override
  void onUpdate(DyteSelfUser participant) {}

  @override
  void onVideoDeviceChanged(DyteVideoDevice videoDevice) {}

  @override
  void onWaitListStatusUpdate(DyteWaitListStatus waitListStatus) {}

  @override
  void onPermissionsUpdated(DytePermissions permissions) {}
}

class VideoNotifier extends ValueNotifier<bool>
    implements DyteParticipantEventsListener {
  DyteMeetingParticipant participant;
  VideoNotifier(this.participant) : super(participant.videoEnabled);

  @override
  void onVideoUpdate(bool videoEnabled, DyteMeetingParticipant participant) {
    if (participant.id == this.participant.id) {
      value = videoEnabled;
    }
  }

  @override
  void onActiveParticipantsChanged(List<DyteJoinedMeetingParticipant> active) {}

  @override
  void onActiveSpeakerChanged(DyteJoinedMeetingParticipant participant) {}

  @override
  void onAudioUpdate(
      bool audioEnabled, DyteJoinedMeetingParticipant participant) {}

  @override
  void onNoActiveSpeaker() {}

  @override
  void onParticipantJoin(DyteJoinedMeetingParticipant participant) {}

  @override
  void onParticipantLeave(DyteJoinedMeetingParticipant participant) {}

  @override
  void onParticipantPinned(DyteJoinedMeetingParticipant participant) {}

  @override
  void onParticipantUnpinned(DyteJoinedMeetingParticipant participant) {}

  @override
  void onScreenShareEnded(DyteJoinedMeetingParticipant participant) {}

  @override
  void onScreenShareStarted(DyteJoinedMeetingParticipant participant) {}

  @override
  void onScreenSharesUpdated() {}

  @override
  void onUpdate(DyteParticipants participants) {}
}
