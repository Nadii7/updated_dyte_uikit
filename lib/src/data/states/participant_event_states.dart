import 'package:dyte_core/dyte_core.dart';

abstract class ParticipantEventStates {}

class ParticipantEventStatesInitial extends ParticipantEventStates {}

class OnAudioUpdate extends ParticipantEventStates {
  final bool audioEnabled;
  final DyteMeetingParticipant participant;

  OnAudioUpdate({required this.audioEnabled, required this.participant});
}

class OnActiveSpeakerChanged extends ParticipantEventStates {
  final DyteMeetingParticipant participant;

  OnActiveSpeakerChanged(this.participant);
}

class OnNoActiveSpeaker extends ParticipantEventStates {}

class OnParticipantJoin extends ParticipantEventStates {
  final DyteMeetingParticipant participant;

  OnParticipantJoin(this.participant);
}

class OnParticipantLeave extends ParticipantEventStates {
  final DyteMeetingParticipant participant;

  OnParticipantLeave(this.participant);
}

class OnParticipantPinned extends ParticipantEventStates {
  final DyteMeetingParticipant participant;

  OnParticipantPinned(this.participant);
}

class OnParticipantUnpinned extends ParticipantEventStates {
  final DyteMeetingParticipant participant;
  OnParticipantUnpinned(this.participant);
}

class OnScreenSharesUpdated extends ParticipantEventStates {}

class OnUpdate extends ParticipantEventStates {
  final DyteParticipants participants;

  OnUpdate(this.participants);
}

class OnVideoUpdate extends ParticipantEventStates {
  final bool videoEnabled;
  final DyteMeetingParticipant participant;

  OnVideoUpdate({required this.videoEnabled, required this.participant});
}

class OnActiveParticipantsChanged extends ParticipantEventStates {
  final List<DyteMeetingParticipant> activeParticipants;

  OnActiveParticipantsChanged({required this.activeParticipants});
}
