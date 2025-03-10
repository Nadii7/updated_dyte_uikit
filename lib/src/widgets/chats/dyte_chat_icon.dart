import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:dyte_uikit/src/pages/chats/chats_page.dart';
import 'package:dyte_uikit/src/routes/route_names.dart';
import 'package:dyte_uikit/src/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DyteChatIconWidget extends ConsumerWidget {
  const DyteChatIconWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref.read(unreadChatNotifier.notifier).readAllMessages(
              ref.read(chatListNotifier).length,
            );
        DyteRouter.of(context).push(
          const ChatsPage(),
          pageName: RouteNames.chats,
        );
      },
      icon: Icon(
        DyteIcons.chat,
        // TODO: use AppTheme
        color: globalDesignToken.colorToken.textColor.shade1000,
      ),
    );
  }
}
