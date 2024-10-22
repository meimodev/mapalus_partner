import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_partner/shared/routes.dart';

enum SigningState {
  verifyNumber,
  otp,
  unregistered,
}

class SigningController extends GetxController {
  final appRepo = Get.find<AppRepo>();
  final userRepo = Get.find<UserRepo>();
  final partnerRepo = Get.find<PartnerRepo>();

  String errorText = "";

  String phone = "";

  RxBool loading = true.obs;

  SigningState signingState = SigningState.verifyNumber;

  final pinController = TextEditingController();

  @override
  Future<void> onReady() async {
    super.onReady();

    await _loading(true);

    initSigningCallback();

    await _loading(false);
  }

  initSigningCallback() {
    userRepo.onSuccessSigning = (user) async {
      await _loading(true);

      // then then get the user in firestore
      if ((user.partnerId ?? "").isEmpty) {
        signingState = SigningState.unregistered;
        await userRepo.signOut();
        // await Future.delayed(Duration(milliseconds: 500));
        await _loading(false);
        print("[SIGNING CONTROLLER] Signing Success but no partner registered");
        return;
      }
      print("[SIGNING CONTROLLER] Signing Success $user");
      Get.offNamed(Routes.home);
    };

    userRepo.onUnregisteredUser = (user) async {
      await _loading(true);
      signingState = SigningState.unregistered;
      await userRepo.signOut();
      // await Future.delayed(Duration(milliseconds: 500));
      await _loading(false);
    };
  }

  Future<void> onPressedSignIn() async {
    await _loading(true);
    Validator.resetErrorCounter();

    errorText = Validator(
      value: phone,
      name: "Nomor Handphone",
    ).notEmptyOrZero().mustStartsWith("0").validate();

    if (Validator.hasError()) {
      await _loading(false);
      return;
    }

    // userRepo.testOnSucess(phone);

    await userRepo.requestOTP(
      phone,
      (result) async {
        if (result.error) {
          errorText = result.message;
          pinController.text = "";
          await _loading(false);
          return;
        }
        if (result.message.contains("MANUAL_VERIFICATION")) {
          signingState = SigningState.otp;
          errorText = "";
          await _loading(false);
        }
      },
    );
  }

  void onChangedPhone(String value) {
    phone = value;
  }

  void onCompletedPin(String otp) async {
    await _loading(true);
    await userRepo.verifyOTP(
      otp,
      (result) async {
        if (result.error) {
          errorText = result.message;
          pinController.text = "";
          await _loading(false);
          return;
        }
      },
    );
  }

  Future<void> _loading(bool value) async {
    if (loading.value == value) return;
    await Future.delayed(const Duration(milliseconds: 300));
    loading.value = value;
  }
}
