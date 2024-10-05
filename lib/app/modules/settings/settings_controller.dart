import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';

class SettingsController extends GetxController {
  RxString currentVersion = ''.obs;

  AppRepo appRepo = Get.find();

  @override
  void onInit() {
    super.onInit();

    _initAppVersionText();
  }

  _initAppVersionText() async {
    currentVersion.value = await appRepo.getCurrentVersion();
  }
}
