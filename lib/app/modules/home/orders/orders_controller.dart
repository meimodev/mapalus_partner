import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';

class OrdersController extends GetxController {
  OrderRepo orderRepo = Get.find();
  List<OrderApp> orders = [];

  RxBool loading = true.obs;

  @override
  void onReady() {
    super.onReady();
    listenToProducts();
  }

  Future<void> listenToProducts() async {
    loading.value = true;
    const request = GetOrdersRequest(
      partnerId: "ssTneIKTUTtnb8L4dGWA",
    );
    final streamOrders = orderRepo.readOrdersStream(request);

    streamOrders.listen(
      (event) {
        loading.value = true;
        orders = event;
        loading.value = false;
      },
    );

    orders = await orderRepo.readOrders(request);
    loading.value = false;
  }
}
