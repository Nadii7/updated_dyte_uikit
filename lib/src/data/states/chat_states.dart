import 'package:dyte_core/dyte_core.dart';

abstract class ChatStates {}

class ChatStateInitial extends ChatStates {}

class OnChatUpdates extends ChatStates {
  final List<DyteChatMessage> messages;
  OnChatUpdates(this.messages);
}

class OnNewChatMessage extends ChatStates {
  final DyteChatMessage message;
  OnNewChatMessage(this.message);
}
