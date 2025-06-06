import '../../../../dyte_uikit.dart';
import 'package:flutter/material.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/widgets/molecules/snackbar.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text_field.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_icon_button.dart';
import 'package:dyte_uikit/src/pages/chats/widgets/send_other_formats.dart';

class MessageSender extends StatelessWidget {
  MessageSender({super.key});

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Container(
      width: context.width,
      padding: EdgeInsets.all(context.adjust(10)),
      child: SafeArea(
        child: SizedBox(
          height: context.adjust(48),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (dyteMobileClient.permissions.chat.canSendFiles) ...[
                DyteIconButton(
                  height: context.adjust(48),
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
                SizedBox(width: context.adjust(10)),
                Expanded(
                  child: DyteTextField(
                    width: null,
                    maxLines: null,
                    height: context.adjust(48),
                    controller: _messageController,
                    hintText: '${DyteStrings.message}...',
                    hintStyle: theme.textTheme.titleMedium,
                    textInputAction: TextInputAction.newline,
                    fillColor:
                        globalDesignToken.colorToken.backgroundColor.shade1000,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: theme.colorScheme.secondaryContainer),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          borderToken.getRadius(BorderSize.one),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.adjust(10)),
                DyteIconButton(
                  height: context.adjust(48),
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
                            'Message cannot be empty', context),
                      );
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
    );
  }
}
