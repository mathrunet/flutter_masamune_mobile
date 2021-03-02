part of masamune_mobile;

/// Class that manages the configuration of Masamune framework for mobile.
///
/// Initial values are set but can be changed at any time.
class MobileConfig {
  MobileConfig._();

  /// True if the config has been initialized.
  static bool get isInitialized => _isInitialized;
  static bool _isInitialized = false;

  /// Initialize the configuration.
  static Future initialize() async {
    if (Config.isWeb) {
      _isInitialized = true;
      return;
    }
    final deviceInfoPlugin = DeviceInfoPlugin();
    await Future.wait([
      PackageInfo.fromPlatform().then((value) => _packageInfo = value),
      if (Config.isIOS)
        deviceInfoPlugin.iosInfo.then((value) => _iosDeviceInfo = value),
      if (Config.isAndroid)
        deviceInfoPlugin.androidInfo.then((value) => _androidDeviceInfo = value)
    ]);
    _isInitialized = true;
  }

  /// IOS device information.
  static IosDeviceInfo get isoDeviceInfo => _iosDeviceInfo;
  static late final IosDeviceInfo _iosDeviceInfo;

  /// Android device information.
  static AndroidDeviceInfo get androidDeviceInfo => _androidDeviceInfo;
  static late final AndroidDeviceInfo _androidDeviceInfo;

  /// Package information.
  static PackageInfo get packageInfo => _packageInfo;
  static late final PackageInfo _packageInfo;
}
