import 'package:get/get.dart';
import 'package:mapalus_partner/data/models/order.dart';
import 'package:mapalus_partner/data/models/product.dart';
import 'package:mapalus_partner/data/repo/order_repo.dart';
import 'package:mapalus_partner/data/repo/product_repo.dart';
import 'package:mapalus_partner/data/repo/user_repo.dart';
import 'package:mapalus_partner/shared/routes.dart';

class HomeController extends GetxController {
  UserRepo userRepo = Get.find<UserRepo>();
  OrderRepo orderRepo = Get.find<OrderRepo>();
  ProductRepo productRepo = Get.find<ProductRepo>();

  RxList<Order> orders = <Order>[].obs;
  RxList<Product> products = <Product>[].obs;

  var isLoading = false.obs;
  var activeNavBottomIndex = 1.obs;

  //TODO gonna need to replace this list implementation with infinite scrolling implementation

  @override
  void onInit() {
    _loadOrders();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onPressedProducts() {
    activeNavBottomIndex.value = 2;
    _loadProducts();
  }

  void onPressedOrders() {
    activeNavBottomIndex.value = 1;
    _loadOrders();
  }

  _loadOrders() async {
    isLoading.value = true;
    // await Future.delayed(1.seconds);
    var _orders = await orderRepo.readAllOrders(0, 0);
    orders.value = List<Order>.from(_orders.reversed);

    //show the list on screen
    isLoading.value = false;
  }

  _loadProducts() async {
    isLoading.value = true;
    // await Future.delayed(1.seconds);

    var _orders = await productRepo.readProducts(0, 0);
    products.value = List<Product>.from(_orders.reversed);

    //show the list on screen
    isLoading.value = false;
  }

  void onPressedAddButton() {
    Get.toNamed(Routes.productDetail, arguments: null);
  }

  void refreshOrders() {
    _loadOrders();
  }
}