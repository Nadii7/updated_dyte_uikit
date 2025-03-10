import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/pages/polls/widgets/empty_polls_widget.dart';
import 'package:dyte_uikit/src/pages/polls/widgets/poll_card.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PollsViewerWidget extends ConsumerWidget {
  const PollsViewerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(unreadPollsNotifier, (previous, next) {
      ref.read(unreadPollsNotifier.notifier).markAllAsRead(
            ref.read(pollsListNotifier).length,
          );
    });
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    final polls = ref.watch(pollsListNotifier);
    return SizedBox(
      height: context.height * .9,
      child: dyteMobileClient.polls.polls.isEmpty
          ? const EmptyPollsWidget()
          : ListView.separated(
              separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.adjust(8)),
                  child: Divider(
                    color: theme.colorScheme.tertiaryContainer,
                  )),
              itemBuilder: (context, index) => PollCard(
                pollMessage: dyteMobileClient.polls.polls[index],
              ),
              itemCount: polls.length,
            ),
    );
  }
}
