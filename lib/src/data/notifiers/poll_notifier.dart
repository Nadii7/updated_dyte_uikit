import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/poll_states.dart';

class NewPollNotifer extends Notifier<PollStates>
    implements DytePollEventsListener {
  @override
  void onNewPoll(DytePollMessage poll) {
    state = OnNewPoll(poll);
  }

  @override
  PollStates build() {
    return InitialPollState();
  }

  @override
  void onPollUpdates(List<DytePollMessage> polls) {}
}

class PollListNotifier extends Notifier<List<DytePollMessage>>
    implements DytePollEventsListener {
  @override
  List<DytePollMessage> build() {
    return dyteMobileClient.polls.polls;
  }

  @override
  void onPollUpdates(List<DytePollMessage> polls) {
    state = polls;
  }

  @override
  void onNewPoll(DytePollMessage poll) {}
}

class UnreadPollNotifier extends Notifier<int>
    implements DytePollEventsListener {
  int _read = 0;
  int _unread = 0;

  @override
  void onNewPoll(DytePollMessage poll) {}

  void markAllAsRead(int totalPolls) {
    _read = totalPolls;
    _unread = totalPolls;
    state = _unread - _read;
  }

  @override
  int build() {
    _read = 0;
    _unread = dyteMobileClient.polls.polls.length;
    return _unread - _read;
  }

  @override
  void onPollUpdates(List<DytePollMessage> polls) {
    _unread = polls.length - _read;
    state = _unread;
  }
}
