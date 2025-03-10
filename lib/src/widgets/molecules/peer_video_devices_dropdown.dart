import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeerVideoDevicesDropDown extends ConsumerStatefulWidget {
  final List<DyteVideoDevice> videoDevices;
  final DyteVideoDevice selectedVideoDevice;
  const PeerVideoDevicesDropDown({
    super.key,
    required this.videoDevices,
    required this.selectedVideoDevice,
  });

  @override
  ConsumerState<PeerVideoDevicesDropDown> createState() =>
      _PeerVideoDevicesDropDownState();
}

class _PeerVideoDevicesDropDownState
    extends ConsumerState<PeerVideoDevicesDropDown> {
  late DyteVideoDevice selectedVideoDevice;

  @override
  void initState() {
    selectedVideoDevice = widget.selectedVideoDevice;
    super.initState();
  }

  String _getLocaleDeviceName(VideoDeviceType videoDevice) {
    switch (videoDevice) {
      case VideoDeviceType.front:
        return DyteStrings.frontCamera;
      case VideoDeviceType.rear:
        return DyteStrings.rearCamera;
      case VideoDeviceType.ext:
        return DyteStrings.externalCamera;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: MediaQuery.of(context).orientation == Orientation.portrait,
      icon: const Icon(
        DyteIcons.chevron_down,
      ),
      iconEnabledColor: textColorSwatch.shade1000,
      iconSize: 18,
      hint: DyteText(
        DyteStrings.selectVideoDevice,
      ),
      value: selectedVideoDevice,
      items: widget.videoDevices
          .map(
            (DyteVideoDevice videoDevice) => DropdownMenuItem<DyteVideoDevice>(
              onTap: () async {
                if (videoDevice == selectedVideoDevice) {
                  return;
                } else {
                  await dyteMobileClient.localUser.setVideoDevice(videoDevice);
                }
              },
              value: videoDevice,
              child: DyteText(
                _getLocaleDeviceName(videoDevice.type),
              ),
            ),
          )
          .toList(),
      onChanged: (value) async {
        if (value != selectedVideoDevice) {
          selectedVideoDevice = value as DyteVideoDevice;
          setState(() {});
        }
      },
    );
  }
}
