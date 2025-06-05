import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/data/manage_listeners.dart';
import 'package:dyte_uikit/src/di/di.dart';
import 'package:dyte_uikit/src/pages/room_route_page.dart';
import 'package:dyte_uikit/src/strings.dart';
import 'package:dyte_uikit/src/tokens/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class DyteApp extends ConsumerStatefulWidget {
  final Function()? onClose;

  final DyteMeetingInfo dyteMeetingInfo;
  const DyteApp(this.dyteMeetingInfo, {super.key, required this.onClose});
  @override
  ConsumerState<DyteApp> createState() => _DyteAppState();
}

class _DyteAppState extends ConsumerState<DyteApp> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    DyteListenerManager.init(ref);
    if (mounted) {
      DyteListenerManager.instance.registerDyteListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(globalDesignToken.colorToken);
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        Locale(DyteStrings.locale),
      ],
      theme: appTheme.theme,
      debugShowCheckedModeBanner: false,
      home: RoomRoutePage(onClose: widget.onClose),
    );
  }

  @override
  void dispose() {
    DyteUIKitBuilder.dispose();
    super.dispose();
  }
}

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
