import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';

import 'dyte_text.dart';

class DyteImageMessageLayout extends StatelessWidget {
  final DyteImageMessage imageMessage;
  const DyteImageMessageLayout({
    super.key,
    required this.imageMessage,
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
                imageMessage.displayName,
                dyteTextStyle: theme.textTheme.displaySmall,
              ),
              const SizedBox(width: 8),
            ],
          ),
          vspace1,
          GestureDetector(
            onTap: () {
              _showImageDialog(context, imageMessage.link);
            },
            child: SizedBox(
              width: context.width * 0.6,
              child: Image.network(
                imageMessage.link,
                fit: BoxFit.fitWidth,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        elevation: 0,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide.none,
        ),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Stack(
          children: [
            SizedBox(
              width: context.width * 0.8,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: globalDesignToken.colorToken.textColor.shade800
                        .withValues(alpha:0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: IconButton(
                    iconSize: 16,
                    icon: const Icon(DyteIcons.dismiss),
                    color:
                        globalDesignToken.colorToken.backgroundColor.shade1000,
                    onPressed: Navigator.of(context, rootNavigator: true).pop,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: globalDesignToken.colorToken.textColor.shade800
                        .withValues(alpha:0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: IconButton(
                    icon: const Icon(DyteIcons.download),
                    color:
                        globalDesignToken.colorToken.backgroundColor.shade1000,
                    iconSize: 16,
                    onPressed: () async {
                      dyteMobileClient.chat.downloadAttachment(
                        imageUrl,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
