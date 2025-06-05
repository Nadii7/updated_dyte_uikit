import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/states/whitelisted_participant_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WaitingRoomNotifer extends Notifier<WaitlistedParticipantStates>
    implements DyteWaitingRoomEventsListener {
  @override
  void onWaitListParticipantAccepted(DyteMeetingParticipant participant) {
    state = WaitlistedParticipantAccepted(participant);
  }

  @override
  void onWaitListParticipantRejected(DyteMeetingParticipant participant) {
    state = WaitlistedParticipantRejected(participant);
  }

  @override
  void onWaitListParticipantJoined(DyteMeetingParticipant participant) {
    state = WaitlistedParticipantJoined(participant);
  }

  @override
  void onWaitListParticipantClosed(DyteMeetingParticipant participant) {
    state = WaitlistedParticipantClosed(participant);
  }

  @override
  WaitlistedParticipantStates build() {
    return WaitlistedParticipantInitial();
  }
}
