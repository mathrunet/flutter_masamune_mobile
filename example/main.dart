import 'package:masamune_mobile/masamune_mobile.dart';

void main() async {
  await MobileConfig.init();
  print(MobileConfig.packageInfo.packageName);
}
