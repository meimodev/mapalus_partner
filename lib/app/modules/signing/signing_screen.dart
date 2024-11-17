import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/widgets.dart';
import 'package:mapalus_partner/app/modules/signing/signing_controller.dart';

class SigningScreen extends GetView<SigningController> {
  const SigningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      backgroundColor: BaseColor.primary3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: BaseSize.w24,
              vertical: BaseSize.h24,
            ),
            decoration: BoxDecoration(
              color: BaseColor.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(BaseSize.radiusMd),
              ),
            ),
            child: Obx(
              () => LoadingWrapper(
                addedWidget: Text(
                  "Tunggu sebentar yaa, Loading mungkin agak lama",
                  style: BaseTypography.bodyMedium,
                ),
                loading: controller.loading.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    controller.signingState != SigningState.verifyNumber
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InputWidget.text(
                                label: "Masuk dengan akun mapalus anda",
                                hint: "Nomor Hand Phone",
                                currentInputValue: controller.phone,
                                textInputType: TextInputType.phone,
                                backgroundColor: BaseColor.editable,
                                borderColor: BaseColor.accent,
                                errorText: controller.errorText,
                                onChanged: controller.onChangedPhone,
                              ),
                              Gap.h24,
                              ButtonWidget(
                                text: "Masuk",
                                onPressed: controller.onPressedSignIn,
                              ),
                            ],
                          ),
                    controller.signingState != SigningState.otp
                        ? const SizedBox()
                        : PinPickerWidget(
                            controller: controller.pinController,
                            label: 'OTP telah terkirim di ${controller.phone}',
                            errorText: controller.errorText,
                            onCompletedPin: controller.onCompletedPin,
                          ),
                    controller.signingState != SigningState.unregistered
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Maaf, Akun anda tidak terdaftar dengan partner kami",
                                style: BaseTypography.headlineMedium.toBold,
                                textAlign: TextAlign.center,
                              ),
                              Gap.h12,
                              Text(
                                "Kami tidak menemukan akun dengan nomor telpon "
                                "${controller.phone.phoneCleanUseZero}, "
                                "terhubung dengan salah satu partner kami.\n"
                                "Silahkan hubungi call center kami jika anda berpikir "
                                "ini adalah adalah kesalahan sistem",
                                style: BaseTypography.bodySmall.toSecondary,
                                textAlign: TextAlign.center,
                              ),
                              Gap.h24,
                              ButtonWidget(
                                text: "Kembali",
                                onPressed: () => SystemNavigator.pop(),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
