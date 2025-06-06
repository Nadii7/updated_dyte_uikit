import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/pages/chats/widgets/send_other_formats.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_icon_button.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text_field.dart';
import 'package:dyte_uikit/src/widgets/molecules/snackbar.dart';
import 'package:flutter/material.dart';

class MessageSender extends StatelessWidget {
  MessageSender({super.key});

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Container(
      child: dyteMobileClient.permissions.chat.canSend
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: context.width,
                  padding: const EdgeInsets.all(10),
                  color: theme.colorScheme.primaryContainer,
                  child: Row(
                    children: [
                      if (dyteMobileClient.permissions.chat.canSendFiles) ...[
                        DyteIconButton(
                          backgroundColor: theme.colorScheme.secondaryContainer,
                          icon: Icon(
                            DyteIcons.add,
                            color: theme.colorScheme.onSecondary,
                          ),
                          onPressed: () async => await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => const SendOtherFormats(),
                          ),
                        ),
                      ],
                      if (dyteMobileClient.permissions.chat.canSendText) ...[
                        Expanded(
                          child: DyteTextField(
                            height: null,
                            width: null,
                            fillColor: theme.colorScheme.primaryContainer,
                            controller: _messageController,
                            hintText: '${DyteStrings.message}...',
                            hintStyle: theme.textTheme.titleMedium,
                            border: InputBorder.none,
                            maxLines: null,
                          ),
                        ),
                        DyteIconButton(
                          backgroundColor: theme.colorScheme.primary,
                          icon: Icon(
                            DyteIcons.send,
                            color: theme.colorScheme.onSecondary,
                          ),
                          onPressed: () {
                            if (_messageController.text.trim().isEmpty) {
                              showSnackbarWidget(
                                  context,
                                  getTextContentForSnackbar(
                                      'Message cannot be empty', context));
                              return;
                            }
                            dyteMobileClient.chat
                                .sendTextMessage(_messageController.text.trim());
                            _messageController.clear();
                          },
                        )
                      ]
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
