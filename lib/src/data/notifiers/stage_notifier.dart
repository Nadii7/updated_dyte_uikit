import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StageStatusNotifier extends Notifier<DyteStageStatus>
    implements DyteStageEventsListener {
  @override
  DyteStageStatus build() {
    return dyteMobileClient.stage.status;
  }

  @override
  void onAddedToStage() {}

  @override
  void onParticipantRemovedFromStage(
      DyteJoinedMeetingParticipant participant) {}

  @override
  void onPresentRequestAccepted(DyteJoinedMeetingParticipant participant) {}

  @override
  void onPresentRequestAdded(DyteJoinedMeetingParticipant participant) {}

  @override
  void onPresentRequestClosed(DyteJoinedMeetingParticipant participant) {}

  @override
  void onPresentRequestReceived() {}

  @override
  void onPresentRequestRejected(DyteJoinedMeetingParticipant participant) {}

  @override
  void onPresentRequestWithdrawn(DyteJoinedMeetingParticipant participant) {}

  @override
  void onRemovedFromStage() {}

  @override
  void onStageRequestsUpdated(
      List<DyteJoinedMeetingParticipant> accessRequests) {}

  @override
  void onStageStatusUpdated(DyteStageStatus stageStatus) {
    state = stageStatus;
  }

  @override
  void onParticipantStartedPresenting(
      DyteJoinedMeetingParticipant participant) {}

  @override
  void onParticipantStoppedPresenting(
      DyteJoinedMeetingParticipant participant) {}
}

class StageRequestsNotifier extends Notifier<List<DyteJoinedMeetingParticipant>>
    implements DyteStageEventsListener {
  @override
  List<DyteJoinedMeetingParticipant> build() {
    return dyteMobileClient.stage.accessRequests;
  }

  @override
  void onAddedToStage() {}

  @override
  void onPresentRequestAccepted(DyteJoinedMeetingParticipant participant) {}

  @override
  void onPresentRequestAdded(DyteJoinedMeetingParticipant participant) {}

  @override
  void onPresentRequestClosed(DyteJoinedMeetingParticipant participant) {}

  @override
  void onPresentRequestReceived() {}

  @override
  void onPresentRequestRejected(DyteJoinedMeetingParticipant participant) {}

  @override
  void onPresentRequestWithdrawn(DyteJoinedMeetingParticipant participant) {}

  @override
  void onRemovedFromStage() {}

  @override
  void onStageRequestsUpdated(
      List<DyteJoinedMeetingParticipant> accessRequests) {
    state = accessRequests;
  }

  @override
  void onParticipantRemovedFromStage(
      DyteJoinedMeetingParticipant participant) {}

  @override
  void onStageStatusUpdated(DyteStageStatus stageStatus) {}

  @override
  void onParticipantStartedPresenting(
      DyteJoinedMeetingParticipant participant) {}

  @override
  void onParticipantStoppedPresenting(
      DyteJoinedMeetingParticipant participant) {}
}

class UnreadStageRequestsCountNotifier extends Notifier<int>
    implements DyteStageEventsListener {
  int _unread = 0;

  void markAllAsRead() {
    _unread = 0;
    state = _unread;
  }

  @override
  int build() {
    return _unread = dyteMobileClient.stage.accessRequests.length;
  }

  @override
  void onAddedToStage() {}

  @override
  onParticipantRemovedFromStage(DyteJoinedMeetingParticipant participant) {}

  @override
  onPresentRequestAccepted(DyteJoinedMeetingParticipant participant) {}

  @override
  onPresentRequestAdded(DyteJoinedMeetingParticipant participant) {}

  @override
  onPresentRequestClosed(DyteJoinedMeetingParticipant participant) {}

  @override
  onPresentRequestReceived() {}

  @override
  onPresentRequestRejected(DyteJoinedMeetingParticipant participant) {}

  @override
  onPresentRequestWithdrawn(DyteJoinedMeetingParticipant participant) {}

  @override
  onRemovedFromStage() {}

  @override
  onStageRequestsUpdated(List<DyteJoinedMeetingParticipant> accessRequests) {
    _unread = accessRequests.length;
    state = _unread;
  }

  @override
  onStageStatusUpdated(DyteStageStatus stageStatus) {}

  @override
  void onParticipantStartedPresenting(
      DyteJoinedMeetingParticipant participant) {}

  @override
  void onParticipantStoppedPresenting(
      DyteJoinedMeetingParticipant participant) {}
}
