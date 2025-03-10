import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/states/local_user_states.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalUserNotifer extends Notifier<LocalUserStates>
    implements DyteSelfEventsListener {
  LocalUserNotifer() : super();

  bool isVideoEnabled = false;

  bool isAudioEnabled = false;

  @override
  LocalUserStates build() {
    isVideoEnabled = meetingInfo.enableVideo;
    isAudioEnabled = meetingInfo.enableAudio;
    return LocalUserStateInitial();
  }

  @override
  void onAudioDevicesUpdated() => state = OnAudioDevicesUpdated();

  @override
  void onProximityChanged(bool isNear) => state = OnProximityChanged(isNear);

  @override
  void onUpdate(DyteSelfUser participant) => state = OnUpdate(participant);

  @override
  void onVideoUpdate(bool videoEnabled) {
    isVideoEnabled = videoEnabled;
    state = OnVideoUpdate(videoEnabled);
  }

  @override
  void onAudioUpdate(bool audioEnabled) {
    isAudioEnabled = audioEnabled;
    state = OnAudioUpdate(audioEnabled);
  }

  @override
  void onMeetingRoomJoinedWithoutCameraPermission() {
    state = OnMeetingRoomJoinedWithoutCameraPermission();
  }

  @override
  void onMeetingRoomJoinedWithoutMicPermission() {
    state = OnMeetingRoomJoinedWithoutMicPermission();
  }

  @override
  void onRemovedFromMeeting() {
    state = OnRemovedFromMeeting();
  }

  @override
  void onWaitListStatusUpdate(DyteWaitListStatus waitListStatus) {
    state = OnWaitListStatusUpdate(waitListStatus);
  }

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
  void onPermissionsUpdated(DytePermissions permissions) {}
}
