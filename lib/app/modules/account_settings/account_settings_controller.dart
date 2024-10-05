import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_partner/shared/routes.dart';

class AccountSettingsController extends GetxController {
  RxString userName = ''.obs;
  RxString userPhone = ''.obs;
  RxInt orderCount = 0.obs;

  UserRepo userRepo = Get.find();

  RxString currentVersion = ''.obs;

  AppRepo appRepo = Get.find();

  @override
  void onInit() {
    super.onInit();

    initVersion();
  }

  onPressedEditAccountInfo() {}

  onPressedOrders() {
    Get.toNamed(Routes.orders);
  }

  onPressedSignOut() async {
    await userRepo.signOut();
  }

  onPressedSignIn() {
    Get.toNamed(
      Routes.signing,
      arguments: "",
    );
  }

  initVersion() async {
    currentVersion.value = await appRepo.getCurrentVersion();
  }
}
