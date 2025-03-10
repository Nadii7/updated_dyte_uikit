import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/notifiers/audio_notifier.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/utils/generate_key.dart';
import 'package:flutter/material.dart';

class DyteAudioIndicatorIconWidget extends StatefulWidget {
  final DyteMeetingParticipant participant;
  final double? iconSize;
  DyteAudioIndicatorIconWidget({
    super.key,
    required this.participant,
    this.iconSize,
  })  : isLocalUser = participant.id == dyteMobileClient.localUser.id,
        localUserAudioNotifier = participant.id == dyteMobileClient.localUser.id
            ? LocalUserAudioNotifier()
            : null,
        audioNotifier = participant.id != dyteMobileClient.localUser.id
            ? AudioNotifier(participant)
            : null {
    if (isLocalUser) {
      dyteMobileClient.addSelfEventsListener(localUserAudioNotifier!);
    } else {
      dyteMobileClient.addParticipantEventsListener(audioNotifier!);
    }
  }

  final LocalUserAudioNotifier? localUserAudioNotifier;
  final AudioNotifier? audioNotifier;

  final bool isLocalUser;

  @override
  State<DyteAudioIndicatorIconWidget> createState() => _AudioIconState();
}

class _AudioIconState extends State<DyteAudioIndicatorIconWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    if (widget.localUserAudioNotifier != null) {
      return ValueListenableBuilder(
        valueListenable: widget.localUserAudioNotifier!,
        builder: (context, bool audioEnabled, child) {
          return Icon(
            audioEnabled ? DyteIcons.mic_on : DyteIcons.mic_off,
            key: generateAudioKeyForParticipant(
              widget.participant,
              pageName: 'AudioIcon',
            ),
            size: widget.iconSize ?? 24,
            color: audioEnabled
                ? theme.colorScheme.onSecondary
                : theme.colorScheme.error,
          );
        },
      );
    } else {
      return ValueListenableBuilder(
        valueListenable: widget.audioNotifier!,
        builder: (context, bool audioEnabled, child) {
          return Icon(
            audioEnabled ? DyteIcons.mic_on : DyteIcons.mic_off,
            key: generateAudioKeyForParticipant(
              widget.participant,
              pageName: 'AudioIcon',
            ),
            size: widget.iconSize ?? 24,
            color: audioEnabled
                ? theme.colorScheme.onSecondary
                : theme.colorScheme.error,
          );
        },
      );
    }
  }

  @override
  void dispose() {
    if (widget.localUserAudioNotifier != null) {
      dyteMobileClient.removeSelfEventsListener(widget.localUserAudioNotifier!);
    } else if (widget.audioNotifier != null) {
      dyteMobileClient.removeParticipantEventsListener(widget.audioNotifier!);
    }
    super.dispose();
  }
}
