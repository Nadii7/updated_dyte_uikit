import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:flutter/material.dart';

import '../../../di/di.dart';

class HostOptionsWidget extends StatelessWidget {
  final DyteMeetingParticipant participant;
  final List<Widget> hostActions;
  const HostOptionsWidget({
    super.key,
    required this.participant,
    required this.hostActions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;

    return Container(
      height: context.height * .5,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            borderToken.getRadius(BorderSize.two),
          ),
          topRight: Radius.circular(
            borderToken.getRadius(BorderSize.two),
          ),
        ),
      ),
      child: ListView.separated(
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            color: theme.colorScheme.tertiaryContainer,
          ),
        ),
        itemBuilder: (context, index) => hostActions[index],
        itemCount: hostActions.length,
      ),
    );
  }
}
