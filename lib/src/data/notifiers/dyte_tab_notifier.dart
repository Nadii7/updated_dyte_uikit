import 'package:dyte_uikit/src/data/models/dyte_selected_tab_participant.dart';
import 'package:dyte_uikit/src/data/models/dyte_tab_participant.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DyteTabNotifier extends Notifier<DyteSelectedTabParticipant> {
  void watchScreenshareAndPluginChanges() {
    final screenshares = ref.watch(screenshareProvider);
    final pluginState = ref.watch(pluginProvider);

    final screenShareTabParticipants = screenshares.map((e) {
      return DyteTabParticipant(e,
          type: DyteTabParticipantType.screenshare, isSelected: false);
    }).toList();

    final pluginTabParticipants = pluginState.map((e) {
      return DyteTabParticipant(e,
          type: DyteTabParticipantType.plugin, isSelected: false);
    }).toList();

    final dyteTabParticipant = [
      ...screenShareTabParticipants,
      ...pluginTabParticipants
    ];

    final dyteTabParticipantWithFirstSelected = dyteTabParticipant
        .map((e) => e.copyWith(isSelected: dyteTabParticipant.first == e))
        .toList();

    state = DyteSelectedTabParticipant(
        participant: dyteTabParticipantWithFirstSelected);
  }

  void selectParticipant(DyteTabParticipant participant) {
    DyteSelectedTabParticipant currentParticipant =
        DyteSelectedTabParticipant(participant: state.participant);
    currentParticipant = currentParticipant.select(participant);
    state = currentParticipant;
  }

  List<DyteTabParticipant> get participants => state.participant;

  DyteTabParticipant get selected => state.selected;

  @override
  DyteSelectedTabParticipant build() {
    state = DyteSelectedTabParticipant.empty();
    watchScreenshareAndPluginChanges();
    return state;
  }
}
