import 'package:dyte_uikit/dyte_uikit.dart';

class DyteTabParticipant {
  dynamic participant;
  final DyteTabParticipantType type;
  bool isSelected;

  DyteTabParticipant(
    this.participant, {
    required this.type,
    this.isSelected = false,
  });

  void toggleSelected() {
    isSelected = !isSelected;
  }

  @override
  bool operator ==(covariant DyteTabParticipant other) {
    if (identical(this, other)) return true;
    return other.participant.runtimeType == participant.runtimeType &&
        participant == other.participant &&
        other.type == type &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode =>
      participant.hashCode ^ type.hashCode ^ isSelected.hashCode;

  @override
  String toString() =>
      'DyteTabParticipant(participant: $participant, type: $type, isSelected: $isSelected)';

  DyteTabParticipant copyWith({
    dynamic participant,
    DyteTabParticipantType? type,
    bool? isSelected,
  }) {
    return DyteTabParticipant(
      participant ?? this.participant,
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

extension DyteTabParticipantExtension on DyteTabParticipant {
  String get name => type == DyteTabParticipantType.screenshare
      ? screenshare.name
      : plugin.name;

  DyteMeetingParticipant get screenshare =>
      type == DyteTabParticipantType.screenshare
          ? participant
          : throw Exception('Participant is not a screenshare');
  DytePlugin get plugin => type == DyteTabParticipantType.plugin
      ? participant
      : throw Exception('Participant is not a plugin');
}

enum DyteTabParticipantType {
  plugin,
  screenshare,
}
