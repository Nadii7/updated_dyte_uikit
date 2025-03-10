import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GridNotifier extends Notifier<GridPagesInfo>
    implements DyteParticipantEventsListener {
  void previousPage() {
    final grid = dyteMobileClient.participants.grid;
    if (grid.isPreviousPagePossible) {
      dyteMobileClient.setPage(grid.currentPageNumber - 1);
    }
  }

  void nextPage() {
    final grid = dyteMobileClient.participants.grid;
    if (grid.isNextPagePossible) {
      dyteMobileClient.setPage(grid.currentPageNumber + 1);
    }
  }

  @override
  GridPagesInfo build() {
    final grid = dyteMobileClient.participants.grid;
    return grid;
  }

  @override
  void onUpdate(DyteParticipants participants) {
    state = participants.grid;
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
  void onVideoUpdate(
      bool videoEnabled, DyteJoinedMeetingParticipant participant) {}
}
