import 'package:get/get.dart';
import 'package:mapalus_partner/data/models/version.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsController extends GetxController {
  RxString textVersion = ''.obs;

  @override
  void onInit() {
    super.onInit();

    _initAppVersionText();
  }

  _initAppVersionText() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    Version localVersion = Version.fromList(version.split('.'));
    textVersion.value =
        'v ${localVersion.major}.${localVersion.minor}.${localVersion.patch}';
  }
}
