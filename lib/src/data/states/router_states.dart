import 'package:dyte_core/dyte_core.dart';

class OnRouterMeetingInitCompleted extends RouterStates {}

class OnRouterMeetingInitFailed extends RouterStates {
  final Exception error;
  OnRouterMeetingInitFailed(this.error);
}

class OnRouterMeetingInitStarted extends RouterStates {}

class OnRouterMeetingRoomDisconnected extends RouterStates {}

class OnRouterMeetingRoomJoinCompleted extends RouterStates {}

class OnRouterMeetingRoomReconnecting extends RouterStates {}

class OnRouterMeetingRoomReconnected extends RouterStates {}

class OnRouterMeetingRoomReconnectionFailed extends RouterStates {}

class OnRouterMeetingRoomJoinFailed extends RouterStates {
  final Exception error;
  OnRouterMeetingRoomJoinFailed(this.error);
}

class OnRouterMeetingRoomJoinStarted extends RouterStates {}

class OnRouterMeetingRoomLeaveCompleted extends RouterStates {}

class OnRouterMeetingRoomLeaveStarted extends RouterStates {}

class OnRouterRemovedFromMeeting extends RouterStates {}

class OnRouterMeetingEnded extends RouterStates {}

class OnRouterSelfWaitingRoomStatusUpdate extends RouterStates {
  final DyteWaitListStatus waitListStatus;
  OnRouterSelfWaitingRoomStatusUpdate(this.waitListStatus);
}

class RouterInitial extends RouterStates {}

abstract class RouterStates {}
