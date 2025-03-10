import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/data/states/local_user_states.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../dyte_uikit.dart';
import '../../../widgets/atoms/dyte_icon_button.dart';

class SwitchCameraWidget extends ConsumerWidget {
  const SwitchCameraWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget cameraToggler = DyteIconButton(
      icon: const Icon(DyteIcons.camera_switch),
      onPressed: () async {
        // TODO: improve the logic
        final selectedVideoDevice =
            await dyteMobileClient.localUser.getSelectedVideoDevice();
        final videoDevices = await dyteMobileClient.localUser.getVideoDevices();
        videoDevices.remove(selectedVideoDevice);

        dyteMobileClient.localUser.switchCamera();
      },
    );
    ref.watch(
        localUserSettingsProvider.select((value) => value is OnVideoUpdate));

    // Return the widget as per initial state.
    return dyteMobileClient.localUser.videoEnabled
        ? cameraToggler
        : Container();
  }
}
