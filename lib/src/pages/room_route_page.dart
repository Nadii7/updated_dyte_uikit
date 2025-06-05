import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/states/router_states.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/pages/exception_page.dart';
import 'package:dyte_uikit/src/pages/room/meetingRooms/gc_meeting_room.dart';
import 'package:dyte_uikit/src/pages/room/meetingRooms/livestream_meeting_room.dart';
import 'package:dyte_uikit/src/pages/room/meetingRooms/webinar_meeting_room.dart';
import 'package:dyte_uikit/src/pages/waiting_room_page.dart';
import 'package:dyte_uikit/src/routes/route_names.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:dyte_uikit/src/widgets/utils/clean_pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

class RoomRoutePage extends ConsumerStatefulWidget {
  final Function()? onClose;

  const RoomRoutePage({
    super.key,
    required this.onClose,
  });

  @override
  ConsumerState<RoomRoutePage> createState() => _RoomRoutePageState();
}

class _RoomRoutePageState extends ConsumerState<RoomRoutePage> {
  DyteAudioDevice? selectedAudioDevice;
  DyteVideoDevice? selectedVideoDevice;

  @override
  Widget build(BuildContext context) {
    ref.listen(routerNotifier, (previous, next) async {
      switch (next.runtimeType) {
        case OnRouterMeetingInitStarted:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoadingScreen(),
            ),
          );
          break;
        case OnRouterMeetingInitCompleted:
          rootBundle
              .loadString(
            "packages/dyte_uikit/pubspec.yaml",
          )
              .then((value) {
            final pubspec = Pubspec.parse(value);

            dyteMobileClient.setSdkInfo(
                pubspec.name, pubspec.version?.canonicalizedVersion ?? '');
          });
          dyteMobileClient.localUser
              .getSelectedAudioDevice()
              .then((audioDevice) {
                selectedAudioDevice = audioDevice;
                if ((audioDevice == null ||
                        !dyteMobileClient.localUser.permissions
                            .isMicrophonePermissionGranted) &&
                    dyteMobileClient.localUser.audioEnabled) {
                  dyteMobileClient.localUser.disableAudio();
                }
              })
              .then((_) => dyteMobileClient.localUser
                      .getSelectedVideoDevice()
                      .then((videoDevice) {
                    selectedVideoDevice = videoDevice;
                    if ((videoDevice == null ||
                            !dyteMobileClient.localUser.permissions
                                .isCameraPermissionGranted) &&
                        dyteMobileClient.localUser.videoEnabled) {
                      dyteMobileClient.localUser.disableVideo();
                    }
                  }))
              .then(
                (_) async {
                  if (dyteConfig.skipSetupScreen) {
                    dyteMobileClient.joinRoom();
                  } else {
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DyteSetupScreen(
                            selectedAudioDevice, selectedVideoDevice),
                        settings: RouteSettings(name: RouteNames.setup),
                      ),
                    );
                  }
                },
              );
          break;
        case OnRouterMeetingInitFailed:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExceptionPage(
                  (next as OnRouterMeetingInitFailed).error as DyteError),
              settings: RouteSettings(name: RouteNames.exception),
            ),
          );
          break;
        case OnRouterMeetingRoomJoinStarted:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoadingScreen(),
            ),
          );
          break;
        case OnRouterMeetingRoomJoinCompleted:
          switch (dyteMobileClient.meta.roomType) {
            case DyteRoomType.groupCall:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DyteGCMeetingRoom(
                    onClose: widget.onClose,
                  ),
                  settings: RouteSettings(name: RouteNames.meeting),
                ),
              );
              break;
            case DyteRoomType.webinar:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DyteWebinarMeetingRoom(
                      onClose: widget.onClose,
                      selectedAudioDevice,
                      selectedVideoDevice),
                  settings: RouteSettings(name: RouteNames.meeting),
                ),
              );
              break;
            case DyteRoomType.livestream:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DyteLivestreamMeetingRoom(
                      onClose: widget.onClose,
                      selectedAudioDevice,
                      selectedVideoDevice),
                  settings: RouteSettings(name: RouteNames.meeting),
                ),
              );
              break;
          }
          break;

        case OnRouterMeetingRoomJoinFailed:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExceptionPage(
                (next as OnRouterMeetingRoomJoinFailed).error as DyteError,
              ),
              settings: RouteSettings(name: RouteNames.exception),
            ),
          );
          break;
        case OnRouterMeetingRoomLeaveCompleted:
          await DyteUtils(context).leave(ref);
          break;

        case OnRouterSelfWaitingRoomStatusUpdate:
          switch (
              (next as OnRouterSelfWaitingRoomStatusUpdate).waitListStatus) {
            case DyteWaitListStatus.waiting:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const WaitingRoomPage(),
                  settings: RouteSettings(name: RouteNames.waitingRoom),
                ),
              );
              break;
            case DyteWaitListStatus.rejected:
              DyteUtils(context).leave(ref, release: true);
              break;
            default:
              break;
          }
          break;
        case OnRouterMeetingRoomDisconnected:
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: RouteSettings(name: RouteNames.exception),
              builder: (context) => ExceptionPage(
                DyteError('You have been disconnected from the meeting.'),
              ),
            ),
          );
          break;

        case OnRouterMeetingRoomReconnecting:
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.transparent,
            builder: (ctx) {
              return const ReconnectionNotificationWidget();
            },
          );
          break;

        case OnRouterMeetingRoomReconnected:
          Navigator.of(context, rootNavigator: true).pop();
          break;

        case OnRouterMeetingRoomReconnectionFailed:
          Navigator.of(context, rootNavigator: true).pop();
          break;

        case OnRouterMeetingEnded:
          await DyteUtils(context).leave(ref, release: true);
          break;

        case OnRouterRemovedFromMeeting:
          await DyteUtils(context).leave(ref, release: true);
          break;
      }
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      dyteMobileClient.init(meetingInfo);
    }
  }
}

class ReconnectionNotificationWidget extends ConsumerStatefulWidget {
  const ReconnectionNotificationWidget({super.key});

  @override
  ConsumerState<ReconnectionNotificationWidget> createState() =>
      _ReconnectionNotificationWidgetState();
}

class _ReconnectionNotificationWidgetState
    extends ConsumerState<ReconnectionNotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColorSwatch.shade800,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: hspace2.width!, vertical: vspace2.height!),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: context.adjust(20),
              child: const CircularProgressIndicator.adaptive(),
            ),
            SizedBox(width: context.adjust(10)),
            const DyteText('Reconnecting to the meeting'),
          ],
        ),
      ),
    );
  }
}
