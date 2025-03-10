import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../atoms/dyte_text.dart';

class GoLiveButtonWidget extends ConsumerWidget {
  const GoLiveButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lvsState = ref.watch(lvsStateNotifier
        .select((value) => dyteMobileClient.livestream.data.state));

    return DyteListTile(
      leading: (lvsState == DyteLivestreamStatus.started ||
              lvsState == DyteLivestreamStatus.ended ||
              lvsState == DyteLivestreamStatus.none)
          ? Icon(lvsState == DyteLivestreamStatus.ended ||
                  lvsState == DyteLivestreamStatus.none
              ? DyteIcons.start_livestream
              : DyteIcons.stop_livestream)
          : const CircularProgressIndicator(),
      iconColor: lvsState == DyteLivestreamStatus.started
          ? AppTheme(globalDesignToken.colorToken).theme.colorScheme.error
          : null,
      title: DyteText(
        lvsState == DyteLivestreamStatus.started
            ? "Stop Live"
            : lvsState == DyteLivestreamStatus.ended ||
                    lvsState == DyteLivestreamStatus.none
                ? "Go Live"
                : lvsState == DyteLivestreamStatus.starting
                    ? "Starting Livestream"
                    : "Stopping Livestream",
      ),
      onTap: lvsState == DyteLivestreamStatus.started
          ? dyteMobileClient.livestream.stop
          : lvsState == DyteLivestreamStatus.ended ||
                  lvsState == DyteLivestreamStatus.none
              ? dyteMobileClient.livestream.start
              : null,
    );
  }
}
