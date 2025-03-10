import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DyteListenerManager {
  final WidgetRef ref;

  DyteListenerManager._(this.ref);

  static late DyteListenerManager? _instance;

  static void init(WidgetRef ref) {
    _instance = DyteListenerManager._(ref);
  }

  static DyteListenerManager get instance {
    assert(_instance != null,
        'ManageListener not initialized, please call init()');
    return _instance!;
  }

  void registerDyteListeners() {
    dyteMobileClient.addMeetingRoomEventsListener(
      ref.read(routerNotifier.notifier),
    );
    dyteMobileClient.addSelfEventsListener(
      ref.read(localUserSettingsProvider.notifier),
    );
    dyteMobileClient.addSelfEventsListener(
      ref.read(routerNotifier.notifier),
    );
    dyteMobileClient.addParticipantEventsListener(
      ref.read(participantEventNotifier.notifier),
    );

    dyteMobileClient.addChatEventsListener(
      ref.read(chatListNotifier.notifier),
    );
    dyteMobileClient.addParticipantEventsListener(
      ref.read(gridNotifier.notifier),
    );

    dyteMobileClient.addDataEventsListener(
      ref.read(screenshareProvider.notifier),
    );
    dyteMobileClient.addRecordingListener(
      ref.read(recordingNotifier.notifier),
    );
    dyteMobileClient.addDataEventsListener(
      ref.read(pluginProvider.notifier),
    );
    dyteMobileClient.addWaitingRoomListener(
      ref.read(waitingRoomNotifier.notifier),
    );
    dyteMobileClient.addPollEventsListener(
      ref.read(newPollEventNotifier.notifier),
    );
    dyteMobileClient.addPollEventsListener(
      ref.read(pollsListNotifier.notifier),
    );
    dyteMobileClient.addPollEventsListener(
      ref.read(unreadPollsNotifier.notifier),
    );
    dyteMobileClient.addChatEventsListener(
      ref.read(unreadChatNotifier.notifier),
    );

    dyteMobileClient.addWaitingRoomListener(
      ref.read(unreadWaitlistedCountNotifier.notifier),
    );

    dyteMobileClient.addStageEventsListener(
      ref.read(unreadStageRequestCountNotifier.notifier),
    );

    // For notifications across the SDK
    dyteMobileClient.addChatEventsListener(
      ref.read(notificationProvider.notifier),
    );
    dyteMobileClient.addPollEventsListener(
      ref.read(notificationProvider.notifier),
    );
    dyteMobileClient.addParticipantEventsListener(
      ref.read(notificationProvider.notifier),
    );
    dyteMobileClient.addPluginEventsListener(
      ref.read(notificationProvider.notifier),
    );
    dyteMobileClient.addLivestreamEventsListener(
      ref.read(lvsStateNotifier.notifier),
    );
    dyteMobileClient.addStageEventsListener(
      ref.read(stageStatusNotifier.notifier),
    );
    dyteMobileClient.addStageEventsListener(
      ref.read(stageRequestsNotifier.notifier),
    );

    dyteMobileClient.addSelfEventsListener(
      ref.read(selfScreenshareProvider.notifier),
    );
  }

  void unregisterDyteListeners() {
    // We'll remove this listener once leave completed is called, in case when `dyteClient.release()` or `onMeetingRoomLeaveCompleted()` is triggered.
    // dyteMobileClient.removeMeetingRoomEventsListener(
    //   ref.read(routerNotifier.notifier),
    // );
    dyteMobileClient.removeSelfEventsListener(
      ref.read(localUserSettingsProvider.notifier),
    );
    ref.invalidate(localUserSettingsProvider);

    dyteMobileClient.removeSelfEventsListener(
      ref.read(routerNotifier.notifier),
    );
    ref.invalidate(routerNotifier);

    dyteMobileClient.removeParticipantEventsListener(
      ref.read(participantEventNotifier.notifier),
    );
    ref.invalidate(participantEventNotifier);

    dyteMobileClient.removeChatEventsListener(
      ref.read(chatListNotifier.notifier),
    );
    ref.invalidate(chatListNotifier);

    dyteMobileClient.removeParticipantEventsListener(
      ref.read(gridNotifier.notifier),
    );
    ref.invalidate(gridNotifier);

    dyteMobileClient.removeDataEventsListener(
      ref.read(screenshareProvider.notifier),
    );
    ref.invalidate(screenshareProvider);

    dyteMobileClient.removeRecordingListener(
      ref.read(recordingNotifier.notifier),
    );
    ref.invalidate(recordingNotifier);

    dyteMobileClient.removeDataEventsListener(
      ref.read(pluginProvider.notifier),
    );
    ref.invalidate(pluginProvider);

    dyteMobileClient.removeWaitingRoomListener(
      ref.read(waitingRoomNotifier.notifier),
    );
    ref.invalidate(waitingRoomNotifier);

    dyteMobileClient.removePollEventsListener(
      ref.read(newPollEventNotifier.notifier),
    );
    ref.invalidate(newPollEventNotifier);

    dyteMobileClient.removePollEventsListener(
      ref.read(pollsListNotifier.notifier),
    );
    ref.invalidate(pollsListNotifier);

    dyteMobileClient.removePollEventsListener(
      ref.read(unreadPollsNotifier.notifier),
    );
    ref.invalidate(unreadPollsNotifier);

    dyteMobileClient.removeChatEventsListener(
      ref.read(unreadChatNotifier.notifier),
    );
    ref.invalidate(unreadChatNotifier);

    dyteMobileClient.removeWaitingRoomListener(
      ref.read(unreadWaitlistedCountNotifier.notifier),
    );
    ref.invalidate(unreadWaitlistedCountNotifier);

    dyteMobileClient.removeStageEventsListener(
      ref.read(unreadStageRequestCountNotifier.notifier),
    );
    ref.invalidate(unreadStageRequestCountNotifier);

    // For notifications across the SDK
    dyteMobileClient.removeChatEventsListener(
      ref.read(notificationProvider.notifier),
    );
    dyteMobileClient.removePollEventsListener(
      ref.read(notificationProvider.notifier),
    );
    dyteMobileClient.removeParticipantEventsListener(
      ref.read(notificationProvider.notifier),
    );
    dyteMobileClient.removePluginEventsListener(
      ref.read(notificationProvider.notifier),
    );
    ref.invalidate(notificationProvider);

    dyteMobileClient.removeLivestreamEventsListener(
      ref.read(lvsStateNotifier.notifier),
    );
    ref.invalidate(lvsStateNotifier);

    dyteMobileClient.removeStageEventsListener(
      ref.read(stageStatusNotifier.notifier),
    );
    dyteMobileClient.removeStageEventsListener(
      ref.read(stageRequestsNotifier.notifier),
    );
    ref.invalidate(stageStatusNotifier);

    dyteMobileClient.removeSelfEventsListener(
      ref.read(selfScreenshareProvider.notifier),
    );
    ref.invalidate(selfScreenshareProvider);
  }
}
