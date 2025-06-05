import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/di.dart';
import '../../pages/room/widgets/dyte_menu_widget.dart';
import '../atoms/dyte_bottom_nav_button.dart';
import '../atoms/dyte_text.dart';

class MoreButtonWidget extends ConsumerWidget {
  final bool showLabel;
  final bool canLivestream;
  final String remainingTime;

  const MoreButtonWidget({
    super.key,
    this.showLabel = false,
    this.canLivestream = false,
    required this.remainingTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: hspace12.width,
      child: Stack(
        children: [
          Center(
            child: DyteBottomNavButton(
              icon: const Icon(Icons.more_horiz_sharp),
              iconColor: textColorSwatch.shade1000,
              showLabel: showLabel,
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  builder: (context) => DyteMenuWidget(
                    remainingTime: remainingTime,
                    canLivestream: canLivestream,
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            right: 4,
            child: UnreadCountWidget(
              unreadNotitifers: [
                unreadChatNotifier,
                unreadPollsNotifier,
                unreadWaitlistedCountNotifier,
                unreadStageRequestCountNotifier,
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UnreadCountWidget extends ConsumerWidget {
  final List<NotifierProvider<Notifier<int>, int>> unreadNotitifers;
  const UnreadCountWidget({super.key, required this.unreadNotitifers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int totalUnreads =
        unreadNotitifers.map<int>((e) => ref.watch(e)).reduce((a, b) => a + b);
    final bool isIndividualUnreads = unreadNotitifers.length <= 2;
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return OrientationBuilder(builder: (context, orientation) {
      final bool isPortrait = orientation == Orientation.portrait;
      final markDiameter = isIndividualUnreads
          ? vspace3.height
          : isPortrait
              ? vspace3.height!
              : hspace3.width!;
      return totalUnreads > 0
          ? Container(
              height: markDiameter,
              width: markDiameter,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: DyteText(
                  (totalUnreads > 99
                      ? "99+"
                      : totalUnreads
                          .toString()), // (totalUnreads > 99 ? "99+" : totalUnreads.toString()),
                  dyteTextStyle: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontSize: totalUnreads > 99
                        ? isIndividualUnreads
                            ? vspace1_25.height!
                            : isPortrait
                                ? vspace1_25.height!
                                : hspace1.width!
                        : isIndividualUnreads
                            ? vspace1_5.height!
                            : isPortrait
                                ? vspace1_75.height!
                                : hspace2.width!,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink();
    });
  }
}
