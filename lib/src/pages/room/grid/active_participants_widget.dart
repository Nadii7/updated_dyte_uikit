import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/data/models/notification.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/utils/generate_key.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:dyte_uikit/src/widgets/molecules/snackbar.dart';
import 'package:dyte_uikit/src/widgets/participant_tile/dyte_participant_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/states/whitelisted_participant_states.dart';
import 'dyte_regular_tile_grid_delegate.dart';

class ActiveParticipantsWidget extends ConsumerStatefulWidget {
  const ActiveParticipantsWidget({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _ActiveParticipantsGridState();
}

class _ActiveParticipantsGridState
    extends ConsumerState<ActiveParticipantsWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ref.listen(
      waitingRoomNotifier,
      (previous, next) {
        switch (next.runtimeType) {
          case WaitlistedParticipantAccepted:
            final participant =
                (next as WaitlistedParticipantAccepted).participant;
            getNotificationContentForSnackbar(
              context: context,
              notification: DyteNotification(
                  '${participant.name}\'s has joined the meeting.',
                  NotificationType.participant),
            );
            break;
          case WaitlistedParticipantRejected:
            final participant =
                (next as WaitlistedParticipantRejected).participant;
            getNotificationContentForSnackbar(
              context: context,
              notification: DyteNotification(
                  '${participant.name}\'s request has been rejected.',
                  NotificationType.participant),
            );
            break;
          case WaitlistedParticipantJoined:
            final participant =
                (next as WaitlistedParticipantJoined).participant;
            getNotificationContentForSnackbar(
              context: context,
              notification: DyteNotification(
                  '${participant.name}\'s is in the waiting room.',
                  NotificationType.participant),
            );
            break;
          case WaitlistedParticipantClosed:
            final participant =
                (next as WaitlistedParticipantClosed).participant;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${participant.name} has closed the meeting.'),
            ));
            break;
          default:
            break;
        }
      },
    );

    return StreamBuilder<List<DyteMeetingParticipant>>(
      stream: dyteMobileClient.activeStream.distinct(
        (previous, next) =>
            previous.length == next.length &&
            previous.map((e) => e.id).toSet().containsAll(
                  next.map((e) => e.id).toSet(),
                ),
      ),
      initialData: dyteMobileClient.participants.active,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data != null) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  data.isEmpty
                      ? const Text("There is no one on stage.")
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: context.height * 0.6,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: DyteRegularTileGridDelegate(
                                activeParticipantCount: data.length,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                context: context,
                              ),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final participant = data[index];
                                return data.length == 1
                                    ? AspectRatio(
                                        aspectRatio: 4 / 3,
                                        child: DyteParticipantTile(
                                          participant,
                                          key: generateKeyForParticipant(
                                            participant,
                                          ),
                                        ),
                                      )
                                    : DyteParticipantTile(
                                        participant,
                                        key: generateKeyForParticipant(
                                          participant,
                                        ),
                                      );
                              },
                            ),
                          ),
                        ),
                  vspace1,
                  DytePageToggler(data: data),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class DytePageToggler extends ConsumerWidget {
  final List<DyteMeetingParticipant> data;
  const DytePageToggler({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (dyteMobileClient.meta.roomType == DyteRoomType.groupCall &&
        data.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: ref.watch(gridNotifier).isPreviousPagePossible
                ? ref.read(gridNotifier.notifier).previousPage
                : null,
            icon: const Icon(
              DyteIcons.chevron_left,
            ),
          ),
          hspace1,
          IconButton(
            onPressed: ref.watch(gridNotifier).isNextPagePossible
                ? ref.read(gridNotifier.notifier).nextPage
                : null,
            icon: const Icon(
              DyteIcons.chevron_right,
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
