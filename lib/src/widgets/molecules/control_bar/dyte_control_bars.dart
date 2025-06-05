import 'package:dyte_uikit/src/data/notifiers/audio_notifier.dart';
import 'package:dyte_uikit/src/data/notifiers/video_notifier.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/widgets/molecules/more_button_widget.dart';
import 'package:dyte_uikit/src/widgets/molecules/screenshare_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../dyte_uikit.dart';
import '../../../di/riverpod_di.dart';
import '../../../tokens/size/size_util.dart';
import '../stage_req_button_widget.dart';

class DyteControlBar {
  DyteControlBar._();

  static Widget gc(
          {DyteDesignTokens? designToken, required Function()? onClose}) =>
      SafeArea(
        child: _DyteGCControlBar(
          onClose: onClose,
          individualDesignToken: designToken,
        ),
      );
  static Widget webinar(
          {DyteDesignTokens? designToken, required Function()? onClose}) =>
      SafeArea(
        child: _DyteStageControlBar(
          onClose: onClose,
          individualDesignToken: designToken,
        ),
      );
  static Widget livestream(
          {DyteDesignTokens? designToken, required Function()? onClose}) =>
      SafeArea(
        child: _DyteStageControlBar(
          onClose: onClose,
          individualDesignToken: designToken,
          canLivestream: dyteMobileClient.permissions.livestream.canLivestream,
        ),
      );
}

class _DyteGCControlBar extends ConsumerStatefulWidget {
  final Function()? onClose;

  final DyteDesignTokens? individualDesignToken;

  const _DyteGCControlBar({
    this.individualDesignToken,
    required this.onClose,
  });

  @override
  ConsumerState<_DyteGCControlBar> createState() => _DyteGCControlBarState();
}

class _DyteGCControlBarState extends ConsumerState<_DyteGCControlBar> {
  late DyteDataEventsListener stagePerms;
  late AudioNotifier _audioNotifier;
  late VideoNotifier _videoNotifier;
  @override
  void initState() {
    _audioNotifier = AudioNotifier(dyteMobileClient.localUser);
    _videoNotifier = VideoNotifier(dyteMobileClient.localUser);
    stagePerms = ref.read(stagePermissionNotifier.notifier);
    dyteMobileClient.addDataEventsListener(stagePerms);
    dyteMobileClient.addParticipantEventsListener(_audioNotifier);
    dyteMobileClient.addParticipantEventsListener(_videoNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final iconWidth = (context.width - 8) / 8;
    return Container(
      height: context.adjust(bottomNavbarHeight + 6),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      decoration: BoxDecoration(
        color:
            widget.individualDesignToken?.colorToken.backgroundColor.shade900 ??
                globalDesignToken.colorToken.backgroundColor.shade900,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: iconWidth,
            child:
                DyteSelfAudioToggleButton(dyteMobileClient: dyteMobileClient),
          ),
          SizedBox(
            width: iconWidth,
            child: DyteSelfVideoToggleButton(
              dyteMobileClient: dyteMobileClient,
              // showLabel: true,
            ),
          ),
          DyteScreenshareWidget(
            dyteMobileClient: dyteMobileClient,
          ),
          const MoreButtonWidget(),
          DyteLeaveButton(
            dyteMobileClient: dyteMobileClient,
            onClose: widget.onClose,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    dyteMobileClient.removeParticipantEventsListener(_audioNotifier);
    dyteMobileClient.removeParticipantEventsListener(_videoNotifier);
    dyteMobileClient.removeDataEventsListener(stagePerms);
  }
}

class OnStageToggleWidget extends ConsumerStatefulWidget {
  final Widget child;
  const OnStageToggleWidget({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnStageToggleWidgetState();
}

class _OnStageToggleWidgetState extends ConsumerState<OnStageToggleWidget> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(stageStatusNotifier) == DyteStageStatus.onStage
        ? widget.child
        : const SizedBox.shrink();
  }
}

class _DyteStageControlBar extends ConsumerStatefulWidget {
  final bool canLivestream;
  final Function()? onClose;
  final DyteDesignTokens designToken;
  final DyteDesignTokens? individualDesignToken;

  _DyteStageControlBar({
    required this.onClose,
    this.individualDesignToken,
    this.canLivestream = false,
  }) : designToken = individualDesignToken ?? globalDesignToken;
  @override
  ConsumerState<_DyteStageControlBar> createState() =>
      _DyteStageControlBarState();
}

class _DyteStageControlBarState extends ConsumerState<_DyteStageControlBar> {
  late DyteDataEventsListener stageDataListener;
  @override
  void initState() {
    stageDataListener = ref.read(stagePermissionNotifier.notifier);
    dyteMobileClient.addDataEventsListener(stageDataListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final iconWidth = (context.width - 8) / 8;

    return Container(
      height: context.adjust(bottomNavbarHeight + 6),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      decoration: BoxDecoration(
        color:
            widget.individualDesignToken?.colorToken.backgroundColor.shade900 ??
                globalDesignToken.colorToken.backgroundColor.shade900,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          const DyteStageRequestButton(),
          SizedBox(
            width: iconWidth,
            child: OnStageToggleWidget(
              child:
                  DyteSelfAudioToggleButton(dyteMobileClient: dyteMobileClient),
            ),
          ),
          SizedBox(
            width: iconWidth,
            child: OnStageToggleWidget(
              child:
                  DyteSelfVideoToggleButton(dyteMobileClient: dyteMobileClient),
            ),
          ),
          OnStageToggleWidget(
            child: DyteScreenshareWidget(
              dyteMobileClient: dyteMobileClient,
            ),
          ),
          MoreButtonWidget(
            canLivestream: widget.canLivestream,
          ),
          DyteLeaveButton(
            dyteMobileClient: dyteMobileClient,
            onClose: widget.onClose,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    dyteMobileClient.removeDataEventsListener(stageDataListener);
  }
}
