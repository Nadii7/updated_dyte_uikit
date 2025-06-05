import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/molecules/control_bar/dyte_control_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../dyte_uikit.dart';
import '../../../di/riverpod_di.dart';
import '../../../widgets/atoms/dyte_app_bar.dart';
import '../../../widgets/atoms/dyte_text.dart';
import '../../../widgets/atoms/dyte_text_button.dart';
import '../grid/active_participants_widget.dart';
import '../grid/dyte_page_view_widget.dart';

class DyteWebinarMeetingRoom extends ConsumerWidget {
  final Function()? onClose;

  final DyteAudioDevice? selectedAudioDevice;
  final DyteVideoDevice? selectedVideoDevice;

  const DyteWebinarMeetingRoom(
      this.selectedAudioDevice, this.selectedVideoDevice,
      {super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to stage request updates
    ref.listen(stageStatusNotifier, (previous, next) {
      if (next == DyteStageStatus.acceptedToJoinStage &&
          previous != DyteStageStatus.acceptedToJoinStage) {
        void showJoinStageAlertDialog(BuildContext ctx) {
          final theme = AppTheme(globalDesignToken.colorToken).theme;
          // set up the button
          Widget joinButton = DyteTextButton(
            label: "Join",
            labelStyle: theme.textTheme.bodyMedium!
                .copyWith(color: theme.colorScheme.onSecondary),
            variant: Variant.danger,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              dyteMobileClient.stage.join();
            },
          );

          Widget cancelButton = DyteTextButton(
            label: "Cancel",
            labelStyle: theme.textTheme.bodyMedium!
                .copyWith(color: theme.colorScheme.onSecondary),
            variant: Variant.secondary,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              dyteMobileClient.stage.withdrawJoinRequest();
            },
          );
          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            backgroundColor: theme.colorScheme.primaryContainer,
            title: DyteText(
              "Join Stage",
              dyteTextStyle: theme.textTheme.headlineMedium!
                  .copyWith(color: theme.colorScheme.onSecondary),
            ),
            actions: [
              cancelButton,
              joinButton,
            ],
            actionsAlignment: MainAxisAlignment.center,
          );

          // show the dialog
          showDialog(
            context: ctx,
            barrierDismissible: false,
            builder: (BuildContext ctx) {
              return alert;
            },
          );
        }

        return showJoinStageAlertDialog(context);
      }
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: DyteAppBars.webinar(),
        body: SafeArea(
          child: ref.watch(tabNotifierProvider).isEmpty
              ? const ActiveParticipantsWidget()
              : const DytePageViewWidget(),
        ),
        bottomNavigationBar: DyteControlBar.webinar(onClose: onClose),
      ),
    );
  }
}
