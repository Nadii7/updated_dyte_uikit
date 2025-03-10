import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/notifiers/pin_unpin_notifier.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/pages/participants/widgets/host_options.dart';
import 'package:dyte_uikit/src/pages/participants/widgets/video_icon_widget.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_app_bar.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_icon_button.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_list_tile.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text_button.dart';
import 'package:dyte_uikit/src/widgets/participant_tile/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/notifiers/audio_notifier.dart';
import '../../data/notifiers/video_notifier.dart';
import '../../di/riverpod_di.dart';
import '../../routes/router.dart';
import '../../utils/generate_key.dart';
import '../../widgets/atoms/dyte_button.dart';

class DyteParticipantsPage extends ConsumerWidget {
  const DyteParticipantsPage({super.key});

  List<Widget> _addPresetHostActions(
      DytePermissions permissions, DyteJoinedMeetingParticipant participant) {
    List<Widget> hostActions = [];
    if (permissions.host.canPinParticipant) {
      hostActions.add(PinningToggler(participant: participant));
    }

    if (permissions.host.canDisableVideo) {
      hostActions.add(DisableVideoControllerWidget(participant: participant));
    }

    if (permissions.host.canMuteAudio) {
      hostActions.add(DisableAudioControllerWidget(participant: participant));
    }

    if (permissions.host.canKickParticipant &&
        participant.id != dyteMobileClient.localUser.id) {
      hostActions.add(KickParticipantController(participant: participant));
      if (dyteMobileClient.meta.roomType != DyteRoomType.groupCall) {
        hostActions
            .add(RemoveStageParticipantController(participant: participant));
      }
    }
    // only insert name tile when user has some host actions else return empty list
    if (hostActions.isNotEmpty) {
      final nameTile = DyteListTile(
        title: DyteText(
          participant.name,
          textAlign: TextAlign.center,
        ),
      );
      hostActions.insert(0, nameTile);
    }

    return hostActions;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;

    late List<DyteJoinedMeetingParticipant> activeParticipants;
    late List<DyteJoinedMeetingParticipant> viewerParticipants;
    late List<DyteJoinedMeetingParticipant> inCallParticipants;
    late List<DyteMeetingParticipant> waitlistedParticipants;

    return Scaffold(
      appBar: DyteAppBar(
        title: DyteText(DyteStrings.participants),
        leadingIcon: const Icon(DyteIcons.dismiss),
        onPressed: () => DyteRouter.of(context).pop(),
      ),
      body: SafeArea(
          child: SizedBox(
        height: context.height,
        child: StreamBuilder(
          initialData: dyteMobileClient.participants,
          stream: dyteMobileClient.participantsStream,
          builder: (context, snapshot) {
            activeParticipants = snapshot.data!.active;
            if (snapshot.hasData) {
              waitlistedParticipants = snapshot.data!.waitlisted;
              if (dyteMobileClient.meta.roomType == DyteRoomType.groupCall) {
                inCallParticipants = snapshot.data!.joined;
              }
              if (dyteMobileClient.meta.roomType == DyteRoomType.webinar) {
                viewerParticipants = snapshot.data!.joined;
                viewerParticipants.removeWhere(
                  (p) => activeParticipants
                      .any((active) => active.userId == p.userId),
                );
              }
            } else {
              waitlistedParticipants = [];
              inCallParticipants = [];
            }

            return ListView(
              children: [
                if (waitlistedParticipants.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(
                      top: context.adjust(20),
                      bottom: context.adjust(12),
                    ),
                    child: DyteText(
                      "Waitlisted (${waitlistedParticipants.length})",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ...waitlistedParticipants
                    .map(
                      (waitlistedParticipant) => DyteListTile(
                        title: DyteText(
                          waitlistedParticipant.name,
                        ),
                        tileColor: theme.colorScheme.background,
                        leading: Avatar(
                          participant: waitlistedParticipant,
                          height: 32,
                          width: 32,
                          textStyle: theme.textTheme.bodyMedium,
                        ),
                        trailing: SizedBox(
                          width: context.width * 0.4,
                          child: Row(
                            children: [
                              const Spacer(),
                              DyteIconButton(
                                icon: const Icon(
                                  DyteIcons.dismiss,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  dyteMobileClient.hostActions
                                      .rejectWaitlistedParticipant(
                                          waitlistedParticipant);
                                },
                              ),
                              SizedBox(
                                width: context.adjust(8),
                              ),
                              DyteIconButton(
                                icon: Icon(
                                  DyteIcons.checkmark,
                                  color: Colors.green[800],
                                ),
                                onPressed: () {
                                  dyteMobileClient.hostActions
                                      .acceptWaitlistedParticipant(
                                          waitlistedParticipant);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                if (waitlistedParticipants.length > 1)
                  DyteTextButton(
                    onPressed: () {
                      for (DyteMeetingParticipant wParticipant
                          in waitlistedParticipants) {
                        dyteMobileClient.hostActions
                            .acceptWaitlistedParticipant(wParticipant);
                      }
                    },
                    label: "Accept all",
                  ),
                if (ref.watch(stageRequestsNotifier).isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(
                      top: context.adjust(20),
                      bottom: context.adjust(12),
                    ),
                    child: DyteText(
                      "Stage Requests (${dyteMobileClient.stage.accessRequests.length})",
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (ref.watch(stageRequestsNotifier).isNotEmpty)
                  ...dyteMobileClient.stage.accessRequests
                      .map(
                        (requesPar) => DyteListTile(
                            title: DyteText(
                              requesPar.name,
                            ),
                            tileColor: theme.colorScheme.background,
                            trailing: SizedBox(
                              width: context.width * 0.4,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  DyteIconButton(
                                    icon: const Icon(
                                      DyteIcons.dismiss,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      dyteMobileClient.stage
                                          .denyAccess(requesPar);
                                    },
                                  ),
                                  SizedBox(
                                    width: context.adjust(8),
                                  ),
                                  DyteIconButton(
                                      icon: Icon(
                                        DyteIcons.checkmark,
                                        color: Colors.green[800],
                                      ),
                                      onPressed: () {
                                        dyteMobileClient.stage
                                            .grantAccess(requesPar);
                                      }),
                                ],
                              ),
                            )
                            // : Container(),
                            ),
                      )
                      .toList(),
                if (dyteMobileClient.stage.accessRequests.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DyteButton(
                        onPressed: dyteMobileClient.stage.grantAccessToAll,
                        backgroundColor: AppTheme(globalDesignToken.colorToken)
                            .theme
                            .colorScheme
                            .tertiary,
                        child: const DyteText("Accept all"),
                      ),
                      DyteButton(
                        onPressed: dyteMobileClient.stage.denyAccessToAll,
                        backgroundColor: AppTheme(globalDesignToken.colorToken)
                            .theme
                            .colorScheme
                            .error,
                        child: const DyteText("Deny all"),
                      )
                    ],
                  ),
                Container(
                  margin: EdgeInsets.only(
                    top: context.adjust(20),
                    bottom: context.adjust(12),
                  ),
                  child: DyteText(
                    "${DyteStrings.participants} (${(dyteMobileClient.meta.roomType == DyteRoomType.groupCall ? inCallParticipants : activeParticipants).length})",
                    textAlign: TextAlign.center,
                  ),
                ),
                ...(dyteMobileClient.meta.roomType == DyteRoomType.groupCall
                        ? inCallParticipants
                        : activeParticipants)
                    .map(
                  (participant) => DyteListTile(
                    title: DyteText(
                      dyteMobileClient.localUser.id == participant.id
                          ? "${participant.name} (${DyteStrings.you})"
                          : participant.name,
                    ),
                    tileColor: theme.colorScheme.background,
                    leading: Avatar(
                      participant: participant,
                      height: 32,
                      width: 32,
                      textStyle: theme.textTheme.bodyMedium,
                    ),
                    trailing: SizedBox(
                      width: context.width * 0.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DyteAudioIndicatorIconWidget(
                              participant: participant),
                          VideoIcon(participant: participant),
                          // Show icon button only if user has some host powers
                          if (_addPresetHostActions(
                                  dyteMobileClient.permissions, participant)
                              .isNotEmpty)
                            DyteIconButton(
                              icon: const Icon(DyteIcons.more_vertical),
                              backgroundColor: theme.colorScheme.background,
                              onPressed: () => showModalBottomSheet(
                                context: context,
                                builder: (ctx) => HostOptionsWidget(
                                  participant: participant,
                                  hostActions: _addPresetHostActions(
                                    dyteMobileClient.permissions,
                                    participant,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (dyteMobileClient.meta.roomType == DyteRoomType.webinar)
                  Container(
                    margin: EdgeInsets.only(
                      top: context.adjust(20),
                      bottom: context.adjust(12),
                    ),
                    child: DyteText(
                      "Viewers (${viewerParticipants.length})",
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (dyteMobileClient.meta.roomType == DyteRoomType.webinar)
                  ...viewerParticipants.map(
                    (viewer) => DyteListTile(
                      title: DyteText(
                        dyteMobileClient.localUser.id == viewer.id
                            ? "${viewer.name} (${DyteStrings.you})"
                            : viewer.name,
                      ),
                      tileColor: theme.colorScheme.background,
                      leading: Avatar(
                        participant: viewer,
                        height: 32,
                        width: 32,
                        textStyle: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      )),
    );
  }

  bool isHostPermissionAvailable(DytePermissions permissions) =>
      permissions.host.canDisableVideo ||
      permissions.host.canMuteAudio ||
      permissions.host.canPinParticipant ||
      permissions.host.canKickParticipant;
}

class DisableVideoControllerWidget extends ConsumerStatefulWidget {
  final DyteMeetingParticipant participant;
  const DisableVideoControllerWidget({
    super.key,
    required this.participant,
  });

  @override
  ConsumerState<DisableVideoControllerWidget> createState() =>
      _DisableVideoControllerWidgetState();
}

class _DisableVideoControllerWidgetState
    extends ConsumerState<DisableVideoControllerWidget> {
  late final VideoNotifier videoNotifier;
  @override
  void initState() {
    videoNotifier = VideoNotifier(widget.participant);
    dyteMobileClient.addParticipantEventsListener(videoNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: videoNotifier,
      builder: (context, bool videoEnabled, child) => DyteListTile(
        leading: Icon(videoEnabled ? DyteIcons.video_on : DyteIcons.video_off),
        key: generateVideoKeyForParticipant(widget.participant,
            pageName: 'VideoIcon'),
        title: DyteText(videoEnabled
            ? DyteStrings.turnOffVideo
            : DyteStrings.videoAlreadyOff),
        iconColor: videoEnabled
            ? AppTheme(globalDesignToken.colorToken).theme.colorScheme.onPrimary
            : AppTheme(globalDesignToken.colorToken).theme.colorScheme.error,
        onTap: () {
          if (videoEnabled) {
            dyteMobileClient.hostActions
                .disableParticipantVideo(widget.participant);
            DyteRouter.of(context).pop();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    dyteMobileClient.removeParticipantEventsListener(videoNotifier);
    super.dispose();
  }
}

class DisableAudioControllerWidget extends ConsumerStatefulWidget {
  final DyteMeetingParticipant participant;
  const DisableAudioControllerWidget({
    super.key,
    required this.participant,
  });

  @override
  ConsumerState<DisableAudioControllerWidget> createState() =>
      _DisableAudioControllerWidgetState();
}

class _DisableAudioControllerWidgetState
    extends ConsumerState<DisableAudioControllerWidget> {
  late final AudioNotifier audioNotifier;

  @override
  void initState() {
    audioNotifier = AudioNotifier(widget.participant);
    dyteMobileClient.addParticipantEventsListener(audioNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return ValueListenableBuilder(
      valueListenable: audioNotifier,
      builder: (context, bool audioEnabled, child) => DyteListTile(
        key: generateAudioKeyForParticipant(widget.participant,
            pageName: 'AudioIcon'),
        leading: Icon(audioEnabled ? DyteIcons.mic_on : DyteIcons.mic_off),
        title: DyteText(audioEnabled ? DyteStrings.mute : DyteStrings.unmute),
        iconColor: audioEnabled
            ? theme.colorScheme.onSecondary
            : theme.colorScheme.error,
        onTap: () {
          if (audioEnabled) {
            dyteMobileClient.hostActions
                .disableParticipantAudio(widget.participant);
            DyteRouter.of(context).pop();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    dyteMobileClient.removeParticipantEventsListener(audioNotifier);
    super.dispose();
  }
}

class PinningToggler extends StatefulWidget {
  final DyteMeetingParticipant participant;
  const PinningToggler({
    super.key,
    required this.participant,
  });

  @override
  State<PinningToggler> createState() => _PinningTogglerState();
}

class _PinningTogglerState extends State<PinningToggler> {
  bool checkPinned(DyteMeetingParticipant pinnedParticipant) =>
      pinnedParticipant.id == widget.participant.id;

  late PinNotifier? _pinNotifier;

  @override
  void initState() {
    _pinNotifier = PinNotifier();
    dyteMobileClient.addParticipantEventsListener(_pinNotifier!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _pinNotifier!,
      builder: (context, pinnedParticipant, child) {
        final isPinned =
            pinnedParticipant != null ? checkPinned(pinnedParticipant) : false;
        return DyteListTile(
          title: DyteText(isPinned ? DyteStrings.unpin : DyteStrings.pin),
          leading: isPinned
              ? const Icon(DyteIcons.pin_off)
              : const Icon(DyteIcons.pin),
          onTap: () {
            isPinned
                ? dyteMobileClient.hostActions.unpinParticipant()
                : dyteMobileClient.hostActions
                    .pinParticipant(widget.participant);
            DyteRouter.of(context).pop();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    if (_pinNotifier != null) {
      dyteMobileClient.removeParticipantEventsListener(_pinNotifier!);
      _pinNotifier = null;
    }
    super.dispose();
  }
}

class KickParticipantController extends ConsumerWidget {
  final DyteMeetingParticipant participant;
  const KickParticipantController({
    super.key,
    required this.participant,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DyteListTile(
      leading: const Icon(Icons.person_off_outlined),
      iconColor: AppTheme(globalDesignToken.colorToken).theme.colorScheme.error,
      title: DyteText(DyteStrings.kick),
      onTap: () {
        dyteMobileClient.hostActions.kickParticipant(participant);
        DyteRouter.of(context).pop();
      },
    );
  }
}

class RemoveStageParticipantController extends ConsumerWidget {
  final DyteJoinedMeetingParticipant participant;
  const RemoveStageParticipantController({
    super.key,
    required this.participant,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DyteListTile(
      leading: const Icon(DyteIcons.leave_stage),
      iconColor: AppTheme(globalDesignToken.colorToken).theme.colorScheme.error,
      title: DyteText(DyteStrings.removeFromStage),
      onTap: () {
        dyteMobileClient.stage.kick(participant);
        DyteRouter.of(context).pop();
      },
    );
  }
}
