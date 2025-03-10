import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/participant_event_states.dart';

class ParticipantNotifier extends Notifier<ParticipantEventStates>
    implements DyteParticipantEventsListener {
  @override
  ParticipantEventStates build() {
    return ParticipantEventStatesInitial();
  }

  @override
  void onAudioUpdate(
    bool audioEnabled,
    DyteMeetingParticipant participant,
  ) {
    state = OnAudioUpdate(audioEnabled: audioEnabled, participant: participant);
  }

  @override
  void onActiveSpeakerChanged(DyteMeetingParticipant participant) {
    state = OnActiveSpeakerChanged(participant);
  }

  @override
  void onNoActiveSpeaker() {
    state = OnNoActiveSpeaker();
  }

  @override
  void onParticipantJoin(DyteMeetingParticipant participant) {
    state = OnParticipantJoin(participant);
  }

  @override
  void onParticipantLeave(DyteMeetingParticipant participant) {
    state = OnParticipantLeave(participant);
  }

  @override
  void onParticipantPinned(DyteMeetingParticipant participant) {
    state = OnParticipantPinned(participant);
  }

  @override
  void onActiveParticipantsChanged(List<DyteMeetingParticipant> active) {
    state = OnActiveParticipantsChanged(activeParticipants: active);
  }

  @override
  void onParticipantUnpinned(DyteMeetingParticipant participant) {
    state = OnParticipantUnpinned(participant);
  }

  @override
  void onScreenSharesUpdated() {
    state = OnScreenSharesUpdated();
  }

  @override
  void onVideoUpdate(
    bool videoEnabled,
    DyteMeetingParticipant participant,
  ) {
    state = OnVideoUpdate(videoEnabled: videoEnabled, participant: participant);
  }

  @override
  void onUpdate(DyteParticipants participants) {
    state = OnUpdate(participants);
  }

  @override
  void onScreenShareEnded(DyteJoinedMeetingParticipant participant) {}

  @override
  void onScreenShareStarted(DyteJoinedMeetingParticipant participant) {}
}

class UnreadWaitlistedCountNotifier extends Notifier<int>
    implements DyteWaitingRoomEventsListener {
  @override
  int build() {
    dyteMobileClient.participantsStream.listen((participant) {
      state = dyteMobileClient.participants.waitlisted.length;
    });
    return dyteMobileClient.participants.waitlisted.length;
  }

  @override
  void onWaitListParticipantAccepted(DyteMeetingParticipant participant) {}

  @override
  void onWaitListParticipantClosed(DyteMeetingParticipant participant) {}

  @override
  void onWaitListParticipantJoined(DyteMeetingParticipant participant) {}

  @override
  void onWaitListParticipantRejected(DyteMeetingParticipant participant) {}
}
