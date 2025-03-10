import 'dart:math';

import 'package:dyte_uikit/src/data/notifiers/video_notifier.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/utils/generate_key.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:dyte_uikit/src/widgets/core/dyte_uikit_component.dart';
import 'package:dyte_uikit/src/widgets/dyte_audio_indicator/dyte_audio_indicator_icon_widget.dart';
import 'package:dyte_uikit/src/widgets/dyte_name_tag/dyte_name_tag.dart';
import 'package:dyte_uikit/src/widgets/molecules/pinned_widget.dart';
import 'package:dyte_uikit/src/widgets/participant_tile/peer_avatar_view.dart';
import 'package:dyte_uikit/src/widgets/participant_tile/peer_video_view.dart';
import 'package:flutter/material.dart';

class DyteParticipantTile extends StatefulWidget with UiKitElement {
  final DyteMeetingParticipant participant;
  final double height;
  final double width;
  final DyteDesignTokens designToken;
  DyteParticipantTile(
    this.participant, {
    DyteDesignTokens? designToken,
    super.key,
    this.height = 240,
    this.width = 180,
  })  : designToken = designToken ?? globalDesignToken,
        isSelfView = participant.id == dyteMobileClient.localUser.id,
        localUserVideoNotifier = participant.id == dyteMobileClient.localUser.id
            ? LocalUserVideoNotifier()
            : null,
        videoNotifier = participant.id != dyteMobileClient.localUser.id
            ? VideoNotifier(participant)
            : null {
    if (isSelfView) {
      dyteMobileClient.addSelfEventsListener(localUserVideoNotifier!);
    } else {
      dyteMobileClient.addParticipantEventsListener(videoNotifier!);
    }
  }

  final VideoNotifier? videoNotifier;
  final LocalUserVideoNotifier? localUserVideoNotifier;

  final bool isSelfView;
  @override
  State<StatefulWidget> createState() => _PeerViewState();

  @override
  double get borderRadius => designToken.borderToken.getRadius(BorderSize.two);

  @override
  double get borderWidth => 0.0;

  @override
  Color get fillColor => designToken.colorToken.backgroundColor.shade900;

  @override
  Color get textColor => designToken.colorToken.textColor.shade1000;
}

class _PeerViewState extends State<DyteParticipantTile> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double size = min(124, constraints.smallest.shortestSide * 0.45);
      return Stack(
        children: [
          if (widget.localUserVideoNotifier != null)
            ValueListenableBuilder(
              valueListenable: widget.localUserVideoNotifier!,
              builder: (context, isVideoEnabled, child) {
                return SizedBox(
                  child: isVideoEnabled
                      ? PeerVideoView(
                          VideoView(
                            isSelfParticipant: true,
                            meetingParticipant: null,
                            key: generateKeyForParticipant(
                              widget.participant,
                              pageName: 'PeerView',
                            ),
                          ),
                          borderRadius: widget.borderRadius,
                        )
                      : PeerAvatarView(
                          widget.participant,
                          backgroundColor: widget.fillColor,
                          borderRadius: widget.borderRadius,
                        ),
                );
              },
            )
          else
            ValueListenableBuilder(
              valueListenable: widget.videoNotifier!,
              builder: (context, isVideoEnabled, child) {
                return SizedBox(
                  child: isVideoEnabled
                      ? PeerVideoView(
                          VideoView(
                            isSelfParticipant: false,
                            meetingParticipant: widget.participant,
                            key: generateKeyForParticipant(
                              widget.participant,
                              pageName: 'PeerView',
                            ),
                          ),
                          borderRadius: widget.borderRadius,
                        )
                      : PeerAvatarView(
                          widget.participant,
                          backgroundColor: widget.fillColor,
                          borderRadius: widget.borderRadius,
                        ),
                );
              },
            ),
          Positioned(
            left: context.adjust(6),
            top: context.adjust(6),
            child: PinnedWidget(widget.participant),
          ),
          Positioned(
            left: context.adjust(6),
            bottom: context.adjust(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    borderToken.getRadius(BorderSize.one)),
                color: backgroundColorSwatch.shade800,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DyteAudioIndicatorIconWidget(
                    participant: widget.participant,
                    iconSize: context.adjust(14),
                  ),
                  hspace1,
                  DyteNameTag(
                    size: size,
                    color: widget.textColor,
                    participant: widget.participant,
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }

  @override
  void dispose() {
    if (widget.localUserVideoNotifier != null) {
      dyteMobileClient.removeSelfEventsListener(widget.localUserVideoNotifier!);
    } else {
      dyteMobileClient.removeParticipantEventsListener(widget.videoNotifier!);
    }
    super.dispose();
  }
}
