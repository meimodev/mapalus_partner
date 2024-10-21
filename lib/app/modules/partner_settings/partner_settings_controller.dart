import 'dart:io';

import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_partner/shared/routes.dart';

class PartnerSettingsController extends GetxController {
  final partnerRepo = Get.find<PartnerRepo>();
  final userRepo = Get.find<UserRepo>();

  late Partner partner;
  UserApp? user;

  var loading = true.obs;

  String errorTextImage = "";
  String errorTextName = "";
  String errorTextLocation = "";
  String errorTextPlaceName = "";

  @override
  void onInit() async {
    super.onInit();

    loading.value = true;

    final args = Get.arguments;
    if (args == null) {
      throw Exception(
        "partner_settings_controller.dart need an Partner object as GetX argument",
      );
    }
    partner = args as Partner;
    user = await userRepo.getSignedUser();

    loading.value = false;
  }

  Future<void> onPressedSaveButton({
    required void Function(Partner updatedPartner) onSuccess,
    required void Function() onNotValid,
  }) async {
    loading.value = true;
    clearErrors();

    await Future.delayed(const Duration(milliseconds: 400));

    errorTextImage = Validator(
      value: partner.image,
      name: "Gambar",
    ).notEmptyOrZero().validate();

    errorTextName = Validator(
      value: partner.name,
      name: "Nama Toko",
    ).notEmptyOrZero().notMoreThan(100).validate();

    errorTextLocation = Validator(
      value: partner.location != null ? "Location" : "",
      name: "Lokasi",
    ).notEmptyOrZero().validate();

    errorTextPlaceName = Validator(
      value: partner.location?.place ?? "",
      name: "Nama Kota",
    ).notEmptyOrZero().notMoreThan(100).validate();

    final error = Validator.errorCount != 0;

    if (error) {
      onNotValid();
      loading.value = false;
      return;
    }

    final imageUrl = partner.image.contains("http");
    if (!imageUrl) {
      final url = await uploadImage();
      partner = partner.copyWith(image: url);
    }
    await partnerRepo.updatePartner(
      UpdatePartnerRequest(
        partner: partner.copyWith(
          lastActiveTimeStamp: DateTime.now(),
        ),
      ),
    );

    onSuccess(partner);
  }

  Future<String> uploadImage() async {
    final imageUrl = await partnerRepo.uploadImage(
      File(partner.image),
      partner.id,
    );
    if (imageUrl == null) {
      Get.snackbar(
        "Upload Gambar Gagal",
        "Koneksi bermasalah. Silahkan coba sesaat lagi.",
      );
    }
    return imageUrl!;
  }

  void clearErrors() {
    Validator.resetErrorCounter();

    errorTextName = "";
    errorTextImage = "";
    errorTextLocation = "";
    errorTextPlaceName = "";
  }

  void onChangedImage(File image) {
    partner = partner.copyWith(image: image.path);
  }

  void onChangedName(String value) {
    partner = partner.copyWith(name: value);
  }

  void onChangedLocation(double latitude, double longitude) {
    partner = partner.copyWith(
      location: partner.location!.copyWith(
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  void onChangedPlaceName(String value) {
    partner = partner.copyWith(
      location: partner.location!.copyWith(
        place: value,
      ),
    );
  }

  void onSignOut() async {
    await userRepo.signOut();
    Get.offAllNamed(Routes.home);
  }
}
