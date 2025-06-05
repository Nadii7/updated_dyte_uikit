import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DyteTextMessageWidget extends StatelessWidget {
  // final DyteChatMessage message;
  final DyteTextMessage textMessage;
  const DyteTextMessageWidget({
    super.key,
    required this.textMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DyteText(
                textMessage.displayName,
                dyteTextStyle: theme.textTheme.displaySmall,
              ),
              const SizedBox(width: 8),
              DyteText(
                textMessage.time,
                dyteTextStyle: theme.textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
          vspace1,
          Text.rich(
            _styleUrlsInText(textMessage.message),
            style: theme.textTheme.bodyMedium,
          )
        ],
      ),
    );
  }

  TextSpan _styleUrlsInText(String text) {
    final urlRegex = RegExp(r'\b(?:https?://|www\.)\S+\b');

    List<InlineSpan> spans = [];

    int currentIndex = 0;
    for (final match in urlRegex.allMatches(text)) {
      // Add the text before the match
      final beforeMatch = text.substring(currentIndex, match.start);
      if (beforeMatch.isNotEmpty) {
        spans.add(TextSpan(text: beforeMatch));
      }

      // Add the matched URL with an underline style and GestureDetector
      String? url = match.group(0);
      spans.add(TextSpan(
        text: url,
        style: const TextStyle(decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            dyteMobileClient.launchUrl(url!);
          },
      ));

      currentIndex = match.end;
    }

    // Add any remaining text after the last match
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return TextSpan(children: spans);
  }
}
