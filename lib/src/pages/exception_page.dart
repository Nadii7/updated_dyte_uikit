import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/widgets/atoms/dyte_button.dart';
import 'package:dyte_uikit/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';

class ExceptionPage extends StatelessWidget {
  final DyteError exception;
  const ExceptionPage(this.exception, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error: ${exception.details}"),
          vspace2,
          DyteButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .popUntil((route) => route.isFirst);
              },
              child: Text(
                DyteStrings.back,
                style: TextStyle(color: textColorSwatch.shade1000),
              )),
        ],
      ),
    ));
  }
}
