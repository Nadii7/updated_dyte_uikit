import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/states/router_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouterNotifier extends Notifier<RouterStates>
    implements DyteMeetingRoomEventsListener, DyteSelfEventsListener {
  @override
  RouterStates build() {
    return RouterInitial();
  }

  @override
  void onMeetingInitStarted() {
    state = OnRouterMeetingInitStarted();
  }

  @override
  void onMeetingInitCompleted() {
    state = OnRouterMeetingInitCompleted();
  }

  @override
  void onMeetingInitFailed(Exception exception) {
    state = OnRouterMeetingInitFailed(exception);
  }

  @override
  void onMeetingRoomJoinStarted() {
    state = OnRouterMeetingRoomJoinStarted();
  }

  @override
  void onMeetingRoomJoinCompleted() {
    state = OnRouterMeetingRoomJoinCompleted();
  }

  @override
  void onMeetingRoomJoinFailed(Exception exception) {
    state = OnRouterMeetingRoomJoinFailed(exception);
  }

  @override
  void onMeetingRoomLeaveStarted() {
    state = OnRouterMeetingRoomLeaveStarted();
  }

  @override
  void onMeetingRoomLeaveCompleted() {
    state = OnRouterMeetingRoomLeaveCompleted();
  }

  @override
  void onMeetingRoomDisconnected() {
    state = OnRouterMeetingRoomDisconnected();
  }

  @override
  void onWaitListStatusUpdate(DyteWaitListStatus waitListStatus) {
    state = OnRouterSelfWaitingRoomStatusUpdate(waitListStatus);
  }

  @override
  void onRemovedFromMeeting() {
    state = OnRouterRemovedFromMeeting();
  }

  @override
  void onAudioDevicesUpdated() {}

  @override
  void onAudioUpdate(bool audioEnabled) {}

  @override
  void onMeetingRoomJoinedWithoutCameraPermission() {}

  @override
  void onMeetingRoomJoinedWithoutMicPermission() {}

  @override
  void onProximityChanged(bool isNear) {}

  @override
  void onUpdate(DyteSelfUser participant) {}

  @override
  void onVideoUpdate(bool videoEnabled) {}

  @override
  void onDisconnectedFromMeetingRoom(String reason) {}

  @override
  void onMeetingRoomReconnectionFailed() {
    state = OnRouterMeetingRoomReconnectionFailed();
  }

  @override
  void onReconnectedToMeetingRoom() {
    state = OnRouterMeetingRoomReconnected();
  }

  @override
  void onReconnectingToMeetingRoom() {
    state = OnRouterMeetingRoomReconnecting();
  }

  @override
  void onConnectedToMeetingRoom() {}

  @override
  void onConnectingToMeetingRoom() {}

  @override
  void onRoomMessage(String type, Map<String, dynamic> payload) {}

  @override
  void onStageStatusUpdated(DyteStageStatus stageStatus) {}

  @override
  void onVideoDeviceChanged(DyteVideoDevice videoDevice) {}

  @override
  void onScreenShareStartFailed(String reason) {}

  @override
  void onScreenShareStarted() {}

  @override
  void onScreenShareStopped() {}

  @override
  void onMeetingRoomConnectionFailed() {}

  @override
  void onActiveTabUpdate(DyteActiveTab? activeTab) {}

  @override
  void onMeetingEnded() {
    state = OnRouterMeetingEnded();
  }

  @override
  void onPermissionsUpdated(DytePermissions permissions) {}
}
