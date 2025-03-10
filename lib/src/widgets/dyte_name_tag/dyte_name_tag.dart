import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../atoms/dyte_text.dart';

class DyteNameTag extends ConsumerStatefulWidget {
  final DyteMeetingParticipant participant;
  final double size;
  final double factor;
  final Color color;
  const DyteNameTag({
    super.key,
    required this.participant,
    required this.size,
    required this.color,
    this.factor = 7,
  });

  @override
  ConsumerState<DyteNameTag> createState() => _DyteNameTagState();
}

class _DyteNameTagState extends ConsumerState<DyteNameTag> {
  late String participantName;
  @override
  void initState() {
    participantName = widget.participant.name;

    if (widget.participant.id == dyteMobileClient.localUser.id) {
      participantName += ' (${DyteStrings.you})';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    participantName = ref.watch(editNameProvider.select((name) =>
        widget.participant.id == dyteMobileClient.localUser.id
            ? '$name(${DyteStrings.you})'
            : widget.participant.name));

    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Container(
      constraints: BoxConstraints(maxWidth: widget.size),
      child: DyteText(
        participantName,
        dyteTextStyle: theme.textTheme.bodyMedium!.copyWith(
          fontSize: widget.size / widget.factor,
          color: widget.color,
        ),
      ),
    );
  }
}
