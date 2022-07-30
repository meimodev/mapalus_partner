import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mapalus_partner/app/modules/home/home_controller.dart';
import 'package:mapalus_partner/app/widgets/dialog_confirm.dart';
import 'package:mapalus_partner/data/models/order.dart';
import 'package:mapalus_partner/data/models/product_order.dart';
import 'package:mapalus_partner/data/models/rating.dart';
import 'package:mapalus_partner/data/models/user_app.dart';
import 'package:mapalus_partner/data/repo/order_repo.dart';
import 'package:mapalus_partner/shared/enums.dart';
import 'package:mapalus_partner/shared/routes.dart';
import 'package:mapalus_partner/shared/values.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  Rx<OrderStatus> orderStatus = OrderStatus.placed.obs;
  Rx<Rating> orderRating = Rating.empty().obs;

  late Order _order;
  bool shouldRefresh = false;

  RxBool canLoading = true.obs;

  UserApp? orderingUser;

  @override
  Future<void> onInit() async {
    canLoading.value = true;
    await Future.delayed(600.milliseconds);
    Order order = Get.arguments as Order;
    _order = order;
    productOrders.value = order.products;
    id.value = order.idMinified;

    var orderTimeStamp = order.orderTimeStamp;
    orderTime.value = orderTimeStamp == null
        ? '-'
        : orderTimeStamp.format(Values.formatRawDate);

    var finishTimeStamp = order.finishTimeStamp;
    finishTime.value = finishTimeStamp == null
        ? '-'
        : finishTimeStamp.format(Values.formatRawDate);

    productCount.value = order.orderInfo.productCountF;
    productTotal.value = order.orderInfo.productPriceF;
    deliveryCount.value = order.orderInfo.deliveryWeightF;
    deliveryTotal.value = order.orderInfo.deliveryPriceF;
    deliveryTime.value = order.orderInfo.deliveryTime;
    deliveryCoordinate.value = order.orderInfo.deliveryCoordinateF;
    totalPrice.value = order.orderInfo.totalPrice;
    orderRating.value = order.rating;
    orderingUser = order.orderingUser;

    orderStatus.value = order.status;

    super.onInit();
    canLoading.value = false;
  }

  onPressedNegative() async {
    Get.dialog(DialogConfirm(
      description:
          "Anda akan melakukan penolakan pesanan, konfirmasi untuk penolakan",
      title: "PERHATIAN !",
      confirmText: "TOLAK",
      onPressedConfirm: () async {
        canLoading.value = true;
        _order.status = OrderStatus.rejected;
        await orderRepo.updateOrderStatus(order: _order);
        orderStatus.value = OrderStatus.rejected;
        shouldRefresh = true;
        await Future.delayed(600.milliseconds);

        canLoading.value = false;
      },
    ));
    //alter this order in database to orderstatus.accepted
  }

  onPressedPositive() async {
    canLoading.value = true;
    //alter this order in database to orderstatus.accepted
    _order.status = OrderStatus.accepted;
    await orderRepo.updateOrderStatus(order: _order);
    orderStatus.value = OrderStatus.accepted;
    shouldRefresh = true;
    await Future.delayed(600.milliseconds);
    Get.until(ModalRoute.withName(Routes.home));
  }

  onPressedFinishOrder() async {
    canLoading.value = true;
    orderStatus.value = OrderStatus.finished;
    await Future.delayed(const Duration(seconds: 1));
    var rating = Rating(
      0,
      "From Partner",
      Jiffy(),
    );
    await orderRepo.rateOrder(
      _order,
      rating,
    );
    orderRating.value = rating;
    canLoading.value = false;
  }

  onPressedViewMaps() {
    var latitude = _order.orderInfo.deliveryCoordinate.latitude;
    var longitude = _order.orderInfo.deliveryCoordinate.longitude;
    var url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    launchUrlString(url);
  }
}