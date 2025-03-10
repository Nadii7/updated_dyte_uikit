import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordingNotifer extends Notifier<DyteRecordingState>
    implements DyteRecordingEventsListener {
  @override
  void onMeetingRecordingEnded() {
    state = dyteMobileClient.recording.recordingState;
  }

  @override
  void onMeetingRecordingStarted() {
    state = dyteMobileClient.recording.recordingState;
  }

  @override
  void onMeetingRecordingStateUpdated(DyteRecordingState recordingState) {
    state = dyteMobileClient.recording.recordingState;
  }

  @override
  void onMeetingRecordingStopError(String error) {
    state = dyteMobileClient.recording.recordingState;
  }

  @override
  DyteRecordingState build() {
    return dyteMobileClient.recording.recordingState;
  }

  @override
  void onMeetingRecordingPauseError(String error) {}

  @override
  void onMeetingRecordingResumeError(String error) {}
}
