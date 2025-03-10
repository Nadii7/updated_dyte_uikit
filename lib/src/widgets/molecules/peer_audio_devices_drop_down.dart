import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeerAudioDevicesDropDown extends ConsumerStatefulWidget {
  final List<DyteAudioDevice> audioDevices;
  final DyteAudioDevice selectedAudioDevice;
  const PeerAudioDevicesDropDown({
    super.key,
    required this.audioDevices,
    required this.selectedAudioDevice,
  });

  @override
  ConsumerState<PeerAudioDevicesDropDown> createState() =>
      _PeerDevicesDropDownState();
}

class _PeerDevicesDropDownState
    extends ConsumerState<PeerAudioDevicesDropDown> {
  AudioDeviceType? selectedAudioDeviceType;

  @override
  void initState() {
    selectedAudioDeviceType = widget.selectedAudioDevice.type;
    super.initState();
  }

  String _getLocaleDeviceName(AudioDeviceType audioDevice) {
    switch (audioDevice) {
      case AudioDeviceType.wired:
        return DyteStrings.headset;
      case AudioDeviceType.speaker:
        return DyteStrings.speaker;
      case AudioDeviceType.bluetooth:
        return DyteStrings.bluetooth;
      case AudioDeviceType.earpiece:
        return DyteStrings.earpiece;
      case AudioDeviceType.unknown:
        return DyteStrings.speaker;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return DropdownButton(
      isExpanded: MediaQuery.of(context).orientation == Orientation.portrait,
      icon: const Icon(
        DyteIcons.chevron_down,
      ),
      iconEnabledColor: textColorSwatch.shade1000,
      iconSize: 18,
      dropdownColor: theme.colorScheme.primaryContainer,
      value: selectedAudioDeviceType,
      hint: DyteText(
        DyteStrings.selectAudioDevice,
      ),
      items: widget.audioDevices
          .map(
            (DyteAudioDevice audioDevice) => DropdownMenuItem<AudioDeviceType>(
              onTap: () async =>
                  await dyteMobileClient.localUser.setAudioDevice(audioDevice),
              value: audioDevice.type,
              child: DyteText(
                _getLocaleDeviceName(audioDevice.type),
              ),
            ),
          )
          .toList(),
      onChanged: (value) async {
        selectedAudioDeviceType = value;
        setState(() {});
      },
    );
  }
}
