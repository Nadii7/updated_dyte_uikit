import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_icon_button.dart';
import 'package:flutter/material.dart';

class RecordingToggler extends StatefulWidget {
  final DyteRecordingState recordingState;
  const RecordingToggler(this.recordingState, {super.key});

  @override
  State<RecordingToggler> createState() => _RecordingTogglerState();
}

class _RecordingTogglerState extends State<RecordingToggler> {
  @override
  Widget build(BuildContext context) {
    return DyteIconButton(
        icon: Icon(
          widget.recordingState == DyteRecordingState.recording
              ? DyteIcons.stop_recording
              : DyteIcons.recording,
        ),
        onPressed: () {
          switch (widget.recordingState) {
            case DyteRecordingState.idle:
              dyteMobileClient.recording.start();
              break;
            case DyteRecordingState.recording:
              dyteMobileClient.recording.stop();
              break;
            default:
              null;
          }
        });
  }
}
