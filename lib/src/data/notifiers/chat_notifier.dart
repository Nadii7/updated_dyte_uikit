import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dyte_uikit.dart';

class ChatListNotifier extends Notifier<List<DyteChatMessage>>
    implements DyteChatEventsListener {
  @override
  List<DyteChatMessage> build() {
    return dyteMobileClient.chat.messages;
  }

  @override
  void onChatUpdates(List<DyteChatMessage> messages) {
    state = messages;
  }

  @override
  void onNewChatMessage(DyteChatMessage message) {}
}

class UnreadChatNotifier extends Notifier<int>
    implements DyteChatEventsListener {
  int _unread = 0;
  int _read = 0;

  void readAllMessages(int messagesLength) {
    _read = messagesLength;
    _unread = messagesLength;
    state = _unread - _read;
  }

  @override
  void onChatUpdates(List<DyteChatMessage> messages) {
    _unread = messages.length;
    state = _unread - _read;
  }

  @override
  int build() {
    _read = 0;
    _unread = dyteMobileClient.chat.messages.length;
    return _unread - _read;
  }

  @override
  void onNewChatMessage(DyteChatMessage message) {}
}
