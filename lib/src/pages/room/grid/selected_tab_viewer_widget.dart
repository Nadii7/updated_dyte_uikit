import 'package:dyte_uikit/src/data/models/dyte_tab_participant.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/pages/room/grid/plugin_viewer_widget.dart';
import 'package:dyte_uikit/src/pages/room/grid/screenshare_viewer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedTabViewerWidget extends ConsumerWidget {
  const SelectedTabViewerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabParticipant = ref.watch(tabNotifierProvider);
    final selectedParticipant = tabParticipant.selected;
    return selectedParticipant.type == DyteTabParticipantType.screenshare
        ? ScreenshareViewerWidget(selectedParticipant.screenshare)
        : PluginViewerWidget(selectedParticipant.plugin);
  }
}
