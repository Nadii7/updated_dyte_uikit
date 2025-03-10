import 'package:dyte_core/dyte_core.dart';

abstract class RecordingStates {}

class InitialRecordingState extends RecordingStates {}

class OnRecordingStarted extends RecordingStates {
  final DyteRecordingState state;

  OnRecordingStarted(this.state);
}

class OnRecordingEnded extends RecordingStates {
  final DyteRecordingState state;

  OnRecordingEnded(this.state);
}

class OnRecordingStateUpdated extends RecordingStates {
  final DyteRecordingState state;

  OnRecordingStateUpdated(this.state);
}

class OnRecordingStoppedError extends RecordingStates {}
