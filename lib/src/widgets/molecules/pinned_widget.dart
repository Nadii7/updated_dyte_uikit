import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/notifiers/pin_unpin_notifier.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:flutter/material.dart';

class PinnedWidget extends StatefulWidget {
  const PinnedWidget(this.participant, {super.key});

  final DyteMeetingParticipant participant;

  @override
  State<PinnedWidget> createState() => _PinnedWidgetState();
}

class _PinnedWidgetState extends State<PinnedWidget> {
  late PinNotifier? _pinNotifier;

  @override
  void initState() {
    _pinNotifier = PinNotifier();
    dyteMobileClient.addParticipantEventsListener(_pinNotifier!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _pinNotifier!,
        builder: (context, pinnedParticipant, child) {
          if (pinnedParticipant?.id == widget.participant.id) {
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: backgroundColorSwatch.shade800,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  DyteIcons.pin,
                  color: textColorSwatch.shade1000,
                  size: context.adjust(18),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }

  @override
  void dispose() {
    if (_pinNotifier != null) {
      dyteMobileClient.removeParticipantEventsListener(_pinNotifier!);
    }
    super.dispose();
  }
}
