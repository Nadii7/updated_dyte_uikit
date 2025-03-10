import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/atoms/dyte_text.dart';
import '../../widgets/atoms/vh_space.dart';

class LiveHostCountWidget extends ConsumerWidget {
  const LiveHostCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(children: [
      const Icon(DyteIcons.participants),
      hspace1,
      StreamBuilder<DyteParticipants>(
        initialData: dyteMobileClient.participants,
        stream: dyteMobileClient.participantsStream,
        builder: (context, snapshot) =>
            DyteText(snapshot.data!.active.length.toString()),
      ),
    ]);
  }
}
