import 'package:flutter/material.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_app_bar.dart';
import 'package:dyte_uikit/src/pages/chats/widgets/message_sender.dart';
import 'package:dyte_uikit/src/pages/chats/widgets/meeting_chats_viewer.dart';

import '../../routes/router.dart';

class ChatsPage extends StatelessWidget {
  final String remainingTime;
  const ChatsPage({super.key, required this.remainingTime});

  @override
  Widget build(BuildContext context) {
    final chatPermissions = dyteMobileClient.permissions.chat;
    return Scaffold(
      body: const ChatsViewerWidget(),
      bottomNavigationBar: chatPermissions.canSend ? MessageSender() : null,
      backgroundColor: globalDesignToken.colorToken.backgroundColor.shade1000,
      appBar: DyteAppBar(
        remainingTime: remainingTime,
        title: DyteText(DyteStrings.chat),
        leadingIcon: const Icon(DyteIcons.dismiss),
        onPressed: () => DyteRouter.of(context).pop(),
        backgroundColor: globalDesignToken.colorToken.backgroundColor.shade1000,
      ),
    );
  }
}
