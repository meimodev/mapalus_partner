import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_partner/app/modules/home/home_controller.dart';
import 'package:uuid/uuid.dart';

class ProductDetailController extends GetxController {
  ProductRepo productRepo = Get.find();
  HomeController homeController = Get.find();

  bool adding = false;
  Product? product;

  RxBool isAvailable = true.obs;
  RxBool isCustomPrice = false.obs;

  RxBool saving = false.obs;
  bool isDeletion = false;

  var loading = true.obs;

  List<String> availableCategories = [];

  String errorTextType = "";
  String errorTextName = "";
  String errorTextImage = "";
  String errorTextDescription = "";
  String errorTextPrice = "";
  String errorTextUnit = "";
  String errorTextWeight = "";
  String errorTextCategory = "";
  String errorTextStatus = "";

  // String errorTextCustomPrice = "";
  // String errorTextMinimumPrice = "";

  @override
  void onInit() {
    super.onInit();

    loading.value = true;

    var args = Get.arguments;
    adding = args == null;
    if (args != null) {
      product = args;
    } else {
      product = Product(id: const Uuid().v4());
    }

    fetchCategories();

    loading.value = false;
  }

  void fetchCategories() async {
    final res = await productRepo.getCategories();
    availableCategories = res;
  }

  void onPressedAvailableCheckbox(bool? value) {
    isAvailable.toggle();
  }

  void onPressedCustomPriceCheckbox(bool? value) {
    isCustomPrice.toggle();
  }

  void onChangedImage(File image) {
    product = product!.copyWith(image: image.path);
  }

  Future<void> onPressedSaveButton({
    required void Function(bool adding) onSuccess,
    required VoidCallback onNotValid,
  }) async {
    loading.value = true;
    clearErrors();

    await Future.delayed(const Duration(milliseconds: 400));

    errorTextImage = Validator(
      value: product?.image ?? "",
      name: "Gambar",
    ).notEmptyOrZero().validate();

    errorTextType = Validator(
      value: product?.type?.name ?? "",
      name: "Tipe",
    ).notEmptyOrZero().validate();

    errorTextName = Validator(
      value: product?.name ?? "",
      name: "Nama",
    ).notEmptyOrZero().notMoreThan(40).validate();

    errorTextDescription = Validator(
      value: product?.description ?? "",
      name: "Deskripsi",
    ).validate();

    errorTextPrice = Validator(
      value: product?.price.toString() ?? "",
      name: "Harga",
    ).notEmptyOrZero().validate();

    errorTextUnit = Validator(
      value: product?.unit?.name ?? "",
      name: "Unit",
    ).notEmptyOrZero().validate();

    errorTextWeight = Validator(
      value: product?.weight.toString() ?? "",
      name: "Berat",
    ).notEmptyOrZero().validate();

    errorTextCategory = Validator(
      value: product?.category ?? "",
      name: "Kategori",
    ).notEmptyOrZero().validate();

    errorTextStatus = Validator(
      value: product?.status?.name ?? "",
      name: "Status",
    ).notEmptyOrZero().validate();

    final error = Validator.errorCount != 0;

    if (error) {
      onNotValid();
      loading.value = false;
      return;
    }

    if (adding) {
      final imageUrl = await uploadImage();
      product = product!.copyWith(image: imageUrl);
      await productRepo.createProduct(product!);
    } else {
      final imageUrl = product!.image.contains("http");
      if (!imageUrl) {
        final url = await uploadImage();
        product = product!.copyWith(image: url);
      }
      await productRepo.updateProduct(product!);
    }

    Get.back();
    onSuccess(adding);
    loading.value = false;
  }

  Future<String> uploadImage() async {
    final imageUrl = await productRepo.uploadProductImage(
      File(product!.image),
      product!.id,
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

    errorTextType = "";
    errorTextName = "";
    errorTextImage = "";
    errorTextDescription = "";
    errorTextPrice = "";
    errorTextUnit = "";
    errorTextWeight = "";
    errorTextCategory = "";
    errorTextStatus = "";
    // errorTextCustomPrice = "";
    // errorTextMinimumPrice = "";
  }

  void onPressedDelete(String productId) async {
    loading.value = true;
    await productRepo.deleteProduct(productId);
    loading.value = false;
    Get.back();
  }

  void onChangedName(String value) {
    product = product!.copyWith(name: value);
  }

  void onChangedDescription(String value) {
    product = product!.copyWith(description: value);
  }

  void onChangedPrice(String value) {
    product = product!.copyWith(price: double.tryParse(value) ?? 0);
  }

  void onChangedUnit(ProductUnit value) {
    product = product!.copyWith(unit: value);
  }

  void onChangedWeight(String value) {
    product = product!.copyWith(weight: double.tryParse(value) ?? 0);
  }

  void onChangedCategory(String value) {
    product = product!.copyWith(category: value);
  }

  void onChangedMinimumPrice(String value) {
    product = product!.copyWith(minimumPrice: double.tryParse(value) ?? 0);
  }

  void onChangedType(ProductType value) {
    product = product!.copyWith(type: value);
  }

  void onChangedCustomPrice(bool value) {
    product = product!.copyWith(customPrice: value);
  }

  void onChangedStatus(ProductStatus value) {
    product = product!.copyWith(status: value);
  }
}
