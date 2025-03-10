import 'package:flutter/material.dart';

class DyteRouter {
  static of(BuildContext context) => _DyteRouter(context);
}

class _DyteRouter {
  final BuildContext context;
  _DyteRouter(this.context);

  void pop() => Navigator.pop(context);

  void pushReplacementNamed(String pageName, [dynamic extra]) {
    Navigator.pushReplacementNamed(context, pageName, arguments: extra);
  }

  void pushNamed(String pageName, [dynamic extra]) {
    Navigator.pushNamed(context, pageName, arguments: extra);
  }

  void push(Widget page, {String? pageName}) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
          settings: pageName != null ? RouteSettings(name: pageName) : null,
        ));
  }
}
