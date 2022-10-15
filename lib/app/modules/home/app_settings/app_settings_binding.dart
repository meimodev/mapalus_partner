import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/home/app_settings/app_settings_controller.dart';

class AppSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AppSettingsController>(AppSettingsController());
  }
}