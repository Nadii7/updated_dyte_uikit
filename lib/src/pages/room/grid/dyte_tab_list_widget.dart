import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/data/models/dyte_tab_participant.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabListWidget extends ConsumerWidget {
  const TabListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final tabNotifier = ref.watch(tabNotifierProvider);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: context.adjust(50),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: tabNotifier.participant
              .map((tabParticipant) => GestureDetector(
                    onTap: () {
                      ref
                          .watch(tabNotifierProvider.notifier)
                          .selectParticipant(tabParticipant);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: tabParticipant.isSelected
                                  ? brandColorSwatch.shade500
                                  : backgroundColorSwatch.shade800,
                              borderRadius: BorderRadius.circular(
                                  borderToken.getRadius(BorderSize.two))),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    tabParticipant.type ==
                                            DyteTabParticipantType.plugin
                                        ? DyteIcons.rocket
                                        : DyteIcons.share_screen_person,
                                    color: textColorSwatch.shade1000,
                                    size: vspace4.height,
                                  ),
                                  hspace1,
                                  DyteText(
                                    tabParticipant.name,
                                    textAlign: TextAlign.center,
                                    dyteTextStyle: theme.textTheme.titleSmall!
                                        .copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
