import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/widgets/molecules/peer_audio_devices_drop_down.dart';
import 'package:flutter/material.dart';

class AudioDevicesLoader extends StatelessWidget {
  const AudioDevicesLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dyteMobileClient.localUser.getAudioDevices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          final List<DyteAudioDevice> audioDevices =
              snapshot.data as List<DyteAudioDevice>;
          return FutureBuilder(
              future: dyteMobileClient.localUser.getSelectedAudioDevice(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final selectedAudioDevice = snapshot.data as DyteAudioDevice;

                  return PeerAudioDevicesDropDown(
                    audioDevices: audioDevices,
                    selectedAudioDevice: selectedAudioDevice,
                  );
                } else {
                  return Container();
                }
              });
        } else {
          return Container();
        }
      },
    );
  }
}
