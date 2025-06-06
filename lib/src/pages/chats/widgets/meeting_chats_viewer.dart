import 'package:flutter/material.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/riverpod_di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/pages/chats/widgets/no_chats_widget.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_file_message_layout.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_image_message_layout.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_text_message_layout.dart';

class ChatsViewerWidget extends ConsumerStatefulWidget {
  const ChatsViewerWidget({super.key});

  @override
  ConsumerState<ChatsViewerWidget> createState() => _ChatsViewerWidgetState();
}

class _ChatsViewerWidgetState extends ConsumerState<ChatsViewerWidget> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(unreadChatNotifier, (previous, next) {
      ref.read(unreadChatNotifier.notifier).readAllMessages(
            ref.read(chatListNotifier).length,
          );
    });
    final messages = ref.watch(chatListNotifier);
    return SizedBox(
      height: context.height * 0.8,
      child: messages.isEmpty
          ? const EmptyChatWidget()
          : ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                final msgType = messages[index].type;
                switch (msgType) {
                  case DyteMessageType.text:
                    return DyteTextMessageWidget(
                      textMessage: messages[index] as DyteTextMessage,
                    );
                  case DyteMessageType.image:
                    return DyteImageMessageLayout(
                      imageMessage: messages[index] as DyteImageMessage,
                    );
                  case DyteMessageType.file:
                    return DyteFileMessageLayout(
                        fileMessage: messages[index] as DyteFileMessage);
                  default:
                    return Container();
                }
              },
              itemCount: messages.length,
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
