import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_uikit/src/data/models/dyte_selected_tab_participant.dart';
import 'package:dyte_uikit/src/data/notifiers/chat_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/dyte_tab_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/edit_name_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/livestream_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/local_user_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/meeting_timer_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/notifications_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/participant_state_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/plugin_state_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/poll_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/recording_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/router_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/screenshare_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/stage_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/stage_permission_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/waitlisted_participant_notifier.dart';
import 'package:dyte_uikit/src/data/respository/grid_notifier.dart';
import 'package:dyte_uikit/src/data/states/livestream_states.dart';
import 'package:dyte_uikit/src/data/states/local_user_states.dart';
import 'package:dyte_uikit/src/data/states/notification_state.dart';
import 'package:dyte_uikit/src/data/states/participant_event_states.dart';
import 'package:dyte_uikit/src/data/states/poll_states.dart';
import 'package:dyte_uikit/src/data/states/router_states.dart';
import 'package:dyte_uikit/src/data/states/waitlisted_participant_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localUserSettingsProvider =
    NotifierProvider<LocalUserNotifer, LocalUserStates>(
  () {
    return LocalUserNotifer();
  },
  name: 'localUserSettingsProvider',
);

final participantEventNotifier =
    NotifierProvider<ParticipantNotifier, ParticipantEventStates>(
  () => ParticipantNotifier(),
  name: 'participantEventNotifier',
);

final gridNotifier = NotifierProvider<GridNotifier, GridPagesInfo>(
  () => GridNotifier(),
  name: 'gridNotifier',
);

final screenshareProvider =
    NotifierProvider<ScreenshareNotifier, List<DyteMeetingParticipant>>(
        ScreenshareNotifier.new);

final selfScreenshareProvider = NotifierProvider<SelfScreenshareNotifier, bool>(
    SelfScreenshareNotifier.new);

final pluginProvider =
    NotifierProvider<PluginNotifer, List<DytePlugin>>(PluginNotifer.new);

final chatListNotifier =
    NotifierProvider<ChatListNotifier, List<DyteChatMessage>>(
  ChatListNotifier.new,
);

final unreadChatNotifier = NotifierProvider<UnreadChatNotifier, int>(
  UnreadChatNotifier.new,
);

final tabNotifierProvider =
    NotifierProvider<DyteTabNotifier, DyteSelectedTabParticipant>(
  DyteTabNotifier.new,
);

final recordingNotifier =
    NotifierProvider<RecordingNotifer, DyteRecordingState>(
        RecordingNotifer.new);
final waitingRoomNotifier =
    NotifierProvider<WaitingRoomNotifer, WaitlistedParticipantStates>(
        () => WaitingRoomNotifer());

final routerNotifier = NotifierProvider<RouterNotifier, RouterStates>(
  () => RouterNotifier(),
);

final newPollEventNotifier = NotifierProvider<NewPollNotifer, PollStates>(
  () => NewPollNotifer(),
);

final pollsListNotifier =
    NotifierProvider<PollListNotifier, List<DytePollMessage>>(
        PollListNotifier.new);

final unreadPollsNotifier = NotifierProvider<UnreadPollNotifier, int>(
  () => UnreadPollNotifier(),
);

final unreadWaitlistedCountNotifier =
    NotifierProvider<UnreadWaitlistedCountNotifier, int>(
  UnreadWaitlistedCountNotifier.new,
);

final unreadStageRequestCountNotifier =
    NotifierProvider<UnreadStageRequestsCountNotifier, int>(
  UnreadStageRequestsCountNotifier.new,
);

final meetingTimeProvider =
    AutoDisposeNotifierProvider<DyteMeetingNotifier, Duration?>(
  DyteMeetingNotifier.new,
  name: 'meetingTimeProvider',
);

final notificationProvider =
    NotifierProvider<DyteNotificationNotifier, NotificationState>(
  DyteNotificationNotifier.new,
  name: 'notificationProvider',
);

final editNameProvider = NotifierProvider<EditNameNotifier, String>(
    EditNameNotifier.new,
    name: 'editNameProvider');

final lvsStateNotifier =
    NotifierProvider<LvsStateNotifier, DyteLivestreamState>(
  LvsStateNotifier.new,
  name: 'lvsStateNotifier',
);

final stageStatusNotifier =
    NotifierProvider<StageStatusNotifier, DyteStageStatus>(
  StageStatusNotifier.new,
  name: 'stageStatusNotifier',
);

final stageRequestsNotifier =
    NotifierProvider<StageRequestsNotifier, List<DyteJoinedMeetingParticipant>>(
  StageRequestsNotifier.new,
  name: 'stageRequestsNotifier',
);

final stagePermissionNotifier =
    NotifierProvider<StagePermissionNotifier, DyteMediaPermission>(
  StagePermissionNotifier.new,
  name: 'stagePermissionNotifier',
);
