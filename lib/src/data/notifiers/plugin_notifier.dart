import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/states/plugin_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PluginNotifier extends Notifier<PluginStates>
    implements DytePluginEventsListener {
  @override
  PluginStates build() {
    return InitialPluginState();
  }

  @override
  void onPluginActivated(DytePlugin plugin) {
    state = OnPluginActivated(plugin);
  }

  @override
  void onPluginDeactivated(DytePlugin plugin) {
    state = OnPluginDeactivated(plugin);
  }

  @override
  void onPluginFileRequest(DytePlugin plugin) {
    state = OnPluginFileRequest(plugin);
  }

  @override
  void onPluginMessage(DytePlugin plugin, String eventName, String data) {
    state = OnPluginMessage(plugin, eventName, data);
  }
}
