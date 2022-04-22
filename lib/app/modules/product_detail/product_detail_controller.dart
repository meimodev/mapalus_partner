import 'package:get/get.dart';
import 'package:mapalus_partner/data/models/product.dart';

class ProductDetailController extends GetxController {
  RxBool isAdding = false.obs;
  late Product product;

  @override
  void onInit() {
    var _product = Get.arguments;
    if (_product == null) {
      isAdding.value = true;
    } else {
      isAdding.value = false;
      product = _product;
    }

    super.onInit();
  }
}