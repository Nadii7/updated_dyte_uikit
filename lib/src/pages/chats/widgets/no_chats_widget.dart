import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:flutter/material.dart';

import '../../../widgets/molecules/dyte_shimmer_widget.dart';

class EmptyChatWidget extends StatelessWidget {
  const EmptyChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return SizedBox(
      width: context.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: context.adjust(160),
            width: context.adjust(277),
            child: Stack(
              children: [
                Positioned(
                  left: context.adjust(30),
                  child: const NoChatsBaseWidget(),
                ),
                const NoChatsOverlayWidget()
              ],
            ),
          ),
          DyteText(
            DyteStrings.noMessages,
            dyteTextStyle: theme.textTheme.headlineSmall,
          ),
          DyteText(
            DyteStrings.chatMessagesWillAppearHere,
            dyteTextStyle: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class NoChatsBaseWidget extends StatelessWidget {
  const NoChatsBaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 11.52,
          vertical: 8.45,
        ),
        height: context.adjust(76.84),
        width: context.adjust(248.18),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(
            context.adjust(6.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DyteShimmerWidget(
              height: context.adjust(10.76),
              width: context.adjust(73.76),
              color: theme.colorScheme.tertiaryContainer,
            ),
            SizedBox(height: context.adjust(16)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: context.adjust(6.15),
                ),
                DyteShimmerWidget(
                  width: context.adjust(73.76),
                  height: context.adjust(9.22),
                  color: theme.colorScheme.tertiaryContainer,
                ),
                SizedBox(
                  width: context.adjust(116.79),
                ),
                DyteShimmerWidget(
                  width: context.adjust(27),
                  height: context.adjust(27),
                  color: theme.colorScheme.primaryContainer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NoChatsOverlayWidget extends StatelessWidget {
  const NoChatsOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 11.52,
          vertical: 8.45,
        ),
        height: context.adjust(76.84),
        width: context.adjust(248.18),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(
            context.adjust(6.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DyteShimmerWidget(
              height: context.adjust(10.76),
              width: context.adjust(73.76),
              color: theme.colorScheme.tertiaryContainer,
            ),
            SizedBox(height: context.adjust(16)),
            DyteShimmerWidget(
              width: context.adjust(212.07),
              height: context.adjust(11.53),
              color: theme.colorScheme.primaryContainer,
            ),
            SizedBox(
              height: context.adjust(4.61),
            ),
            DyteShimmerWidget(
              width: context.adjust(89.13),
              height: context.adjust(10.76),
              color: theme.colorScheme.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}
