import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/widgets/core/button/dyte_button_controller.dart';
import 'package:dyte_uikit/src/widgets/core/button/dyte_elevated_button.dart';
import 'package:flutter/material.dart';

class DyteJoinButton extends StatefulWidget {
  const DyteJoinButton({
    required this.dyteMobileClient,
    this.dyteDesignToken,
    super.key,
    this.onMeetingJoined,
    this.height,
    this.width,
    this.isDisabled = false,
  });

  final VoidCallback? onMeetingJoined;
  final DyteDesignTokens? dyteDesignToken;
  final DyteMobileClient dyteMobileClient;
  final double? height;
  final double? width;
  final bool isDisabled;

  @override
  State<DyteJoinButton> createState() => _DyteJoinButtonState();
}

class _DyteJoinButtonState extends State<DyteJoinButton> {
  final DyteButtonController _buttonController = DyteButtonController();
  late final JoinButtonNotifier _joinButtonNotifier;

  @override
  void initState() {
    _joinButtonNotifier = JoinButtonNotifier(_buttonController);
    widget.dyteMobileClient.addMeetingRoomEventsListener(_joinButtonNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DyteButtons.solid(
      height: widget.height,
      width: widget.width,
      label: 'Join',
      onPressed: widget.isDisabled
          ? null
          : () {
              widget.dyteMobileClient.joinRoom();
              widget.onMeetingJoined?.call();
            },
      controller: _buttonController,
    );
  }

  @override
  void dispose() {
    widget.dyteMobileClient
        .removeMeetingRoomEventsListener(_joinButtonNotifier);
    _joinButtonNotifier.dispose();
    super.dispose();
  }
}

class JoinButtonNotifier extends ValueNotifier<JoinMeetingState>
    implements DyteMeetingRoomEventsListener {
  final DyteButtonController _buttonController;
  JoinButtonNotifier(this._buttonController) : super(JoinMeetingInitial());

  @override
  void onMeetingRoomJoinStarted() {
    value = JoinMeetingLoading();
    _buttonController.changeState(ButtonState.loading);
  }

  @override
  void onMeetingRoomJoinCompleted() {
    value = JoinMeetingSuccess();
    _buttonController.changeState(ButtonState.complete);
  }

  @override
  void onMeetingRoomJoinFailed(Exception exception) {
    value = JoinMeetingError();
    _buttonController.changeState(ButtonState.disabled);
  }

  @override
  void onDisconnectedFromMeetingRoom(String reason) {}

  @override
  void onMeetingInitCompleted() {}

  @override
  void onMeetingInitFailed(Exception exception) {}

  @override
  void onMeetingInitStarted() {}

  @override
  void onMeetingRoomDisconnected() {}

  @override
  void onMeetingRoomLeaveCompleted() {}

  @override
  void onMeetingRoomLeaveStarted() {}

  @override
  void onMeetingRoomReconnectionFailed() {}

  @override
  void onReconnectedToMeetingRoom() {}

  @override
  void onReconnectingToMeetingRoom() {}

  @override
  void onConnectedToMeetingRoom() {}

  @override
  void onConnectingToMeetingRoom() {}

  @override
  void onMeetingRoomConnectionFailed() {}

  @override
  void onActiveTabUpdate(DyteActiveTab? activeTab) {}

  @override
  void onMeetingEnded() {}
}

abstract class JoinMeetingState {}

class JoinMeetingInitial extends JoinMeetingState {}

class JoinMeetingLoading extends JoinMeetingState {}

class JoinMeetingSuccess extends JoinMeetingState {}

class JoinMeetingError extends JoinMeetingState {}
