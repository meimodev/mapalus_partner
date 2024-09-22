import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
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

  void onPressedImage() {
    Get.rawSnackbar(message: "Image selection not yet implemented -_-");
  }

  Future<void> onPressedSaveButton() async {
    loading.value = true;
    clearErrors();
    await Future.delayed(const Duration(milliseconds: 400));
    //run validation from product object

    // errorTextImage = Validator(
    //   value: product?.image ?? "",
    //   name: "Gambar",
    // ).notEmpty().validate();

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

    // errorTextCustomPrice = Validator(
    //   value: product?.customPrice.toString() ?? "",
    //   name: "Harga Custom",
    // ).validate();
    //
    // errorTextMinimumPrice = Validator(
    //   value: product?.minimumPrice.toString() ?? "",
    //   name: "Harga Minimal",
    // ).notEmptyOrZero().validate();

    final error = Validator.errorCount != 0;

    loading.value = false;

    if (error) {
      print("error $error");
      return;
    }

    print("VALIDATED");

    //save the updated product
    // product.name = tecName.text.trim();
    // product.description = tecDescription.text.trim();
    // product.price = int.parse(tecPrice.text.trim());
    // product.unit = tecUnit.text.trim();
    // product.weight = double.parse(tecWeight.text.trim());
    // product.category = tecCategory.text.trim();
    // product.isAvailable = isAvailable.value;
    // product.isCustomPrice = isCustomPrice.value;
    // product.minimumPrice = int.tryParse( tecMinimumPrice.text.trim()) ?? 0;

    // if (adding) {
    //   await productRepo.createProduct(product);
    // } else {
    //   await productRepo.updateProduct(product);
    // }

    // Get.back();
    // Get.rawSnackbar(message: "Successfully ${adding ? "Added" : "Updated"}");
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

  void onPressedDelete(String productId) {
    // Get.dialog(
    //   DialogConfirm(
    //     title: "Heads up !",
    //     description: "You're about to delete ${product.name}",
    //     confirmText: "CONFIRM",
    //     onPressedConfirm: () async {
    //       loading.value = true;
    //       await productRepo.deleteProduct(productId);
    //       Get.back();
    //       Get.rawSnackbar(message: "${product.name} deleted");
    //       shouldUpdateHomeControllerProducts = true;
    //       isDeletion = true;
    //     },
    //   ),
    // );
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
