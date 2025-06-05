import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/pages/room/grid/active_participants_widget.dart';
import 'package:dyte_uikit/src/pages/room/grid/dyte_page_view_widget.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/molecules/control_bar/dyte_control_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../dyte_uikit.dart';
import '../../../di/riverpod_di.dart';
import '../../../widgets/atoms/dyte_app_bar.dart';
import '../../../widgets/atoms/dyte_text.dart';
import '../../../widgets/atoms/dyte_text_button.dart';

class DyteLivestreamMeetingRoom extends ConsumerWidget {
  final Function()? onClose;

  final DyteAudioDevice? selectedAudioDevice;
  final DyteVideoDevice? selectedVideoDevice;

  const DyteLivestreamMeetingRoom(
      this.selectedAudioDevice, this.selectedVideoDevice,
      {super.key, required this.onClose});

  Widget _buildCancelButton(ThemeData theme, BuildContext context) {
    return DyteTextButton(
      label: "Cancel",
      labelStyle: theme.textTheme.bodyMedium!
          .copyWith(color: theme.colorScheme.onSecondary),
      variant: Variant.secondary,
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        dyteMobileClient.stage.withdrawJoinRequest();
      },
    );
  }

  Widget _buildJoinButton(ThemeData theme, BuildContext context) {
    return DyteTextButton(
      label: "Join",
      labelStyle: theme.textTheme.bodyMedium!
          .copyWith(color: theme.colorScheme.onSecondary),
      variant: Variant.danger,
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        dyteMobileClient.stage.join();
      },
    );
  }

  void showJoinStageAlertDialog(BuildContext context) {
    final ThemeData theme = AppTheme(globalDesignToken.colorToken).theme;
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: theme.colorScheme.primaryContainer,
      title: DyteText(
        "Join Stage",
        dyteTextStyle: theme.textTheme.headlineMedium!
            .copyWith(color: theme.colorScheme.onSecondary),
      ),
      actions: [
        _buildJoinButton(theme, context),
        _buildCancelButton(theme, context),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isOnStage = ref.watch(stageStatusNotifier
        .select((status) => status == DyteStageStatus.onStage));

    ref.listen(stageStatusNotifier, (previous, next) {
      if (next == DyteStageStatus.acceptedToJoinStage &&
          previous != DyteStageStatus.acceptedToJoinStage) {
        return showJoinStageAlertDialog(context);
      }
    });

    if (!isOnStage) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: DyteAppBars.lvs(),
          body: const SafeArea(child: ShowLivestreamWidget()),
          bottomNavigationBar: DyteControlBar.livestream(onClose: onClose),
        ),
      );
    } else {
      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: DyteAppBars.lvs(),
          body: SafeArea(
            child: ref.watch(tabNotifierProvider).isEmpty
                ? const ActiveParticipantsWidget()
                : const DytePageViewWidget(),
          ),
          bottomNavigationBar: DyteControlBar.livestream(onClose: onClose),
        ),
      );
    }
  }
}

class ShowLivestreamWidget extends ConsumerWidget {
  const ShowLivestreamWidget({super.key});

  Widget _getLvsWidget(ThemeData theme, DyteLivestreamStatus lvsState) {
    switch (lvsState) {
      case DyteLivestreamStatus.starting:
        return Center(
          child: DyteText(
            "Starting Livestream...",
            dyteTextStyle: theme.textTheme.bodyMedium,
          ),
        );
      case DyteLivestreamStatus.started:
        return Center(
            child: LivestreamView(dyteMobileClient.livestream.data.url!));
      case DyteLivestreamStatus.ending:
        return Center(
          child: DyteText(
            "Ending Livestream...",
            dyteTextStyle: theme.textTheme.bodyMedium,
          ),
        );
      case DyteLivestreamStatus.ended:
        return Center(
          child: DyteText(
            "${DyteStrings.waitingToGoLive}...",
            dyteTextStyle: theme.textTheme.bodyMedium,
          ),
        );

      case DyteLivestreamStatus.errored:
        return Center(
          child: DyteText(
            "Error while streaming livestream.",
            dyteTextStyle: theme.textTheme.bodyMedium,
          ),
        );
      case DyteLivestreamStatus.none:
        return Center(
          child: DyteText(
            "${DyteStrings.waitingToGoLive}...",
            dyteTextStyle: theme.textTheme.bodyMedium,
          ),
        );
      default:
        return Center(
          child: DyteText(
            "${DyteStrings.waitingToGoLive}...",
            dyteTextStyle: theme.textTheme.bodyMedium,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lvsState = ref.watch(lvsStateNotifier
        .select((value) => dyteMobileClient.livestream.data.state));
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return _getLvsWidget(theme, lvsState);
  }
}
