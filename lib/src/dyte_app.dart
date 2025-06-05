import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/provider_logger.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/pages/app.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/size/size_config.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DyteUIKitInfo {
  final DyteMeetingInfo meetingInfo;
  final DyteDesignTokens _designToken;

  DyteDesignTokens get designToken => _designToken;

  DyteUIKitInfo(
    this.meetingInfo, {
    DyteDesignTokens? designToken,
  }) : _designToken = designToken ?? DyteDesignTokens();
}

class DyteConfig {
  bool skipSetupScreen = false;
}

class DyteUIKitBuilder {
  final DyteUIKitInfo uiKitInfo;

  DyteUIKitBuilder._(this.uiKitInfo, this.arbPath);
  final String? arbPath;

  static DyteUiKit build({
    String? arbPath,
    DyteMobileClient? client,
    bool skipSetupPage = false,
    required Function()? onClose,
    required String remainingTime,
    required DyteUIKitInfo uiKitInfo,
  }) {
    if (arbPath != null) {
      DyteStrings(arbPath: arbPath).init();
    }
    if (!getIt.isRegistered<DyteDesignTokens>()) {
      DyteDependencyHandler.setupDependencies(uiKitInfo, client);
    }
    return DyteUiKit(
      uiKitInfo,
      onClose: onClose,
      remainingTime: remainingTime,
      skipSetupPage: skipSetupPage,
    );
  }

  static void dispose() {
    DyteDependencyHandler.tearDownDependencies();
  }
}

class DyteUiKit extends StatelessWidget {
  final bool skipSetupPage;
  final Function()? onClose;
  final String remainingTime;
  final DyteUIKitInfo _uiKitInfo;

  const DyteUiKit(
    this._uiKitInfo, {
    super.key,
    required this.onClose,
    this.skipSetupPage = false,
    required this.remainingTime,
  });
  DyteUIKitInfo get uikitInfo => _uiKitInfo;
  DyteMobileClient get mobileClient => dyteMobileClient;

  @Deprecated(
      'We will remove the support for loadUI() method, instead use the object of DyteUiKit only.')
  Widget loadUI() {
    return this;
  }

  Widget _app() {
    dyteConfig.skipSetupScreen = skipSetupPage;
    return DyteApp(
      onClose: onClose,
      uikitInfo.meetingInfo,
      remainingTime: remainingTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DyteProvider(
      observers: [Logger()],
      client: mobileClient,
      uiKitInfo: uikitInfo,
      child: PopScope(
        canPop: false,
        child: _app(),
      ),
    );
  }
}

class DyteProvider extends StatefulWidget {
  const DyteProvider({
    super.key,
    required this.child,
    required this.client,
    required this.uiKitInfo,
    this.observers,
  });

  final List<ProviderObserver>? observers;
  final Widget child;
  final DyteMobileClient client;
  final DyteUIKitInfo uiKitInfo;

  @override
  State<DyteProvider> createState() => _DyteProviderState();
}

class _DyteProviderState extends State<DyteProvider> {
  @override
  void initState() {
    if (!getIt.isRegistered<DyteDesignTokens>()) {
      DyteDependencyHandler.setupDependencies(
        widget.uiKitInfo,
        widget.client,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(globalDesignToken.colorToken);
    return OrientationBuilder(
      builder: (context, orientation) {
        SizeConfig().init(context);
        return ProviderScope(
          observers: widget.observers,
          child: Theme(
            data: appTheme.theme,
            child: widget.child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    DyteDependencyHandler.tearDownDependencies();
    super.dispose();
  }
}
