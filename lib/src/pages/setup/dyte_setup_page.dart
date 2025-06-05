import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/states/local_user_states.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/pages/setup/settings_page.dart';
import 'package:dyte_uikit/src/routes/router.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/color/status_color.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_icon_button.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text_field.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:dyte_uikit/src/widgets/molecules/dyte_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DyteSetupScreen extends ConsumerStatefulWidget {
  final DyteAudioDevice? selectedAudioDevice;
  final DyteVideoDevice? selectedVideoDevice;
  const DyteSetupScreen(this.selectedAudioDevice, this.selectedVideoDevice,
      {super.key});

  @override
  ConsumerState<DyteSetupScreen> createState() => _SetupPageState();
}

class _SetupPageState extends ConsumerState<DyteSetupScreen> {
  final _userNameController =
      TextEditingController(text: dyteMobileClient.localUser.name);

  final mediaPermissions = dyteMobileClient.permissions.media;

  @override
  void initState() {
    super.initState();

    ref.read(localUserSettingsProvider.notifier).isAudioEnabled = meetingInfo
            .enableAudio &&
        mediaPermissions.audio == DyteMediaPermission.allowed &&
        dyteMobileClient.localUser.permissions.isMicrophonePermissionGranted;
    ref.read(localUserSettingsProvider.notifier).isVideoEnabled =
        dyteMobileClient.localUser.permissions.isCameraPermissionGranted &&
            meetingInfo.enableVideo &&
            mediaPermissions.video.permission == DyteMediaPermission.allowed;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(
        localUserSettingsProvider.select((value) => value is OnVideoUpdate));
    final bool nameIsEmpty =
        ref.watch(editNameProvider.select((name) => name.isEmpty));
    final theme = AppTheme(globalDesignToken.colorToken).theme;

    return  PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: const [DyteReleaseResourcesButton()],
        ),
        body: SafeArea(
          child: SizedBox(
            height: context.height,
            width: context.width,
            child: Center(
              child: OrientationBuilder(
                builder: (context, orientation) {
                  return orientation == Orientation.portrait
                      ? Column(
                          children: [
                            vspace2,
                            SizedBox(
                              height: context.adjust(320),
                              width: context.adjust(240),
                              child: DyteParticipantTile(
                                  dyteMobileClient.localUser),
                            ),
                            vspace2,
                            SetupScreenControlButtons(
                              selectedAudioDevice: widget.selectedAudioDevice,
                              selectedVideoDevice: widget.selectedVideoDevice,
                            ),
                            vspace3,
                            DyteText(DyteStrings.joinInAs),
                            vspace1,
                            DyteTextField(
                              controller: _userNameController,
                              hintText: DyteStrings.enterYourName,
                              hintStyle: theme.textTheme.titleMedium,
                              onChanged: (name) {
                                ref
                                    .read(editNameProvider.notifier)
                                    .onChanged(name.trim());
                              },
                              enabled: dyteMobileClient
                                  .permissions.miscellaneous.canEditDisplayName,
                              height: context.adjust(44),
                              width: context.adjust(300),
                            ),
                            vspace2,
                            DyteJoinButton(
                              isDisabled: nameIsEmpty,
                              dyteMobileClient: dyteMobileClient,
                              height: context.adjust(48),
                              width: context.adjust(300),
                              onMeetingJoined: () {
                                dyteMobileClient.localUser.setDisplayName(
                                    _userNameController.text.trim());
                              },
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: context.adjust(320),
                              width: context.adjust(240),
                              child: DyteParticipantTile(
                                  dyteMobileClient.localUser),
                            ),
                            hspace3,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SetupScreenControlButtons(
                                  selectedAudioDevice:
                                      widget.selectedAudioDevice,
                                  selectedVideoDevice:
                                      widget.selectedVideoDevice,
                                ),
                                vspace3,
                                DyteText(DyteStrings.joinInAs),
                                vspace1,
                                DyteTextField(
                                  controller: _userNameController,
                                  hintText: DyteStrings.enterYourName,
                                  hintStyle: theme.textTheme.titleMedium,
                                  onChanged: (name) {
                                    ref
                                        .read(editNameProvider.notifier)
                                        .onChanged(name.trim());
                                  },
                                  enabled: dyteMobileClient.permissions
                                      .miscellaneous.canEditDisplayName,
                                  height: context.adjust(44),
                                  width: context.adjust(300),
                                ),
                                vspace2,
                                DyteJoinButton(
                                  isDisabled: nameIsEmpty,
                                  dyteMobileClient: dyteMobileClient,
                                  height: context.adjust(48),
                                  width: context.adjust(300),
                                  onMeetingJoined: () {
                                    dyteMobileClient.localUser.setDisplayName(
                                        _userNameController.text.trim());
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SetupScreenControlButtons extends StatelessWidget {
  final DyteAudioDevice? selectedAudioDevice;
  final DyteVideoDevice? selectedVideoDevice;

  const SetupScreenControlButtons(
      {this.selectedAudioDevice, this.selectedVideoDevice, super.key});

  @override
  Widget build(BuildContext context) {
    final isCameraGranted =
        dyteMobileClient.localUser.permissions.isCameraPermissionGranted;
    final isMicGranted =
        dyteMobileClient.localUser.permissions.isMicrophonePermissionGranted;
    final colorScheme =
        AppTheme(globalDesignToken.colorToken).theme.colorScheme;
    final mediaPermissions = dyteMobileClient.permissions.media;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (mediaPermissions.audio == DyteMediaPermission.allowed)
          GestureDetector(
            onTap: !isMicGranted
                ? () {
                    showBottomSheetWithWidget(
                      context,
                      _getSnackbarMessage(
                        'Please grant microphone permission from Settings to enable audio',
                      ),
                    );
                  }
                : null,
            child: Container(
              height: context.adjust(48),
              width: context.adjust(48),
              decoration: BoxDecoration(
                color: globalDesignToken.colorToken.backgroundColor.shade900,
                borderRadius: BorderRadius.circular(
                  borderToken.getRadius(BorderSize.one),
                ),
              ),
              child:
                  DyteSelfAudioToggleButton(dyteMobileClient: dyteMobileClient),
            ),
          ),
        hspace3,
        if (mediaPermissions.video.permission == DyteMediaPermission.allowed)
          GestureDetector(
            onTap: !isCameraGranted
                ? () {
                    showBottomSheetWithWidget(
                        context,
                        _getSnackbarMessage(
                            'Please grant camera permission from Settings to enable video'));
                  }
                : null,
            child: Container(
                height: context.adjust(48),
                width: context.adjust(48),
                decoration: BoxDecoration(
                  color: globalDesignToken.colorToken.backgroundColor.shade900,
                  borderRadius: BorderRadius.circular(
                    borderToken.getRadius(BorderSize.one),
                  ),
                ),
                child: DyteSelfVideoToggleButton(
                  dyteMobileClient: dyteMobileClient,
                )),
          ),
        hspace3,
        if (mediaPermissions.audio == DyteMediaPermission.allowed ||
            mediaPermissions.video.permission == DyteMediaPermission.allowed ||
            selectedAudioDevice != null ||
            selectedVideoDevice != null)
          DyteIconButton(
            onPressed: () {
              DyteRouter.of(context).push(SetupSettingsPage());
            },
            icon: Icon(
              DyteIcons.settings,
              color: colorScheme.onSecondary,
            ),
          ),
      ],
    );
  }

  Widget _getSnackbarMessage(String message) {
    return Row(
      children: [
        const Icon(
          DyteIcons.warning,
          color: StatusColor.warning,
          size: 20,
        ),
        hspace2,
        Expanded(
            child: Text(message,
                style: AppTheme(globalDesignToken.colorToken)
                    .theme
                    .textTheme
                    .bodyMedium)),
      ],
    );
  }
}
