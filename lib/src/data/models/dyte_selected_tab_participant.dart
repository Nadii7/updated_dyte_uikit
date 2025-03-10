import 'package:dyte_uikit/src/data/models/dyte_tab_participant.dart';
import 'package:flutter/foundation.dart';

class DyteSelectedTabParticipant {
  final List<DyteTabParticipant> participant;

  bool get isEmpty => participant.isEmpty;

  DyteTabParticipant get selected =>
      participant.firstWhere((element) => element.isSelected);

  DyteSelectedTabParticipant({
    required this.participant,
  });

  DyteSelectedTabParticipant.empty() : participant = [];

  void addTabbedParticipant(DyteTabParticipant participant) {
    this.participant.add(participant);
  }

  DyteSelectedTabParticipant refreshWithNewParticipants(
      List<DyteTabParticipant> participants) {
    participant.clear();
    participant.addAll(participants);
    return this;
  }

  void removeParticipant(DyteTabParticipant participant) {
    this.participant.remove(participant);
  }

  DyteSelectedTabParticipant select(DyteTabParticipant participant) {
    for (final p in this.participant) {
      p.isSelected = p == participant;
    }
    return this;
  }

  DyteSelectedTabParticipant copyWith({
    List<DyteTabParticipant>? participant,
  }) {
    return DyteSelectedTabParticipant(
      participant: participant ?? this.participant,
    );
  }

  @override
  String toString() => 'DyteTabSelectedParticipant(participant: $participant)';

  @override
  bool operator ==(covariant DyteSelectedTabParticipant other) {
    if (identical(this, other)) return true;

    return listEquals(other.participant, participant);
  }

  @override
  int get hashCode => participant.hashCode;
}
