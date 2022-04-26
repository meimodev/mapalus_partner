import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mapalus_partner/app/modules/home/home_controller.dart';
import 'package:mapalus_partner/app/widgets/dialog_confirm.dart';
import 'package:mapalus_partner/data/models/order.dart';
import 'package:mapalus_partner/data/models/product_order.dart';
import 'package:mapalus_partner/data/models/rating.dart';
import 'package:mapalus_partner/data/repo/order_repo.dart';
import 'package:mapalus_partner/shared/enums.dart';
import 'package:mapalus_partner/shared/values.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailController extends GetxController {
  OrderRepo orderRepo = Get.find();
  HomeController homeController = Get.find();

  RxList<ProductOrder> productOrders = <ProductOrder>[].obs;
  RxString id = ''.obs;

  RxString orderTime = ''.obs;
  RxString finishTime = ''.obs;

  RxString productTotal = ''.obs;
  RxString productCount = ''.obs;
  RxString deliveryTotal = ''.obs;
  RxString deliveryCount = ''.obs;
  RxString deliveryTime = ''.obs;
  RxString deliveryCoordinate = ''.obs;
  RxString totalPrice = ''.obs;

  RxBool isLoading = false.obs;

  Rx<OrderStatus> orderStatus = OrderStatus.placed.obs;
  Rx<Rating> orderRating = Rating.zero().obs;

  late Order _order;
  bool shouldRefresh = false;

  @override
  void onClose() {
    if (shouldRefresh) {
      homeController.refreshOrders();
    }
    super.onClose();
  }

  @override
  void onInit() {
    Order order = Get.arguments as Order;
    _order = order;
    productOrders.value = order.products;
    id.value = order.id!;

    var _orderTimeStamp = order.orderTimeStamp;
    orderTime.value = _orderTimeStamp == null
        ? '-'
        : _orderTimeStamp.format(Values.formatRawDate);

    var _finishTimeStamp = order.finishTimeStamp;
    finishTime.value = _finishTimeStamp == null
        ? '-'
        : _finishTimeStamp.format(Values.formatRawDate);

    productCount.value = order.orderInfo.productCountF;
    productTotal.value = order.orderInfo.productPriceF;
    deliveryCount.value = order.orderInfo.deliveryWeightF;
    deliveryTotal.value = order.orderInfo.deliveryPriceF;
    deliveryTime.value = order.orderInfo.deliveryTime;
    deliveryCoordinate.value = order.orderInfo.deliveryCoordinateF;
    totalPrice.value = order.orderInfo.totalPrice;
    orderRating.value = order.rating;

    orderStatus.value = order.status;

    super.onInit();
  }

  onPressedNegative() async {
    Get.dialog(DialogConfirm(
      description:
          "Anda akan melakukan penolakan pesanan, konfirmasi untuk penolakan",
      title: "PERHATIAN !",
      confirmText: "TOLAK",
      onPressedConfirm: () async {
        isLoading.value = true;
        _order.status = OrderStatus.rejected;
        await orderRepo.updateOrderStatus(order: _order);
        orderStatus.value = OrderStatus.rejected;
        shouldRefresh = true;
        isLoading.value = false;
      },
    ));
    //alter this order in database to orderstatus.accepted
  }

  onPressedPositive() async {
    isLoading.value = true;
    //alter this order in database to orderstatus.accepted
    _order.status = OrderStatus.accepted;
    await orderRepo.updateOrderStatus(order: _order);
    orderStatus.value = OrderStatus.accepted;
    shouldRefresh = true;
    isLoading.value = false;
  }

  onPressedFinishOrder() async {
    print("pressed finish");
    isLoading.value = true;
    orderStatus.value = OrderStatus.finished;
    await orderRepo.rateOrder(
      _order,
      Rating(
        1,
        0,
        "From Partner",
        Jiffy(),
      ),
    );
    isLoading.value = false;
  }

  onPressedViewMaps() {
    var _latitude = _order.orderInfo.deliveryCoordinate.latitude;
    var _longitude = _order.orderInfo.deliveryCoordinate.longitude;
    var _url =
        'https://www.google.com/maps/search/?api=1&query=$_latitude,$_longitude';
    launch(_url);
  }
}