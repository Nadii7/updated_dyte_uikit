import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:dyte_uikit/src/tokens/font/font_size.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class DyteDependencyHandler {
  static late DyteUIKitInfo uikitInfo;
  static late DyteMobileClient? client;
  static void setupDependencies(
    DyteUIKitInfo dyteUIKitInfo,
    DyteMobileClient? client,
  ) {
    DyteDependencyHandler.uikitInfo = dyteUIKitInfo;
    DyteDependencyHandler.client = client;
    getIt.registerFactory<DyteDesignTokens>(() => dyteUIKitInfo.designToken);
    getIt.registerSingleton<FontSize>(FontSize());
    getIt.registerSingleton<DyteMobileClient>(client ?? DyteMobileClient());
    getIt.registerSingleton<DyteMeetingInfo>(dyteUIKitInfo.meetingInfo);
    getIt.registerLazySingleton<DyteConfig>(() => DyteConfig());
  }

  static void tearDownDependencies() {
    if (getIt.isRegistered<DyteDesignTokens>()) {
      getIt.unregister<DyteDesignTokens>();
    }

    if (getIt.isRegistered<FontSize>()) {
      getIt.unregister<FontSize>();
    }

    if (getIt.isRegistered<DyteMobileClient>()) {
      getIt.unregister<DyteMobileClient>();
    }

    if (getIt.isRegistered<DyteMeetingInfo>()) {
      getIt.unregister<DyteMeetingInfo>();
    }
    if (getIt.isRegistered<DyteConfig>()) {
      getIt.unregister<DyteConfig>();
    }
  }
}

DyteDesignTokens get globalDesignToken => getIt.get<DyteDesignTokens>();
BorderToken get borderToken => globalDesignToken.borderToken;

LinearColorSwatch get textColorSwatch => globalDesignToken.colorToken.textColor;
RangedColorSwatch get brandColorSwatch =>
    globalDesignToken.colorToken.brandColor;
LinearColorSwatch get backgroundColorSwatch =>
    globalDesignToken.colorToken.backgroundColor;
FontSize get fontSize => getIt.get<FontSize>();

DyteMobileClient get dyteMobileClient => getIt.get<DyteMobileClient>();

DyteMeetingInfo get meetingInfo => getIt.get<DyteMeetingInfo>();

DyteConfig get dyteConfig => getIt.get<DyteConfig>();
