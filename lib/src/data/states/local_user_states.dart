import 'package:dyte_core/dyte_core.dart';

abstract class LocalUserStates {}

class LocalUserStateInitial extends LocalUserStates {}

class OnVideoUpdate extends LocalUserStates {
  final bool isVideoEnabled;
  OnVideoUpdate(this.isVideoEnabled);
}

class OnAudioUpdate extends LocalUserStates {
  final bool isAudioEnabled;
  OnAudioUpdate(this.isAudioEnabled);
}

class OnMeetingRoomJoinedWithoutCameraPermission extends LocalUserStates {}

class OnMeetingRoomJoinedWithoutMicPermission extends LocalUserStates {}

class OnRemovedFromMeeting extends LocalUserStates {}

class OnAudioDevicesUpdated extends LocalUserStates {}

class OnProximityChanged extends LocalUserStates {
  final bool isNear;
  OnProximityChanged(this.isNear);
}

class OnUpdate extends LocalUserStates {
  final DyteSelfUser participant;
  OnUpdate(this.participant);
}

class OnWaitListStatusUpdate extends LocalUserStates {
  final DyteWaitListStatus waitListStatus;
  OnWaitListStatusUpdate(this.waitListStatus);
}
