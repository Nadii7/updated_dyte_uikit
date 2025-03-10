import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_icon_button.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';

import 'dyte_text.dart';

class DyteFileMessageLayout extends StatelessWidget {
  final DyteFileMessage fileMessage;
  const DyteFileMessageLayout({
    super.key,
    required this.fileMessage,
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
                fileMessage.displayName,
                dyteTextStyle: theme.textTheme.displaySmall,
              ),
              const SizedBox(width: 8),
            ],
          ),
          vspace1,
          Row(
            children: [
              SizedBox(
                width: context.width * 0.5,
                child: DyteText(
                  fileMessage.name,
                ),
              ),
              const Spacer(),
              DyteIconButton(
                  icon: Icon(
                    DyteIcons.download,
                    color: theme.colorScheme.onSecondary,
                  ),
                  onPressed: () {
                    dyteMobileClient.chat.downloadAttachment(
                      fileMessage.link,
                      fileName: fileMessage.name,
                    );
                  }),
            ],
          )
        ],
      ),
    );
  }
}
