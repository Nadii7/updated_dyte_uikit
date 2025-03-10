import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:flutter/material.dart';

class PinNotifier extends ValueNotifier<DyteMeetingParticipant?>
    implements DyteParticipantEventsListener {
  PinNotifier() : super(dyteMobileClient.participants.pinned);

  @override
  void onParticipantPinned(DyteJoinedMeetingParticipant participant) {
    value = participant;
  }

  @override
  void onParticipantUnpinned(DyteJoinedMeetingParticipant participant) {
    value = null;
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
