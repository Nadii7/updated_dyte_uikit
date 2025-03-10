import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/riverpod_di.dart';

class LiveViewerCountWidget extends ConsumerWidget {
  const LiveViewerCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewerCount = ref.watch(
      lvsStateNotifier.select(
        (state) => dyteMobileClient.livestream.data.viewerCount,
      ),
    );
    return dyteMobileClient.meta.roomType == DyteRoomType.livestream
        ? Row(children: [
            const Icon(DyteIcons.viewers),
            hspace1,
            DyteText(
              viewerCount.toString(),
            )
          ])
        : const SizedBox.shrink();
  }
}
