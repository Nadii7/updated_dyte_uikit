import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/pages/plugins/plugin_page.dart';
import 'package:dyte_uikit/src/routes/route_names.dart';
import 'package:dyte_uikit/src/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DytePluginIconWidget extends ConsumerWidget {
  final String remainingTime;
  const DytePluginIconWidget({
    super.key,
    required this.remainingTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        DyteRouter.of(context).push(
          pageName: RouteNames.plugins,
          DytePluginsScreen(remainingTime: remainingTime),
        );
      },
      icon: Icon(
        DyteIcons.rocket,
        color: globalDesignToken.colorToken.textColor.shade1000,
      ),
    );
  }
}
