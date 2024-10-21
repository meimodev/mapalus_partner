import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/widgets.dart';
import 'package:mapalus_partner/app/modules/modules.dart';
import 'package:mapalus_partner/app/widgets/card_navigation.dart';
import 'package:mapalus_partner/app/widgets/image_picker_widget.dart';
import 'package:mapalus_partner/app/widgets/location_picker_widget.dart';
import 'package:mapalus_partner/main.dart';

class PartnerSettingsScreen extends GetView<PartnerSettingsController> {
  const PartnerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Obx(
        () => LoadingWrapper(
          loading: controller.loading.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardNavigation(
                title:
                    'Edit Partner \n ${controller.user!.name} - ${controller.user!.phone}',
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: BaseSize.w24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Gap.h24,
                      ImagePickerWidget(
                        label: "Gambar Partner",
                        imageUrl: controller.partner.image,
                        errorText: controller.errorTextImage,
                        onChangedImage: controller.onChangedImage,
                        cameras: cameras,
                        height: BaseSize.customHeight(250),
                      ),
                      Gap.h12,
                      InputWidget.text(
                        backgroundColor: BaseColor.white,
                        hint: "Nama",
                        label: "Nama",
                        errorText: controller.errorTextName,
                        currentInputValue: controller.partner.name,
                        onChanged: controller.onChangedName,
                      ),
                      Gap.h12,
                      LocationPickerWidget(
                        label: "Lokasi",
                        hint: 'Pilih Lokasi',
                        errorText: controller.errorTextLocation,
                        currentValue: controller.partner.location,
                        onChanged: controller.onChangedLocation,
                      ),
                      Gap.h12,
                      InputWidget.text(
                        backgroundColor: BaseColor.white,
                        hint: "Nama Kota",
                        label: "Nama Kota",
                        errorText: controller.errorTextPlaceName,
                        currentInputValue: controller.partner.location?.place,
                        onChanged: controller.onChangedPlaceName,
                      ),
                      Gap.h24,
                      ButtonWidget(
                        text: "Simpan Data",
                        padding: EdgeInsets.symmetric(
                          vertical: BaseSize.h12,
                        ),
                        onPressed: () => controller.onPressedSaveButton(
                          onSuccess: (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Edit Partner Berhasil"),
                              ),
                            );
                            Navigator.pop(context, value);
                          },
                          onNotValid: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Input belum valid"),
                            ),
                          ),
                        ),
                      ),
                      Gap.h24,
                      ButtonWidget(
                        text: "Keluar dari akun",
                        textColor: BaseColor.negative,
                        backgroundColor: BaseColor.accent,
                        padding: EdgeInsets.symmetric(
                          vertical: BaseSize.h12,
                        ),
                        onPressed: () {
                          showSimpleConfirmationDialogWidget(
                            context: context,
                            action: "Keluar",
                            onPressedPositive: controller.onSignOut,
                          );
                        },
                      ),
                      Gap.h24,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
