import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/models/notification.dart';
import 'package:dyte_uikit/src/data/states/notification_state.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DyteNotificationNotifier extends Notifier<NotificationState>
    implements
        DyteChatEventsListener,
        DytePollEventsListener,
        DyteParticipantEventsListener,
        DytePluginEventsListener {
  @override
  NotificationState build() {
    return OnNotificationInitial();
  }

  final Set<String> _recentNotifications = {};
  final Set<String> _chatNotificationsId = {};
  final Set<String> _pollNotificationsId = {};

  bool _isNotificationByMe(String userId) =>
      dyteMobileClient.localUser.userId == userId;

  bool _isNotificationAlreadyShown(String hashCode) {
    if (!_recentNotifications.contains(hashCode)) {
      _recentNotifications.add(hashCode);
      return false;
    }
    return true;
  }

  bool _isChatNotificationAlreadyShown(DyteChatMessage message) {
    final chatId = '${message.time}-${message.userId}';
    if (!_chatNotificationsId.contains(chatId)) {
      _chatNotificationsId.add(chatId);
      return false;
    }
    return true;
  }

  bool _isPollNotificationAlreadyShown(DytePollMessage poll) {
    if (!_pollNotificationsId.contains(poll.id)) {
      _pollNotificationsId.add(poll.id);
      return false;
    }
    return true;
  }

  @override
  void onNewChatMessage(DyteChatMessage message) {
    if (_isNotificationByMe(message.userId) ||
        _isChatNotificationAlreadyShown(message)) return;
    final textMessage = _getFormattedMessage(message);
    state = OnNewNotificationReceived(
        DyteNotification(textMessage, NotificationType.chat));
  }

  @override
  void onNewPoll(DytePollMessage poll) {
    if (_isPollNotificationAlreadyShown(poll)) return;
    state = OnNewNotificationReceived(
        DyteNotification(DyteStrings.newPollCreated, NotificationType.poll));
  }

  @override
  void onParticipantJoin(DyteMeetingParticipant participant) {
    if (_isNotificationByMe(participant.id) ||
        _isNotificationAlreadyShown(participant.hashCode.toString())) return;
    state = OnNewNotificationReceived(DyteNotification(
        '${participant.name} joined', NotificationType.participant));
  }

  @override
  void onParticipantLeave(DyteMeetingParticipant participant) {
    if (_isNotificationByMe(participant.id) ||
        _isNotificationAlreadyShown(participant.hashCode.toString())) return;
    state = OnNewNotificationReceived(DyteNotification(
        '${participant.name} left', NotificationType.participant));
  }

  @override
  void onPluginActivated(DytePlugin plugin) {
    if (_isNotificationAlreadyShown(plugin.hashCode.toString())) return;
    state = OnNewNotificationReceived(
        DyteNotification('${plugin.name} launched', NotificationType.plugin));
  }

  @override
  void onPluginDeactivated(DytePlugin plugin) {
    if (_isNotificationAlreadyShown(plugin.hashCode.toString())) return;
    state = OnNewNotificationReceived(
        DyteNotification('${plugin.name} closed', NotificationType.plugin));
  }

  String _getFormattedMessage(DyteChatMessage message) {
    if (message is DyteTextMessage) {
      return '${message.displayName}: ${message.message}';
    } else if (message is DyteImageMessage) {
      return '${message.displayName}: Image received';
    } else {
      return '${message.displayName}: File received';
    }
  }

  @override
  void onActiveParticipantsChanged(List<DyteJoinedMeetingParticipant> active) {}

  @override
  void onActiveSpeakerChanged(DyteJoinedMeetingParticipant participant) {}

  @override
  void onAudioUpdate(
      bool audioEnabled, DyteJoinedMeetingParticipant participant) {}

  @override
  void onChatUpdates(List<DyteChatMessage> messages) {}

  @override
  void onNoActiveSpeaker() {}

  @override
  void onParticipantPinned(DyteJoinedMeetingParticipant participant) {}

  @override
  void onParticipantUnpinned(DyteJoinedMeetingParticipant participant) {}

  @override
  void onPluginFileRequest(DytePlugin plugin) {}

  @override
  void onPluginMessage(DytePlugin plugin, String eventName, String data) {}

  @override
  void onPollUpdates(List<DytePollMessage> polls) {}

  @override
  void onScreenShareEnded(DyteJoinedMeetingParticipant participant) {}

  @override
  void onScreenShareStarted(DyteJoinedMeetingParticipant participant) {}

  @override
  void onScreenSharesUpdated() {}

  @override
  void onUpdate(DyteParticipants participants) {}

  @override
  void onVideoUpdate(
      bool videoEnabled, DyteJoinedMeetingParticipant participant) {}
}
