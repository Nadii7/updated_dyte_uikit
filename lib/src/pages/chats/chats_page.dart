import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/pages/chats/widgets/meeting_chats_viewer.dart';
import 'package:dyte_uikit/src/pages/chats/widgets/message_sender.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_app_bar.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatPermissions = dyteMobileClient.permissions.chat;
    return Scaffold(
      appBar: DyteAppBar(
        backgroundColor: globalDesignToken.colorToken.backgroundColor.shade1000,
        title: DyteText(DyteStrings.chat),
        hasLeading: false,
        actions: [
          IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(DyteIcons.dismiss),
          )
        ],
      ),
      backgroundColor: globalDesignToken.colorToken.backgroundColor.shade1000,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - context.adjust(90),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Expanded(
                child: ChatsViewerWidget(),
              ),
              if (chatPermissions.canSend) MessageSender(),
            ],
          ),
        ),
      ),
    );
  }
}
