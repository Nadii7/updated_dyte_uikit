import '../../routes/router.dart';
import 'package:flutter/material.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_app_bar.dart';
import 'package:dyte_uikit/src/widgets/molecules/audio_devices_loader.dart';
import 'package:dyte_uikit/src/widgets/molecules/video_devices_loader.dart';

class SetupSettingsPage extends ConsumerWidget {
  final String remainingTime;
  SetupSettingsPage({
    super.key,
    required this.remainingTime,
  });

  final mediaPermissions = dyteMobileClient.permissions.media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: DyteAppBar(
        hasLeading: false,
        remainingTime: remainingTime,
        title: DyteText(DyteStrings.settings),
        leadingIcon: const Icon(DyteIcons.dismiss),
        onPressed: () => DyteRouter.of(context).pop(),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: MediaQuery.of(context).orientation == Orientation.portrait
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          height: context.adjust(320),
                          width: context.adjust(240),
                          child: _getPeerView(),
                        ),
                      ),
                      vspace3,
                      const DeviceLoader(),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          height: context.adjust(320),
                          width: context.adjust(240),
                          child: _getPeerView(),
                        ),
                      ),
                      hspace3,
                      const DeviceLoader(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _getPeerView() {
    return DyteParticipantTile(dyteMobileClient.localUser);
  }
}

class DeviceLoader extends ConsumerWidget {
  const DeviceLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    final localUserApi = ref.watch(localUserSettingsProvider.notifier);
    final isCameraGranted =
        dyteMobileClient.localUser.permissions.isCameraPermissionGranted;
    final isMicGranted =
        dyteMobileClient.localUser.permissions.isMicrophonePermissionGranted;

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCameraGranted && localUserApi.isVideoEnabled) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width * .15),
              child: DyteText(
                DyteStrings.camera,
                dyteTextStyle: theme.textTheme.titleMedium,
              ),
            ),
            vspace1,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width * .15),
              child: const VideoDevicesLoader(),
            ),
            vspace3,
          ],
          if (isMicGranted && localUserApi.isAudioEnabled) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width * .15),
              child: DyteText(
                DyteStrings.microphoneInput,
                dyteTextStyle: theme.textTheme.titleMedium,
              ),
            ),
            vspace1,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width * .15),
              child: const AudioDevicesLoader(),
            ),
          ]
        ]);
  }
}
