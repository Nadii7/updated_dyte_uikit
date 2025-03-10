import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:flutter/foundation.dart';

class LocalUserAudioNotifier extends ValueNotifier<bool>
    implements DyteSelfEventsListener {
  LocalUserAudioNotifier() : super(dyteMobileClient.localUser.audioEnabled);

  @override
  void onAudioUpdate(bool audioEnabled) {
    value = audioEnabled;
  }

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
  void onVideoUpdate(bool videoEnabled) {}

  @override
  void onWaitListStatusUpdate(DyteWaitListStatus waitListStatus) {}

  @override
  void onPermissionsUpdated(DytePermissions permissions) {}
}

class AudioNotifier extends ValueNotifier<bool>
    implements DyteParticipantEventsListener {
  AudioNotifier(this.participant) : super(participant.audioEnabled);

  final DyteMeetingParticipant participant;

  @override
  void onAudioUpdate(bool audioEnabled, DyteMeetingParticipant participant) {
    if (participant.id == this.participant.id) {
      value = audioEnabled;
    }
  }

  @override
  void onActiveParticipantsChanged(List<DyteJoinedMeetingParticipant> active) {}

  @override
  void onActiveSpeakerChanged(DyteJoinedMeetingParticipant participant) {}

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

  @override
  void onVideoUpdate(
      bool videoEnabled, DyteJoinedMeetingParticipant participant) {}
}
