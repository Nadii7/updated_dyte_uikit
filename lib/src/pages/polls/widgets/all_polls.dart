import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/pages/polls/widgets/poll_card.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllPolls extends ConsumerStatefulWidget {
  const AllPolls({super.key});

  @override
  ConsumerState<AllPolls> createState() => _AllPollsState();
}

class _AllPollsState extends ConsumerState<AllPolls> {
  List<DytePollMessage> _allPolls = [];
  @override
  void initState() {
    super.initState();
    _allPolls = dyteMobileClient.polls.polls;
  }

  @override
  Widget build(BuildContext context) {
    // const pollPermissions = true;
// TODO : Add permission check
    return SizedBox(
        height: context.height * .9,
        child: ListView.separated(
          separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: context.adjust(8)),
              child: const Divider()),
          itemBuilder: (context, index) => PollCard(
            pollMessage: _allPolls[index],
          ),
          itemCount: _allPolls.length,
        )
        // : const Center(
        //     child: DyteText("Sorry, you are not allowed to view polls!"),
        //   ),
        );
  }
}
