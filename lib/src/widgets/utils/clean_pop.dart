import 'package:dyte_uikit/src/data/manage_listeners.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/molecules/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DyteUtils {
  final BuildContext context;
  DyteUtils(this.context);
  Future<void> cleanAndPopUiKit(WidgetRef ref) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    DyteListenerManager.instance.unregisterDyteListeners();
    await dyteMobileClient.cleanAllNativeListeners();
    dyteMobileClient.removeMeetingRoomEventsListener(
      ref.read(routerNotifier.notifier),
    );
    navigator.pop();
  }

  Future<void> leave(WidgetRef ref, {bool release = false}) async {
    if (release) {
      final result = await dyteMobileClient.release();
      if (result) {
        await cleanAndPopUiKit(ref);
      } else {
        showSnackbarWidget(
          context,
          const DyteText('Failed to leave the meeting'),
        );
      }
    } else {
      await cleanAndPopUiKit(ref);
    }
  }
}
