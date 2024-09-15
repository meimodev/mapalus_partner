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
    fetchOrders();
  }

  void fetchOrders() async {
    loading.value = true;
    orders = await orderRepo.readOrders(
      GetOrdersRequest(
        partner: Partner(
          id: 'ssTneIKTUTtnb8L4dGWA',
          name: "test partner",
          lastActiveTimeStamp: DateTime.now(),
        ),
      ),
    );
    loading.value = false;
  }
}
