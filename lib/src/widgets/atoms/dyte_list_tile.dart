import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:flutter/material.dart';

class DyteListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? trailing;
  final Color? iconColor;
  final Color? tileColor;
  final EdgeInsetsGeometry? contentPadding;
  final VoidCallback? onTap;

  const DyteListTile({
    super.key,
    this.leading,
    this.tileColor,
    this.onTap,
    required this.title,
    this.trailing,
    this.iconColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return ListTile(
      tileColor: tileColor ?? theme.colorScheme.primaryContainer,
      leading: leading,
      title: title,
      iconColor: iconColor ?? theme.colorScheme.onPrimary,
      onTap: onTap,
      trailing: trailing,
      contentPadding: contentPadding,
    );
  }
}
