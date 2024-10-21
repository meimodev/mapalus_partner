import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';

class ProductsController extends GetxController {
  final ProductRepo productRepo = Get.find();
  final PartnerRepo partnerRepo = Get.find();

  RxBool loading = true.obs;

  List<Product> products = [];
  List<Product> tempSearchProduct = [];

  @override
  void onReady() {
    super.onReady();
    listenToProducts();
  }

  void listenToProducts() async {
    final partner = await partnerRepo.getCurrentPartner();
    final streamProduct = productRepo.readProductsStream(
      GetProductRequest(
        partnerId: partner!.id,
      ),
    );

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
