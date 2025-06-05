import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_icon_button.dart';
import 'package:dyte_uikit/src/widgets/atoms/participant_count.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:dyte_uikit/src/widgets/meeting_title/dyte_meeting_title.dart';
import 'package:flutter/material.dart';

import '../../di/di.dart';
import '../../pages/livestream/live_host_count_widget.dart';
import '../../pages/livestream/live_indicator_widget.dart';
import '../../pages/livestream/live_viewer_count_widget.dart';
import '../../pages/room/widgets/meeting_timer_widget.dart';
import '../../pages/room/widgets/recorder_widget.dart';
import '../../pages/room/widgets/switch_camera_widget.dart';

class DyteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String remainingTime;
  final Icon? leadingIcon;
  final VoidCallback? onPressed;
  final Widget? title;
  final bool centerTitle;
  final bool hasLeading;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double titleSpacing;

  const DyteAppBar({
    super.key,
    this.leadingIcon,
    this.onPressed,
    this.backgroundColor,
    this.actions,
    this.hasLeading = true,
    this.centerTitle = true,
    this.bottom,
    this.titleSpacing = 10,
    this.title,
    required this.remainingTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return AppBar(
      backgroundColor: backgroundColor ?? theme.colorScheme.primaryContainer,
      centerTitle: centerTitle,
      scrolledUnderElevation: 0.0,
      automaticallyImplyLeading: hasLeading,
      titleSpacing: titleSpacing,
      leading: hasLeading
          ? DyteIconButton(
              onPressed: onPressed ?? () {},
              icon: leadingIcon ?? const Icon(DyteIcons.back),
              backgroundColor: theme.colorScheme.primaryContainer,
            )
          : null,
      title: title,
      bottom: bottom,
      actions: actions ?? [],
    );
  }

  Widget _buildAppBarTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: hspace1.width!,
      ),
      child: Column(
        children: [
          Row(
            children: [
              DyteMeetingTitle(dyteMobileClient: dyteMobileClient),
            ],
          ),
          _buildAppBarBottom(context),
        ],
      ),
    );
  }

  PreferredSize _buildAppBarBottom(BuildContext context,
      {bool showMeetingDuration = true}) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return PreferredSize(
      preferredSize: Size.zero,
      child: Row(children: [
        const ParticipantCount(),
        hspace1,
        if (showMeetingDuration) ...[
          Text(
            "•",
            style: theme.textTheme.bodyLarge!
                .copyWith(color: textColorSwatch.shade700),
          ),
          hspace1,
          DyteMeetingTimerWidget(remainingTime: remainingTime)
        ],
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52);
}

class _GCAppBar extends DyteAppBar {
  const _GCAppBar({required super.remainingTime});

  Widget _buildAppBar(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return DyteAppBar(
      remainingTime: remainingTime,
      backgroundColor: theme.colorScheme.surface,
      hasLeading: false,
      centerTitle: false,
      title: _buildAppBarTitle(context),
      actions: const [
        RecorderWidget(),
        SwitchCameraWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _buildAppBar(context));
  }
}

class _WebinarAppBar extends DyteAppBar {
  const _WebinarAppBar({required super.remainingTime});

  Widget _buildAppBar(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return DyteAppBar(
      hasLeading: false,
      remainingTime: remainingTime,
      backgroundColor: theme.colorScheme.surface,
      title: _buildAppBarTitle(context),
      actions: const [
        RecorderWidget(),
        SwitchCameraWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _buildAppBar(context));
  }
}

class _LivestreamAppBar extends DyteAppBar {
  const _LivestreamAppBar({required super.remainingTime});

  Widget _buildAppBar(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return DyteAppBar(
      remainingTime: remainingTime,
      backgroundColor: theme.colorScheme.surface,
      hasLeading: false,
      title: _buildAppBarTitle(context),
      actions: const [
        RecorderWidget(),
        LiveIndicatorWidget(),
        LiveHostCountWidget(),
        LiveViewerCountWidget(),
        SwitchCameraWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _buildAppBar(context));
  }
}

class DyteAppBars {
  DyteAppBars._();

  static DyteAppBar gc({required String remainingTime}) {
    return _GCAppBar(remainingTime: remainingTime);
  }

  static DyteAppBar webinar({required String remainingTime}) {
    return _WebinarAppBar(remainingTime: remainingTime);
  }

  static DyteAppBar lvs({required String remainingTime}) {
    return _LivestreamAppBar(remainingTime: remainingTime);
  }
}
