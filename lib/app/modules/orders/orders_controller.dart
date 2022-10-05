import 'package:get/get.dart';
import 'package:mapalus_partner/data/models/order.dart';
import 'package:mapalus_partner/data/repo/order_repo.dart';
import 'package:mapalus_partner/data/repo/user_repo.dart';

class OrdersController extends GetxController {
  OrderRepo orderRepo = Get.find();
  UserRepo userRepo = Get.find();

  RxList<Order> orders = <Order>[].obs;

  RxBool isLoading = false.obs;

  @override
  void onReady() {
    //populate orders
    _populateOrders();
    super.onReady();
  }

  _populateOrders() async {
    isLoading.value = true;
    // orders.value = await orderRepo.readOrders(userRepo.signedUser!);
    isLoading.value = false;
  }
}