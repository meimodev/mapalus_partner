import 'dart:async';

import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class OrderDetailController extends GetxController {
  final OrderRepo orderRepo = Get.find();
  final AppRepo appRepo = Get.find();
  final userRepo = Get.find<UserRepo>();

  late OrderApp order;

  RxBool loading = true.obs;

  UserApp? orderBy;

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

    orderBy = await userRepo
        .getUser(GetUserRequest(documentId: order.orderBy.documentId));

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

  void onPressedViewPhone() {
    final phone = order.orderBy.phone.phoneCleanUseCountryCode;
    final phoneUri = Uri.parse("tel:$phone");
    launchUrl(phoneUri);
  }

  void onPressedViewMaps() {
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
    await appRepo.sendNotification(
      PostNotificationRequest(
        title: "Pesanan Diterima !",
        body:
            "Pesanan anda telah diterima, setelah selesai akan kami kabari yaaa",
        destination: orderBy?.fcmToken ?? "",
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
    await appRepo.sendNotification(
      PostNotificationRequest(
        title: "Pesanan Dibatalkan !",
        body:
            "Pesanan anda telah ditolak oleh partner, silahkan coba lagi nanti yaaa",
        destination: orderBy?.fcmToken ?? "",
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
    await appRepo.sendNotification(
      PostNotificationRequest(
        title: "Pesanan Dikirim !",
        body:
            "Yay! pesanan sedang dalam perjalanan menuju tujuan, mohon tunggu sebentar yaaa",
        destination: orderBy?.fcmToken ?? "",
      ),
    );
  }

  void onPressedSeeTransferStatus(OrderApp order) {

    // WA admin that this store want to confirm a transfer payment
    // provide admin with order id, customer name, customer phone, order amount, request timestamp
    final adminPhone = AppRepo.adminPhone.phoneCleanUseCountryCode;
    final message = "*TRANSFER CHECK*\n\n"
        "${order.id}\n\n"
        "${order.orderBy.name} - ${order.orderBy.phone.phoneCleanUseZero}\n"
        "${order.payment.amount.formatNumberToCurrency()}\n\n"
        "_${DateTime.now().ddMmmmYyyy} ${DateTime.now().HHmm}_\n";
    final waUri = Uri.parse('whatsapp://send?phone=$adminPhone&text=$message');
    launchUrl(waUri);
  }
}
