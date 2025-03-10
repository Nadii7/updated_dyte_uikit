import 'package:dyte_core/dyte_core.dart';

abstract class PollStates {}

class InitialPollState extends PollStates {}

class OnNewPoll extends PollStates {
  final DytePollMessage poll;

  OnNewPoll(this.poll);
}

class OnPollUpdates extends PollStates {
  final List<DytePollMessage> polls;

  OnPollUpdates(this.polls);
}
