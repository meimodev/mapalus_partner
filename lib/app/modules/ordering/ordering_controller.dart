import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/home/home_controller.dart';
import 'package:mapalus_partner/data/models/delivery_info.dart';
import 'package:mapalus_partner/data/models/order.dart';
import 'package:mapalus_partner/data/models/order_info.dart';
import 'package:mapalus_partner/data/models/product_order.dart';
import 'package:mapalus_partner/data/models/user_app.dart';
import 'package:mapalus_partner/data/repo/order_repo.dart';
import 'package:mapalus_partner/data/repo/user_repo.dart';
import 'package:mapalus_partner/shared/routes.dart';

class OrderingController extends GetxController {
  OrderRepo orderRepo = Get.find<OrderRepo>();
  UserRepo userRepo = Get.find<UserRepo>();
  HomeController homeController = Get.find<HomeController>();

  RxBool isLoading = true.obs;

  @override
  void onReady() async {
    super.onReady();

    UserApp? user = await userRepo.readSignedInUser();

    Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
    List<ProductOrder> _productOrders =
        args['product_orders'] as List<ProductOrder>;
    OrderInfo _orderInfo = args['order_info'] as OrderInfo;

    try {
      Order order = await orderRepo.createOrder(
        products: _productOrders,
        user: user!,
        orderInfo: _orderInfo,
      );
      if (kDebugMode) {
        print(order.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print('error occurred while creating order $e');
      }
    }

    isLoading.value = false;
  }

  onPressedBack() {
    if (isLoading.isFalse) {
      _backToHome();
    } else {
      Get.back();
    }
  }

  onPressedReturn() {
    _backToHome();
  }

  _backToHome() {
    Get.until(ModalRoute.withName(Routes.home));
    // Get.offNamedUntil(Routes.home, (_) => Get.currentRoute == Routes.home);
  }
}