import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WaitingRoom extends ConsumerWidget {
  const WaitingRoom({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor:
          AppTheme(globalDesignToken.colorToken).theme.colorScheme.background,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(borderToken.getRadius(BorderSize.two)),
            color: AppTheme(globalDesignToken.colorToken)
                .theme
                .colorScheme
                .primaryContainer,
          ),
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
          child: DyteText(
            DyteStrings.waitingForTheHostToLetYouIn,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
