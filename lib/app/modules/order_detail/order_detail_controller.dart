import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/home/home_controller.dart';
import 'package:mapalus_partner/app/widgets/dialog_confirm.dart';
import 'package:mapalus_partner/shared/routes.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';


class OrderDetailController extends GetxController {
  OrderRepo orderRepo = Get.find();
  HomeController homeController = Get.find();

  RxList<ProductOrder> productOrders = <ProductOrder>[].obs;
  RxList<ProductOrder> productOrdersChecked = <ProductOrder>[].obs;
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

  RxString totalCheckedPrice = ''.obs;

  Rx<OrderStatus> orderStatus = OrderStatus.placed.obs;
  Rx<Rating> orderRating = Rating.zero().obs;

  var paymentMethod = ''.obs;
  var paymentAmount = 0.obs;

  late OrderApp _order;
  bool shouldRefresh = false;

  RxBool canLoading = true.obs;

  UserApp? orderingUser;

  var note = "".obs;

  @override
  Future<void> onInit() async {
    canLoading.value = true;
    await Future.delayed(600.milliseconds);
    OrderApp order = Get.arguments as OrderApp;
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
    totalPrice.value = order.orderInfo.totalPriceF;
    orderRating.value = order.rating;
    orderingUser = order.orderingUser;

    orderStatus.value = order.status;

    paymentMethod.value = order.paymentMethodF;

    paymentAmount.value = order.paymentAmount;
    note.value = order.note;

    dev.log(order.toString());

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

  void onPressedViewPhone() {
    final phone = _order.orderingUser.phone;
    final phoneUri = Uri.parse("tel:$phone");
    launchUrl(phoneUri);
  }

  onPressedViewMaps() {
    final latitude = _order.orderInfo.deliveryCoordinateLatitude;
    final longitude = _order.orderInfo.deliveryCoordinateLongitude;
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    ///intended use of deprecated method
    ///because known bug in new implementation launchUrl() that cause gmaps to open in webview
    // ignore: deprecated_member_use
    launch(url);
  }

  void onPressedViewWhatsApp() {
    final phone = _order.orderingUser.phone;
    final name = _order.orderingUser.name;

    String timeOfTheDay = "Pagi";
    final nowHour = DateTime.now().hour;
    if (nowHour > 11 && nowHour <= 14) {
      timeOfTheDay = "Siang";
    } else if (nowHour > 14 && nowHour <= 17) {
      timeOfTheDay = "Sore";
    } else if (nowHour > 17) {
      timeOfTheDay = "Malam";
    }
    timeOfTheDay = "Selamat $timeOfTheDay";

    final waNumber = phone.replaceFirst("0", "+62");
    final waUri = Uri.parse(
        'whatsapp://send?phone=$waNumber&text='
            '$timeOfTheDay, $name \n'
        'mohon menunggu ya... \n'
        'Delivery Team aplikasi MAPALUS sedang dalam perjalanan :)\n'
            '\n'
            'Apakah pengantaran sesuai titik di aplikasi MAPALUS ?');
    launchUrl(waUri);
  }

  void onChangeCheck(bool checked, ProductOrder productOrder) {
    if (checked) {
      productOrdersChecked.add(productOrder);
    }  else {

    productOrdersChecked.remove(productOrder);
    }
    _calculateCheckedTotalPrice();
  }

  void _calculateCheckedTotalPrice(){
    double total = 0;
    for(final po in productOrdersChecked){
      total += po.totalPrice;
    }
    totalCheckedPrice.value = Utils.formatNumberToCurrency(total.toInt());

  }
}
