import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapalus_partner/data/models/delivery_info.dart';
import 'package:mapalus_partner/data/models/order_info.dart';
import 'package:mapalus_partner/data/models/product_order.dart';
import 'package:mapalus_partner/data/repo/app_repo.dart';
import 'package:mapalus_partner/data/repo/order_repo.dart';
import 'package:mapalus_partner/shared/routes.dart';
import 'package:mapalus_partner/shared/utils.dart';

class LocationController extends GetxController {
  AppRepo appRepo = Get.find();

  RxBool isLocationSelectionVisible = true.obs;
  RxBool isLocationSelectionButtonVisible = true.obs;


  Rx<OrderInfo> orderInfo = OrderInfo(
    productCount: 0,
    productPrice: 0,
    deliveryWeight: 0,
    deliveryPrice: 0,
    deliveryDistance: 0,
    deliveryCoordinate: const LatLng(0, 0),
    deliveryTime: '',
  ).obs;

  RxDouble distance = 0.0.obs;
  RxDouble weight = 2.0.obs;

  DeliveryInfo? _selectedDeliveryInfo;

  late RxList<DeliveryInfo> deliveries;

  OrderRepo orderRepo = Get.find<OrderRepo>();

  LatLng? deliveryCoordinate;

  @override
  void onInit() async {
    var d = await appRepo.getDeliveryTimes();
    deliveries = d.map((e) => DeliveryInfo.fromJSON(e)).toList().obs;

    var args = Get.arguments;
    double w = double.parse(args['products_weight'].toString());
    orderInfo.value = orderInfo.value.copyWith(
      productCount: int.parse(args['products_count'].toString()),
      productPrice: double.parse(args['products_price'].toString()),
      deliveryWeight: w,
    );
    weight.value = w;
    _calculateOrderInfo();

    super.onInit();
  }

  onPressedChangeDeliveryTime(
    DeliveryInfo deliveryInfo,
    double price,
  ) {
    _selectedDeliveryInfo = deliveryInfo;
    orderInfo.value = orderInfo.value.copyWith(
      deliveryPrice: price,
      deliveryWeight: weight.value / 1000,
      deliveryDistance: distance.value,
    );
  }

  onPressedSelectLocation() async {
    isLocationSelectionVisible.toggle();

    //calculate the prices
    if (isLocationSelectionVisible.isFalse) {
      LatLng pos1 =
          const LatLng(1.3019081307317848, 124.9068409438052); //pasar Tondano
      double dis = Utils.calculateDistance(pos1, deliveryCoordinate!);
      distance.value = Utils.roundDouble(dis, 2);
      _calculateOrderInfo();
    }
  }

  onPressedMakeOrder() async {
    if (_selectedDeliveryInfo == null) {
      Get.snackbar("Perhatian !", "Waktu pengataran belum dipilih");
      return;
    }

    List<ProductOrder> productOrders = (Get.arguments
        as Map<String, dynamic>)['product_orders'] as List<ProductOrder>;
    Get.toNamed(
      Routes.ordering,
      arguments: <String, dynamic>{
        'delivery_info': _selectedDeliveryInfo,
        'product_orders': productOrders,
        'order_info': orderInfo.value,
      },
    );
  }

  onPressedChangeLocation() async {
    isLocationSelectionVisible.toggle();
  }

  onCameraIdle(LatLng? pos) {
    deliveryCoordinate = pos;
    if (pos == null) {
      isLocationSelectionButtonVisible.value = false;
    } else {
      isLocationSelectionButtonVisible.value = true;
    }
  }

  Future<bool> onPressedBackButton() {
    if (isLocationSelectionVisible.isFalse) {
      isLocationSelectionVisible.toggle();
      return Future.value(false);
    }
    return Future.value(true);
  }

  _calculateOrderInfo() {
    orderInfo.value = orderInfo.value.copyWith(
      deliveryWeight: weight.value,
      deliveryDistance: distance.value,
      deliveryCoordinate: deliveryCoordinate,
    );
  }
}