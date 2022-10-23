import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/home/home_controller.dart';
import 'package:mapalus_partner/app/widgets/dialog_confirm.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class ProductDetailController extends GetxController {
  ProductRepo productRepo = Get.find();
  HomeController homeController = Get.find();

  RxBool isAdding = false.obs;
   Product product = Product.empty();

  TextEditingController tecName = TextEditingController();
  TextEditingController tecDescription = TextEditingController();
  TextEditingController tecPrice = TextEditingController();
  TextEditingController tecUnit = TextEditingController();
  TextEditingController tecWeight = TextEditingController();
  TextEditingController tecCategory = TextEditingController();
  TextEditingController tecMinimumPrice = TextEditingController();
  RxBool isAvailable = true.obs;
  RxBool isCustomPrice = false.obs;

  RxString errorText = "".obs;
  RxBool saving = false.obs;
  bool shouldUpdateHomeControllerProducts = false;
  bool isDeletion = false;

  List<String> categories = [
    'Bahan Makanan',
    'Lauk Pauk',
    'Bumbu Dapur',
    'Sayuran',
    'Buah',
    'Bahan Kue'
  ];

  var isLoading = true.obs;

  @override
  void onInit() {
    isLoading.value = true;
    var args = Get.arguments;
    if (args == null) {
      isAdding.value = true;
    } else {
      isAdding.value = false;
      product = args;
      _initTextFields();
    }

    isLoading.value = false;
    super.onInit();
  }

  @override
  void dispose() {
    tecName.dispose();
    tecDescription.dispose();
    tecPrice.dispose();
    tecUnit.dispose();
    tecWeight.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    if (shouldUpdateHomeControllerProducts) {
      homeController.updateProductList(product, isDeletion: isDeletion);
    }
    super.onClose();
  }

  _initTextFields() {

    tecName.text = product.name;
    tecDescription.text = product.description;
    tecPrice.text = product.price.toString();
    tecUnit.text = product.unit;
    tecWeight.text = product.weight.toInt().toString();
    tecCategory.text = product.category;
    tecMinimumPrice.text = product.minimumPrice.toString();
    isAvailable.value = product.isAvailable;
    isCustomPrice.value = product.isCustomPrice;
  }

  void onPressedAvailableCheckbox(bool? value) {
    isAvailable.toggle();
  }

  void onPressedCustomPriceCheckbox(bool? value) {
    isCustomPrice.toggle();
    tecMinimumPrice.text = "0";
  }

  void onPressedImage() {
    Get.rawSnackbar(message: "Image selection not yet implemented -_-");
  }

  Future<void> onPressedSaveButton() async {
    isLoading.value = true;

    saving.value = true;
    errorText.value = "";

    //validate if not empty except description

    List<String> texts = [
      tecName.text,
      tecPrice.text,
      tecUnit.text,
      tecWeight.text,
      tecCategory.text
    ];

    for (String t in texts) {
      if (t.isEmpty) {
        isLoading.value = false;
        errorText.value = "Only 'description' that can be empty";
        saving.value = false;
        return;
      }
    }

    texts = [tecPrice.text, tecWeight.text];
    for (String t in texts) {
      if (!t.isNumericOnly) {
        isLoading.value = false;
        errorText.value = "Price & Weight can only contain numbers";
        saving.value = false;
        return;
      }
    }

    //save the updated product
    product.name = tecName.text.trim();
    product.description = tecDescription.text.trim();
    product.price = int.parse(tecPrice.text.trim());
    product.unit = tecUnit.text.trim();
    product.weight = double.parse(tecWeight.text.trim());
    product.category = tecCategory.text.trim();
    product.isAvailable = isAvailable.value;
    product.isCustomPrice = isCustomPrice.value;
    product.minimumPrice = int.tryParse( tecMinimumPrice.text.trim()) ?? 0;

    if (isAdding.isTrue) {
      await productRepo.createProduct(product);
    } else {
      await productRepo.updateProduct(product);
    }

    shouldUpdateHomeControllerProducts = true;

    Get.back();
    Get.rawSnackbar(
        message: "Successfully ${isAdding.isTrue ? "Added" : "Updated"}");
  }

  void onPressedDelete(String productId) {
    Get.dialog(
      DialogConfirm(
        title: "Heads up !",
        description: "You're about to delete ${product.name}",
        confirmText: "CONFIRM",
        onPressedConfirm: () async {
          isLoading.value = true;
          await productRepo.deleteProduct(productId);
          Get.back();
          Get.rawSnackbar(message: "${product.name} deleted");
          shouldUpdateHomeControllerProducts = true;
          isDeletion = true;
        },
      ),
    );
  }
}