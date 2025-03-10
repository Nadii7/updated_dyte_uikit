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
    required DyteUIKitInfo uiKitInfo,
    String? arbPath,
    DyteMobileClient? client,
    bool skipSetupPage = false,
  }) {
    if (arbPath != null) {
      DyteStrings(arbPath: arbPath).init();
    }
    if (!getIt.isRegistered<DyteDesignTokens>()) {
      DyteDependencyHandler.setupDependecies(uiKitInfo, client);
    }
    return DyteUiKit(
      uiKitInfo,
      skipSetupPage: skipSetupPage,
    );
  }

  static void dispose() {
    DyteDependencyHandler.tearDownDependencies();
  }
}

class DyteUiKit extends StatelessWidget {
  final DyteUIKitInfo _uiKitInfo;
  final bool skipSetupPage;
  const DyteUiKit(
    this._uiKitInfo, {
    this.skipSetupPage = false,
    super.key,
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
    return DyteApp(uikitInfo.meetingInfo);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DyteProvider(
      observers: [Logger()],
      client: mobileClient,
      uiKitInfo: uikitInfo,
      child: WillPopScope(
        onWillPop: () async => false,
        child: _app(),
      ),
    );
  }
}

class DyteProvider extends StatefulWidget {
  const DyteProvider({
    Key? key,
    required this.child,
    required this.client,
    required this.uiKitInfo,
    this.observers,
  }) : super(key: key);

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
      DyteDependencyHandler.setupDependecies(
        widget.uiKitInfo,
        widget.client,
        // dyteConfig,
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
