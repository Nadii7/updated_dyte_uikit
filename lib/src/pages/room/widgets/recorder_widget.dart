import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/data/states/local_user_states.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecorderWidget extends ConsumerWidget {
  const RecorderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    final recordingState = ref.watch(recordingNotifier);
    ref.watch(
        localUserSettingsProvider.select((value) => value is OnVideoUpdate));

    final recWid = Padding(
      padding: ref.read(localUserSettingsProvider.notifier).isVideoEnabled
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: hspace4.width!),
      child: Row(
        children: [
          if (recordingState == DyteRecordingState.recording) ...[
            Icon(
              DyteIcons.recording,
              size: context.adjust(10),
              color: theme.colorScheme.error,
            ),
            SizedBox(width: context.adjust(5)),
            DyteText(
              DyteStrings.rec,
              dyteTextStyle: theme.textTheme.bodyMedium!
                  .copyWith(color: theme.colorScheme.error),
            ),
          ],
        ],
      ),
    );

    return recWid;
  }
}
