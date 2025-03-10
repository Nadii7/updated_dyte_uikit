import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/notifiers/video_notifier.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/utils/generate_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoIcon extends ConsumerStatefulWidget {
  final DyteMeetingParticipant participant;
  final double? iconSize;

  const VideoIcon({
    super.key,
    required this.participant,
    this.iconSize,
  });

  @override
  ConsumerState<VideoIcon> createState() => _VideoIconState();
}

class _VideoIconState extends ConsumerState<VideoIcon> {
  late final VideoNotifier videoNotifier;

  @override
  void initState() {
    videoNotifier = VideoNotifier(widget.participant);
    dyteMobileClient.addParticipantEventsListener(videoNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;

    return ValueListenableBuilder(
      valueListenable: videoNotifier,
      builder: (context, bool videoEnabled, child) => Icon(
        videoEnabled ? DyteIcons.video_on : DyteIcons.video_off,
        key: generateVideoKeyForParticipant(
          widget.participant,
          pageName: 'VideoIcon',
        ),
        size: widget.iconSize ?? 24,
        color: videoEnabled
            ? theme.colorScheme.onSecondary
            : theme.colorScheme.error,
      ),
    );
  }

  @override
  void dispose() {
    dyteMobileClient.removeParticipantEventsListener(videoNotifier);
    super.dispose();
  }
}
