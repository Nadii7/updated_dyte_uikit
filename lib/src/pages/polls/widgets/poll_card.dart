import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/states/poll_states.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/notifiers/poll_option_selector_notifier.dart';

class PollCard extends ConsumerStatefulWidget {
  final DytePollMessage pollMessage;
  const PollCard({
    super.key,
    required this.pollMessage,
  });

  @override
  ConsumerState<PollCard> createState() => _PollCardState();
}

class _PollCardState extends ConsumerState<PollCard> {
  late final pollOptionSelectorNotifier =
      NotifierProvider<PollOptionSelectorNotifier, DytePollOption?>(() {
    return PollOptionSelectorNotifier(widget.pollMessage);
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    // final pollPermissions = dyteMobileClient.permissions.pollPermissions;

    DytePollOption? votedOption;
    final currentUserId = dyteMobileClient.localUser.userId;
    try {
      votedOption = widget.pollMessage.options.firstWhere((opt) {
        return opt.votes.any((voter) => voter.id == currentUserId);
      });
    } catch (e) {
      votedOption = null;
    }
    return Column(
      children: [
        DyteText(
          "${DyteStrings.pollBy} ${widget.pollMessage.createdBy}",
          dyteTextStyle: theme.textTheme.titleMedium!
              .copyWith(color: theme.colorScheme.onSecondary),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Card(
            color: theme.colorScheme.primaryContainer,
            margin: EdgeInsets.symmetric(
              horizontal: context.adjust(8),
              vertical: context.adjust(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.adjust(18),
                    vertical: context.adjust(8),
                  ),
                  child: DyteText(
                    widget.pollMessage.question,
                    disableOverflow: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: OptionSelector(
                    poll: widget.pollMessage,
                    optionSelectorNotifier: pollOptionSelectorNotifier,
                    votedOption: votedOption,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.adjust(18),
                    ),
                    child: Divider(
                      color: theme.colorScheme.tertiaryContainer,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OptionSelector extends ConsumerStatefulWidget {
  final DytePollMessage poll;
  final NotifierProvider<PollOptionSelectorNotifier, DytePollOption?>
      optionSelectorNotifier;
  final DytePollOption? votedOption;
  const OptionSelector({
    super.key,
    required this.poll,
    required this.optionSelectorNotifier,
    required this.votedOption,
  });

  @override
  ConsumerState<OptionSelector> createState() => OptionSelectorState();
}

class OptionSelectorState extends ConsumerState<OptionSelector> {
  int _calculateAllVotes(DytePollMessage poll) {
    return poll.options.fold(0, (totalVotes, opt) => totalVotes + opt.count);
  }

  Future<void> showVotersList(DytePollOption option) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: option.votes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: DyteText(option.votes[index].name),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;

    ref.listen(pollsListNotifier, (previous, next) {
      if (next is OnPollUpdates) {
        final thisPoll = next.firstWhere((poll) => poll.id == widget.poll.id);
        if (thisPoll != widget.poll) {
          setState(() {});
        }
      }
    });

    return Column(children: [
      ...widget.poll.options.map((opt) {
        return Row(
          children: [
            Radio(
              value: opt,
              groupValue: widget.votedOption ??
                  ref.watch(widget.optionSelectorNotifier),
              activeColor: theme.colorScheme.primary,
              fillColor: MaterialStateProperty.all(theme.colorScheme.primary),
              onChanged: widget.votedOption == null
                  ? (_) {
                      dyteMobileClient.polls.vote(
                        pollMessage: widget.poll,
                        pollOption: opt,
                      );
                    }
                  : null,
            ),
            Expanded(
              child: DyteText(
                opt.text,
                disableOverflow: true,
              ),
            ),
            // If hideVotes is false, then show the result as the poll is ongoing
            // or if hideVotes is true, then show the result only when all the participants have voted

            if (( // condition 1: if this client is the creator of the poll -> show `View Votes` button on the go
                    widget.poll.createdBy == dyteMobileClient.localUser.name ||
                        // if anonymous is false and
                        (widget.poll.anonymous == false &&
                            // condition 2: if hideVotes is false -> show `View Votes` button on the go
                            (widget.poll.hideVotes == false ||
                                // condition 3: if hide votes is true, and all the participants have voted -> show `View Votes` button
                                (widget.poll.hideVotes &&
                                    _calculateAllVotes(widget.poll) ==
                                        dyteMobileClient
                                            .participants.joined.length)))) &&
                // condition 4: if the option has votes -> show `View Votes` button
                opt.count > 0)
              DyteTextButton(
                onPressed: () => showVotersList(opt),
                borderColor: theme.colorScheme.primary,
                variant: Variant.secondary,
                label: DyteStrings.viewVoters,
                labelStyle: theme.textTheme.bodySmall,
              ),

            if (widget.poll.createdBy == dyteMobileClient.localUser.name ||
                widget.poll.hideVotes == false ||
                (widget.poll.hideVotes &&
                    _calculateAllVotes(widget.poll) ==
                        dyteMobileClient.participants.joined.length))
              DyteText(
                " (${opt.votes.length.toString()})",
              ),
          ],
        );
      })
    ]);
  }
}
