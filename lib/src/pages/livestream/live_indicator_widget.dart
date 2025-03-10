import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/states/livestream_states.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/tokens/color/status_color.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LiveIndicatorWidget extends ConsumerWidget {
  const LiveIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(lvsStateNotifier.select(
        (value) => value is OnLivestreamStarted || value is OnLivestreamEnded));
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return dyteMobileClient.livestream.data.state ==
            DyteLivestreamStatus.started
        ? Row(
            children: [
              const Icon(
                DyteIcons.start_livestream,
                color: Colors.red,
              ),
              hspace1,
              DyteText(
                "LIVE",
                dyteTextStyle: theme.textTheme.bodyMedium!
                    .copyWith(color: StatusColor.error),
              )
            ],
          )
        : const SizedBox.shrink();
  }
}
