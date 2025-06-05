import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/routes/route_names.dart';
import 'package:dyte_uikit/src/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DytePollsIconWidget extends ConsumerWidget {
  final String remainingTime;
  const DytePollsIconWidget({
    super.key,
    required this.remainingTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        DyteRouter.of(context).push(
          DytePollsScreen(remainingTime: remainingTime),
          pageName: RouteNames.polls,
        );
      },
      icon: Icon(
        DyteIcons.poll,
        color: globalDesignToken.colorToken.textColor.shade1000,
      ),
    );
  }
}
