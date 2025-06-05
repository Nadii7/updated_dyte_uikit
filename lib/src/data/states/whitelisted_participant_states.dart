import 'package:dyte_core/dyte_core.dart';

abstract class WaitlistedParticipantStates {}

class WaitlistedParticipantInitial extends WaitlistedParticipantStates {}

class WaitlistedParticipantAccepted extends WaitlistedParticipantStates {
  final DyteMeetingParticipant participant;
  WaitlistedParticipantAccepted(this.participant);
}

class WaitlistedParticipantRejected extends WaitlistedParticipantStates {
  final DyteMeetingParticipant participant;
  WaitlistedParticipantRejected(this.participant);
}

class WaitlistedParticipantClosed extends WaitlistedParticipantStates {
  final DyteMeetingParticipant participant;
  WaitlistedParticipantClosed(this.participant);
}

class WaitlistedParticipantJoined extends WaitlistedParticipantStates {
  final DyteMeetingParticipant participant;
  WaitlistedParticipantJoined(this.participant);
}
