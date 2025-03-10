import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/states/notification_state.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/pages/room/grid/active_particpants_widget.dart';
import 'package:dyte_uikit/src/pages/room/grid/dyte_page_view_widget.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_app_bar.dart';
import 'package:dyte_uikit/src/widgets/molecules/control_bar/dyte_control_bars.dart';
import 'package:dyte_uikit/src/widgets/molecules/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const appbarHeight = 56.0;

class DyteGCMeetingRoom extends ConsumerWidget {
  const DyteGCMeetingRoom({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(notificationProvider, (previous, next) {
      if (next is OnNewNotificationReceived) {
        showSnackbarWidget(
          context,
          getNotificationContentForSnackbar(
              notification: next.notification, context: context),
        );
      }
    });

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: DyteAppBars.gc(),
        body: SafeArea(
          child: ref.watch(tabNotifierProvider).isEmpty ||
                  dyteMobileClient.meta.roomType == DyteRoomType.livestream
              ? const ActiveParticipantsWidget()
              : const DytePageViewWidget(),
        ),
        bottomNavigationBar: DyteControlBar.gc(),
      ),
    );
  }
}
