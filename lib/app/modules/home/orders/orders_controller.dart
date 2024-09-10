import 'package:get/get.dart';

class OrdersController extends GetxController {
  // OrderRepo orderRepo = Get.find();
  // UserRepo userRepo = Get.find();
  //
  // RxList<OrderApp> orders = <OrderApp>[].obs;

  RxBool isLoading = false.obs;

  @override
  void onReady() {
    //populate orders
    // _populateOrders();
    super.onReady();
  }

  // _populateOrders() async {
  // isLoading.value = true;
  // orders.value = await orderRepo.readOrders(userRepo.signedUser!);
  // isLoading.value = false;
  // }
}
