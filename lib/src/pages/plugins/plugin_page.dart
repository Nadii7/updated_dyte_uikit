import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/routes/router.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_app_bar.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_icon_button.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_list_tile.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DytePluginsScreen extends ConsumerWidget {
  final String remainingTime;
  const DytePluginsScreen({
    super.key,
    required this.remainingTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: DyteAppBar(
        remainingTime: remainingTime,
        title: DyteText(DyteStrings.plugins),
        hasLeading: false,
        actions: [
          IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(DyteIcons.dismiss))
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: dyteMobileClient.plugins.all,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final plugins = snapshot.data as List<DytePlugin>;
              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: vspace1.height!,
                ),
                height: context.height * 0.8,
                child: ListView.builder(
                  itemCount: plugins.length,
                  itemBuilder: (context, index) {
                    final plugin = plugins[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: DyteListTile(
                        tileColor: Colors.transparent,
                        leading: Image.network(plugin.picture),
                        title: DyteText(plugin.name),
                        trailing: dyteMobileClient.permissions.plugin.canLaunch
                            ? DytePluginLauncherWidger(plugin: plugin)
                            : null,
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class DytePluginLauncherWidger extends ConsumerWidget {
  final DytePlugin plugin;
  const DytePluginLauncherWidger({
    required this.plugin,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isPluginLaunched = ref.watch(
      pluginProvider.select(
        (plugins) => plugins.any((plugin) => plugin.id == this.plugin.id),
      ),
    );
    return ((isPluginLaunched &&
                dyteMobileClient.permissions.plugin.canClose) ||
            (!isPluginLaunched &&
                dyteMobileClient.permissions.plugin.canLaunch))
        ? DyteIconButton(
            icon: Icon(isPluginLaunched ? DyteIcons.dismiss : DyteIcons.rocket),
            onPressed: () {
              isPluginLaunched ? plugin.deactivate() : plugin.activate();
              DyteRouter.of(context).pop();
            },
          )
        : const SizedBox.shrink();
  }
}
