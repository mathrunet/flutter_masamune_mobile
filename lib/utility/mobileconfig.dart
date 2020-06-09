part of masamune.mobile;

/// Class that manages the configuration of Masamune framework for mobile.
///
/// Initial values are set but can be changed at any time.
class MobileConfig {
  /// True if the config has been initialized.
  static bool get isInitialized => _isInitialized;
  static bool _isInitialized = false;

  /// Initialize the configuration.
  static Future init() async {
    if (Config.isWeb) return;
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    await PackageInfo.fromPlatform().then((value) => _packageInfo = value);
    if (Config.isIOS) _iosDeviceInfo = await deviceInfoPlugin.iosInfo;
    if (Config.isAndroid)
      _androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    _isInitialized = true;
  }

  /// IOS device information.
  static IosDeviceInfo get isoDeviceInfo => _iosDeviceInfo;
  static IosDeviceInfo _iosDeviceInfo;

  /// Android device information.
  static AndroidDeviceInfo get androidDeviceInfo => _androidDeviceInfo;
  static AndroidDeviceInfo _androidDeviceInfo;

  /// Package information.
  static PackageInfo get packageInfo => _packageInfo;
  static PackageInfo _packageInfo;
}
