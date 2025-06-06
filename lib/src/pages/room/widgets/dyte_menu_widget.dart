import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/pages/chats/chats_page.dart';
import 'package:dyte_uikit/src/pages/participants/participants_page.dart';
import 'package:dyte_uikit/src/pages/plugins/plugin_page.dart';
import 'package:dyte_uikit/src/routes/route_names.dart';
import 'package:dyte_uikit/src/routes/router.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_list_tile.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:dyte_uikit/src/widgets/molecules/more_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/molecules/go_live_button_widget.dart';
import '../../polls/polls_screen.dart';
import '../../setup/settings_page.dart';

class DyteMenuWidget extends ConsumerWidget {
  final bool canLivestream;
  final String remainingTime;
  const DyteMenuWidget({
    super.key,
    this.canLivestream = false,
    required this.remainingTime,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    final hostPermissions = dyteMobileClient.permissions.host;

    final muteAllAudios = DyteListTile(
      leading: const Icon(DyteIcons.speaker_off),
      title: DyteText(
        DyteStrings.muteAll,
      ),
      onTap: () {
        DyteRouter.of(context).pop();
        dyteMobileClient.hostActions.muteAllAudios();
      },
    );

    final List<Widget> options = [
      if (dyteMobileClient.permissions.poll.canView)
        DyteListTile(
          title: DyteText(DyteStrings.polls),
          leading: const Icon(DyteIcons.poll),
          trailing: UnreadCountWidget(unreadNotitifers: [unreadPollsNotifier]),
          onTap: () {
            DyteRouter.of(context).pop();
            DyteRouter.of(context).push(
              pageName: RouteNames.polls,
              DytePollsScreen(remainingTime: remainingTime),
            );
            ref.read(unreadPollsNotifier.notifier).markAllAsRead(
                  ref.read(pollsListNotifier).length,
                );
          },
        ),
      if (dyteMobileClient.permissions.chat.canSend)
        DyteListTile(
          leading: const Icon(DyteIcons.chat),
          title: DyteText(DyteStrings.chat),
          onTap: () {
            DyteRouter.of(context).pop();
            ref.read(unreadChatNotifier.notifier).readAllMessages(
                  ref.read(chatListNotifier).length,
                );
            DyteRouter.of(context).push(
              pageName: RouteNames.chats,
              ChatsPage(remainingTime: remainingTime),
            );
          },
          trailing: UnreadCountWidget(
            unreadNotitifers: [unreadChatNotifier],
          ),
        ),
      DyteListTile(
        leading: const Icon(DyteIcons.participants),
        title: DyteText(DyteStrings.participants),
        onTap: () {
          DyteRouter.of(context).pop();
          DyteRouter.of(context).push(
            pageName: RouteNames.participants,
            DyteParticipantsPage(remainingTime: remainingTime),
          );
        },
        trailing: UnreadCountWidget(
          unreadNotitifers: [
            unreadStageRequestCountNotifier,
            unreadWaitlistedCountNotifier
          ],
        ),
      ),
      if (hostPermissions.canTriggerRecording) const RecorderButton(),
      if (dyteMobileClient.permissions.plugin.canLaunch ||
          dyteMobileClient.permissions.plugin.canClose)
        DyteListTile(
          leading: const Icon(
            DyteIcons.rocket,
          ),
          title: DyteText(DyteStrings.plugins),
          onTap: () {
            DyteRouter.of(context).pop();
            DyteRouter.of(context).push(
              DytePluginsScreen(remainingTime: remainingTime),
            );
          },
        ),
      if (hostPermissions.canMuteAudio) muteAllAudios,
      if (canLivestream) const GoLiveButtonWidget(),
      DyteListTile(
        leading: const Icon(
          DyteIcons.settings,
        ),
        title: DyteText(DyteStrings.settings),
        onTap: () {
          DyteRouter.of(context).pop();
          DyteRouter.of(context).push(
            SetupSettingsPage(remainingTime: remainingTime),
            pageName: RouteNames.settings,
          );
        },
      ),
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: hspace1.width!),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            borderToken.getRadius(BorderSize.two),
          ),
          topRight: Radius.circular(
            borderToken.getRadius(BorderSize.two),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options,
        ),
      ),
    );
  }
}

class RecorderButton extends ConsumerWidget {
  const RecorderButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(recordingNotifier) == DyteRecordingState.recording
        ? DyteListTile(
            leading: const Icon(
              DyteIcons.stop_recording,
            ),
            title: DyteText(DyteStrings.stopRecording),
            onTap: () {
              dyteMobileClient.recording.stop();
              DyteRouter.of(context).pop();
            },
          )
        : DyteListTile(
            leading: const Icon(
              DyteIcons.recording,
            ),
            title: DyteText(DyteStrings.startRecording),
            onTap: () {
              dyteMobileClient.recording.start();
              DyteRouter.of(context).pop();
            },
          );
  }
}
