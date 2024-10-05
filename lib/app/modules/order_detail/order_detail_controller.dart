import 'dart:async';

import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_flutter_commons/services/services.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class OrderDetailController extends GetxController {
  final OrderRepo orderRepo = Get.find();
  final NotificationService notificationService = Get.find();

  late OrderApp order;

  RxBool loading = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    loading.value = true;
    final args = Get.arguments;
    if (args == null) {
      throw Exception(
          "order_detail_controller.dart need an OrderApp object as GetX argument");
    }
    order = args as OrderApp;

    listenToOrderDetail(order.id);

    loading.value = false;
  }

  void listenToOrderDetail(String orderId) {
    orderRepo.readOrderDetailStream(orderId).listen(
      (event) {
        if (loading.isFalse) {
          loading.value = true;
        }
        order = event;
        loading.value = false;
      },
    );
  }

  onPressedViewPhone() {
    final phone = order.orderBy.phone.phoneCleanUseCountryCode;
    final phoneUri = Uri.parse("tel:$phone");
    launchUrl(phoneUri);
  }

  onPressedViewMaps() {
    final latitude = order.delivery!.destination.latitude;
    final longitude = order.delivery!.destination.longitude;
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    ///intended use of deprecated method
    ///because known bug in new implementation launchUrl() that cause gmaps to open in webview
    // ignore: deprecated_member_use
    launch(url);
  }

  void onPressedViewWhatsApp() {
    final phone = order.orderBy.phone.phoneCleanUseCountryCode;
    final waUri = Uri.parse('whatsapp://send?phone=$phone');
    launchUrl(waUri);
  }

  void onPressedAccept(OrderApp order) async {
    loading.value = true;
    final updated = order.copyWith(
      status: OrderStatus.accepted,
      lastUpdate: DateTime.now(),
    );
    await orderRepo.updateOrder(UpdateOrderRequest(orderApp: updated));
    await notificationService.postNotification(
      PostNotificationRequest(
        messageTitle: "Pesanan Diterima !",
        messageBody:
            "Pesanan anda telah diterima, setelah selesai akan kami kabari yaaa",
      ),
    );
  }

  void onPressedReject(OrderApp order) async {
    loading.value = true;
    final updated = order.copyWith(
      status: OrderStatus.rejected,
      lastUpdate: DateTime.now(),
    );
    await orderRepo.updateOrder(UpdateOrderRequest(orderApp: updated));
    await notificationService.postNotification(
      PostNotificationRequest(
        messageTitle: "Pesanan Dibatalkan !",
        messageBody:
            "Pesanan anda telah ditolak oleh partner, silahkan coba lagi nanti yaaa",
      ),
    );
  }

  void onPressedDeliver(OrderApp order) async {
    loading.value = true;
    final updated = order.copyWith(
      status: OrderStatus.delivered,
      delivery: order.delivery?.copyWith(lastUpdate: DateTime.now()),
      lastUpdate: DateTime.now(),
    );
    await orderRepo.updateOrder(UpdateOrderRequest(orderApp: updated));
    await notificationService.postNotification(
      PostNotificationRequest(
        messageTitle: "Pesanan Dikirim !",
        messageBody:
            "Yay! pesanan sedang dalam perjalanan menuju tujuan, mohon tunggu sebentar yaaa",
      ).copyWith(),
    );
  }
}
