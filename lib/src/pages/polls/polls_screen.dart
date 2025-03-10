import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/pages/polls/create_poll_page.dart';
import 'package:dyte_uikit/src/routes/router.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_app_bar.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:flutter/material.dart';

import '../../widgets/atoms/dyte_button.dart';
import 'widgets/polls_viewer_widget.dart';

class DytePollsScreen extends StatelessWidget {
  const DytePollsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Scaffold(
      appBar: DyteAppBar(
        title: DyteText(DyteStrings.polls),
        hasLeading: false,
        actions: [
          IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(DyteIcons.dismiss))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: context.adjust(5),
            ),
            if (dyteMobileClient.permissions.poll.canView)
              const Expanded(
                child: PollsViewerWidget(),
              ),
            if (dyteMobileClient.permissions.poll.canCreate)
              DyteButton(
                height: context.adjust(48),
                onPressed: () {
                  DyteRouter.of(context).push(
                    const CreatePollPage(),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      DyteIcons.add,
                      color: theme.colorScheme.onSecondary,
                    ),
                    DyteText(
                      DyteStrings.createPoll,
                      dyteTextStyle: theme.textTheme.displayMedium,
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
