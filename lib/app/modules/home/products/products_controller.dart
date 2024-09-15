import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class ProductsController extends GetxController {
  final ProductRepo productRepo = Get.find();

  RxBool loading = true.obs;

  List<Product> products = [];
  List<Product> tempSearchProduct = [];

  @override
  void onReady() {
    super.onReady();
    listenToProducts();
    // fetchProducts();
  }

  void listenToProducts() {
    final streamProduct = productRepo.readProductsStream(
        const GetProductRequest(partnerId: "ssTneIKTUTtnb8L4dGWA"));

    streamProduct.listen(
      (event) {
        loading.value = true;

        products = event;
        tempSearchProduct = List.of(products);

        loading.value = false;
      },
    );
  }

  void onChangedSearchText(String value) async {
    loading.value = true;
    products = await productRepo.searchProduct(
      tempSearchProduct,
      value,
    );
    loading.value = false;
  }

  void addProduct(Product product) async {
    await productRepo.createProduct(product);
  }
}
