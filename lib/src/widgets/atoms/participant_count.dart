import 'package:dyte_uikit/src/data/states/participant_event_states.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParticipantCount extends ConsumerWidget {
  const ParticipantCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int joinedP = dyteMobileClient.participants.joined.length;

    final theme = AppTheme(globalDesignToken.colorToken).theme;

    ref.listen<ParticipantEventStates>(
      participantEventNotifier,
      (previous, next) {
        if (next.runtimeType == OnUpdate) {
          joinedP = ref.watch(
            participantEventNotifier.select((s) => s is OnUpdate
                ? s.participants.joined.length
                : dyteMobileClient.participants.joined.length),
          );
        }
      },
    );

    return Text(
      '$joinedP participants',
      style: theme.textTheme.bodyLarge,
    );
  }
}
