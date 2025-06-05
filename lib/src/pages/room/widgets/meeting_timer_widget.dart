import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DyteMeetingTimerWidget extends ConsumerWidget {
  final String remainingTime;
  const DyteMeetingTimerWidget({super.key, required this.remainingTime});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    final meetingDuration = ref.watch(meetingTimeProvider);
    if (meetingDuration != null) {
      // final hourCount = meetingDuration.inHours > 0
      //     ? "${meetingDuration.inHours.toString().padLeft(2, '0')}:"
      //     : "";
      return DyteText(
        remainingTime,
        // "$hourCount${meetingDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${meetingDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}",
        // meetingDuration.toString(),
        dyteTextStyle: theme.textTheme.bodyLarge,
      );
    } else {
      return DyteText(
        "",
        dyteTextStyle: theme.textTheme.bodyLarge,
      );
    }
  }
}
