import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_bottom_nav_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DyteStageRequestButton extends ConsumerWidget {
  // final DyteMediaPermission stagePermission;
  const DyteStageRequestButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagePermission = ref.read(stagePermissionNotifier);
    final stageStatus = ref.watch(stageStatusNotifier);
    final isRequestAllowed =
        ref.read(stagePermissionNotifier) != DyteMediaPermission.notAllowed;
    return isRequestAllowed
        ? DyteBottomNavButton(
            icon: stageStatus == DyteStageStatus.offStage ||
                    stageStatus == DyteStageStatus.requestedToJoinStage
                ? const Icon(DyteIcons.join_stage)
                : const Icon(DyteIcons.leave_stage),
            label: stageStatus == DyteStageStatus.offStage
                ? "Join Stage"
                : stageStatus == DyteStageStatus.requestedToJoinStage ||
                        stageStatus == DyteStageStatus.acceptedToJoinStage
                    ? "Requested"
                    : "Leave Stage",
            onTap: () {
              if (stagePermission == DyteMediaPermission.canRequest) {
                switch (stageStatus) {
                  case DyteStageStatus.offStage:
                    dyteMobileClient.stage.requestAccess();
                    break;
                  case DyteStageStatus.onStage:
                    dyteMobileClient.stage.leave();
                    break;
                  default:
                    dyteMobileClient.stage.withdrawJoinRequest();
                    break;
                }
              }
              if (stagePermission == DyteMediaPermission.allowed) {
                switch (stageStatus) {
                  case DyteStageStatus.offStage:
                    dyteMobileClient.stage.join();
                    break;
                  case DyteStageStatus.onStage:
                    dyteMobileClient.stage.leave();
                    break;
                  default:
                    break;
                }
              }
            })
        : const SizedBox.shrink();
  }
}
