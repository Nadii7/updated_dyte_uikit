import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/routes/route_names.dart';
import 'package:dyte_uikit/src/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DytePollsIconWidget extends ConsumerWidget {
  const DytePollsIconWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        DyteRouter.of(context).push(
          const DytePollsScreen(),
          pageName: RouteNames.polls,
        );
      },
      icon: Icon(
        DyteIcons.poll,
        // TODO: use AppTheme
        color: globalDesignToken.colorToken.textColor.shade1000,
      ),
    );
  }
}
