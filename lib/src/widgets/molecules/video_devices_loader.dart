import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/widgets/molecules/peer_video_devices_dropdown.dart';
import 'package:flutter/material.dart';

class VideoDevicesLoader extends StatelessWidget {
  const VideoDevicesLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dyteMobileClient.localUser.getVideoDevices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          final List<DyteVideoDevice> videoDevices =
              snapshot.data as List<DyteVideoDevice>;
          return FutureBuilder(
            future: dyteMobileClient.localUser.getSelectedVideoDevice(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final selectedVideoDevice = snapshot.data as DyteVideoDevice;
                return PeerVideoDevicesDropDown(
                  videoDevices: videoDevices,
                  selectedVideoDevice: selectedVideoDevice,
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
