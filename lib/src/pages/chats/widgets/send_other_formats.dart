import 'package:dyte_core/dyte_core.dart';
import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/routes/router.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/size/size_util.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../di/di.dart';
import '../../../widgets/atoms/dyte_list_tile.dart';
import '../../../widgets/atoms/dyte_text.dart';

class SendOtherFormats extends StatelessWidget {
  const SendOtherFormats({super.key});

  Future<PlatformFile?> _chooseFile(BuildContext context,
      {required bool isImage}) async {
    final file = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: isImage ? FileType.image : FileType.any,
    );
    return file != null ? file.files[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    final chatApi = dyteMobileClient.chat;
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Container(
      height: context.height * 0.15,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            borderToken.getRadius(BorderSize.two),
          ),
          topRight: Radius.circular(
            borderToken.getRadius(BorderSize.two),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        children: [
          DyteListTile(
            leading: Icon(
              DyteIcons.attach,
              color: globalDesignToken.colorToken.textColor.shade1000,
            ),
            title: DyteText(DyteStrings.file),
            onTap: () async {
              DyteRouter.of(context).pop();
              final chosenFile = await _chooseFile(
                context,
                isImage: false,
              );
              if (chosenFile != null) {
                if (chosenFile.path != null) {
                  chatApi.sendFileMessage(
                    chosenFile.path!,
                    chosenFile.name,
                  );
                }
              }
            },
          ),
          const Divider(),
          DyteListTile(
              leading: Icon(
                DyteIcons.image,
                color: globalDesignToken.colorToken.textColor.shade1000,
              ),
              title: DyteText(DyteStrings.image),
              onTap: () async {
                DyteRouter.of(context).pop();
                final chosenImage = await _chooseFile(
                  context,
                  isImage: true,
                );
                if (chosenImage != null) {
                  if (chosenImage.path != null) {
                    chatApi.sendImageMessage(
                      chosenImage.path!,
                      chosenImage.name,
                    );
                  }
                }
              }),
        ],
      ),
    );
  }
}
