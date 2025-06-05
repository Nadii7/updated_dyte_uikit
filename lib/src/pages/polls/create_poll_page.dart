import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/routes/router.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_app_bar.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text_button.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text_field.dart';
import 'package:dyte_uikit/src/widgets/core/core.dart';
import 'package:dyte_uikit/src/widgets/molecules/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/atoms/dyte_icon_button.dart';

class CreatePollPage extends ConsumerStatefulWidget {
  final String remainingTime;
  const CreatePollPage({
    super.key,
    required this.remainingTime,
  });

  @override
  ConsumerState<CreatePollPage> createState() => _CreatePollPageState();
}

class _CreatePollPageState extends ConsumerState<CreatePollPage> {
  final TextEditingController questionController = TextEditingController();

  // Maintaining a list of mandatory option controllers.
  final List<TextEditingController> mandatoryOptionsController = [
    TextEditingController(),
    TextEditingController(),
  ];

  List<TextEditingController> moreOptionsController = [];

  bool anonymous = false;
  bool hideVotes = true;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Scaffold(
      appBar: DyteAppBar(
        remainingTime: widget.remainingTime,
        title: DyteText(DyteStrings.createPoll),
        hasLeading: false,
        actions: [
          IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(DyteIcons.dismiss))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.adjust(8)),
          child: SingleChildScrollView(
            child: SizedBox(
              width: context.width * 0.98,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: context.adjust(10),
                  ),
                  DyteText(DyteStrings.question),
                  SizedBox(
                    height: context.adjust(5),
                  ),
                  SizedBox(
                    width: context.width,
                    child: DyteTextField(
                      controller: questionController,
                      hintText: DyteStrings.askAQuestion,
                      hintStyle: theme.textTheme.titleMedium,
                    ),
                  ),
                  DyteText(DyteStrings.options),
                  SizedBox(
                    height: context.adjust(5),
                  ),
                  ...mandatoryOptionsController.map(
                    (optController) => SizedBox(
                      width: context.width,
                      child: DyteTextField(
                        controller: optController,
                        hintText: DyteStrings.enterAnOption,
                        hintStyle: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  ...moreOptionsController.map(
                    (addOptController) => Row(
                      children: [
                        Expanded(
                          child: DyteTextField(
                            controller: addOptController,
                            hintText: DyteStrings.enterAnOption,
                            hintStyle: theme.textTheme.titleMedium,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: context.adjust(15)),
                          child: DyteIconButton(
                            icon: const Icon(DyteIcons.subtract),
                            onPressed: () {
                              setState(() {
                                moreOptionsController.removeWhere(
                                  (element) => element == addOptController,
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: DyteButtons.solid(
                      onPressed: () {
                        setState(() {
                          moreOptionsController.add(TextEditingController());
                        });
                      },
                      width: context.width,
                      label: DyteStrings.addOption,
                    ),
                  ),
                  Row(
                    children: [
                      Switch.adaptive(
                        onChanged: (value) => setState(() {
                          anonymous = value;
                          if (anonymous == true) {
                            hideVotes = true;
                          }
                        }),
                        value: anonymous,
                      ),
                      DyteText(DyteStrings.anonymous),
                    ],
                  ),
                  Row(
                    children: [
                      Switch.adaptive(
                        onChanged: (value) => anonymous
                            ? null
                            : setState(() {
                                hideVotes = value;
                              }),
                        value: hideVotes,
                      ),
                      DyteText(DyteStrings.hideResultsBeforeVoting),
                    ],
                  ),
                  Center(
                    child: DyteTextButton(
                      width: context.width * 0.5,
                      onPressed: () {
                        final options = [
                          ...mandatoryOptionsController
                              .map((mandatoryOpt) => mandatoryOpt.text.trim()),
                          ...moreOptionsController
                              .map((moreOpt) => moreOpt.text.trim()),
                        ];
                        if (questionController.text.trim().isEmpty ||
                            options.any((opt) => opt.isEmpty)) {
                          showSnackbarWidget(
                            context,
                            getTextContentForSnackbar(
                              DyteStrings.questionAndOptionsCantBeEmpty,
                              context,
                            ),
                          );
                        }
                        dyteMobileClient.polls.create(
                          question: questionController.text.trim(),
                          options: options,
                          anonymous: anonymous,
                          hideVotes: hideVotes,
                        );
                        DyteRouter.of(context).pop();
                      },
                      label: DyteStrings.createPoll,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
