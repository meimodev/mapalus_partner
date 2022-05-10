import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mapalus_partner/data/repo/app_repo.dart';
import 'package:mapalus_partner/shared/enums.dart';
import 'package:mapalus_partner/shared/routes.dart';

class SigningController extends GetxController {
  AppRepo appRepo = Get.find();

  TextEditingController tecSigning = TextEditingController();
  Rx<String> errorText = "".obs;
  String? message;

  String phone = "";
  String name = '';

  Rx<CardSigningState> signingState = CardSigningState.oneTimePassword.obs;
  RxBool isLoading = false.obs;

  TextEditingController tecPhone = TextEditingController();
  TextEditingController tecPassword = TextEditingController();

  late Box box;

  @override
  Future<void> onReady() async {
    super.onReady();

    isLoading.value = true;
    await Future.delayed(1.seconds);
    if (!await appRepo.checkIfLatestVersion()) {
      Get.offNamed(Routes.updateApp);
      return;
    }

    box = await Hive.openBox('signing');

    bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);

    if (isLoggedIn) {
      Get.rawSnackbar(message: "Already signed in");
      Get.offNamed(Routes.home);
      return;
    }
    isLoading.value = false;
  }

  void onPressedSignIn() {
    errorText.value = "";
    final phone = tecPhone.text.trim();
    final pass = tecPassword.text.trim();

    if (phone.isEmpty) {
      errorText.value = "Phone cannot be empty";
      return;
    }

    if (pass.isEmpty) {
      errorText.value = "Password cannot be empty";
      return;
    }

    if (phone == "089525699078" && pass == "089525699078") {
      //hive signing
      box.put('isLoggedIn', true);

      Get.rawSnackbar(message: "Successfully signed in");
      Get.offNamed(Routes.home);
      return;
    }

    errorText.value = "invalid phone & password combination";
  }
}