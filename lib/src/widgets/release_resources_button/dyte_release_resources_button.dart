import 'package:dyte_icons/dyte_icons.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/widgets/utils/clean_pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [DyteReleaseResourceButton] widget is to be used when client exits the SDK
/// before joining room such as waiting room or setup screen.
class DyteReleaseResourcesButton extends ConsumerStatefulWidget {
  const DyteReleaseResourcesButton({super.key});

  @override
  ConsumerState<DyteReleaseResourcesButton> createState() =>
      _DyteReleaseResourcesButtonState();
}

class _DyteReleaseResourcesButtonState
    extends ConsumerState<DyteReleaseResourcesButton> {
  late bool _isReleaseCalled;
  @override
  void initState() {
    _isReleaseCalled = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _isReleaseCalled
          ? null
          : () async {
              if (_isReleaseCalled) {
                return;
              }
              setState(() {
                _isReleaseCalled = true;
              });
              await DyteUtils(context).leave(ref, release: true);
              setState(() {
                _isReleaseCalled = false;
              });
            },
      icon: _isReleaseCalled
          ? CircularProgressIndicator(
              strokeWidth: 2,
              color: globalDesignToken.colorToken.textColor.shade800,
            )
          : const Icon(DyteIcons.dismiss),
    );
  }
}
