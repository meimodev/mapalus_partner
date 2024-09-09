import 'dart:async';

import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_partner/app/modules/home/home_controller.dart';
import 'package:mapalus_partner/app/widgets/dialog_confirm.dart';

class OrderDetailController extends GetxController {
  OrderRepo orderRepo = Get.find();
  HomeController homeController = Get.find();

  RxList<ProductOrder> productOrdersChecked = <ProductOrder>[].obs;

  RxString totalCheckedPrice = ''.obs;

  late Rx<OrderApp> order;

  RxBool isLoading = true.obs;

  late StreamSubscription orderListener;

  late UserApp freshOrderingUser;

  @override
  Future<void> onInit() async {
    super.onInit();

    isLoading.value = true;
    OrderApp o = Get.arguments as OrderApp;
    order = o.obs;

    // orderListener =
    //     orderRepo.firestore.getOrderStream(o.id!).listen((snapshot) {
    //   isLoading.value = true;
    //
    //   final t = OrderApp.fromMap(snapshot.data() as Map<String, dynamic>);
    //   order = t.obs;
    //
    //   if (isLoading.isTrue) {
    //     isLoading.value = false;
    //   }
    // });

    // final userMap = await orderRepo.firestore.getUser(order.value.orderingUser.phone);
    // freshOrderingUser = UserApp.fromMap(userMap as Map<String, dynamic>);

    isLoading.value = false;
  }

  @override
  void dispose() {
    orderListener.cancel();
    super.dispose();
  }

  onPressedNegative() async {
    Get.dialog(DialogConfirm(
      description:
          "Anda akan melakukan pembatalan pesanan, konfirmasi untuk batal",
      title: "PERHATIAN !",
      confirmText: "BATALKAN",
      onPressedConfirm: () async {
        isLoading.value = true;
        // order.value.status = OrderStatus.rejected;
        // await orderRepo.updateOrderStatus(order: order.value);
        // await Future.delayed(600.milliseconds);

        // if (freshOrderingUser.fcmToken != null) {
        //   NotificationService.instance.sendNotification(
        //     title:
        //         "Pesanan #${order.value.idMinified} telah dibatalkan partner MAPALUS",
        //     message: "Maaf 🙏 atas pembatalan pesanan tersebut, "
        //         "MAPALUS akan berusaha memberikan pelayanan terbaik pada pesanan anda selanjutnya ☺",
        //     destination: freshOrderingUser.fcmToken,
        //   );
        // }

        isLoading.value = false;
      },
    ));
  }

  onPressedPositive() async {
    isLoading.value = true;
    // order.value.status = OrderStatus.accepted;
    // await orderRepo.updateOrderStatus(order: order.value);
    //
    // if (freshOrderingUser.fcmToken != null) {
    //   NotificationService.instance.sendNotification(
    //     title: "OK, pesanan telah diterima & sedang diproses ☺",
    //     message:
    //         "Pesanan #${order.value.idMinified} sudah di konfirmasi oleh partner MAPALUS, "
    //         "silahkan menunggu untuk pengantaran di waktu yang telah dipilih ya 🙏",
    //     destination: freshOrderingUser.fcmToken,
    //   );
    // }
    //
    // await Future.delayed(600.milliseconds);
    // isLoading.value = false;
  }

  onPressedDeliver() async {
    // isLoading.value = true;
    // order.value.status = OrderStatus.delivered;
    // await orderRepo.updateOrderStatus(order: order.value);
    // await Future.delayed(600.milliseconds);
    //
    // if (freshOrderingUser.fcmToken != null) {
    //   NotificationService.instance.sendNotification(
    //     title: "YAY! pesanan akan segera tiba ☺",
    //     message:
    //         "Pesanan #${order.value.idMinified} sedang diantar, mohon menunggu ya 🙏",
    //     destination: freshOrderingUser.fcmToken,
    //   );
    // }

    isLoading.value = false;
  }

  onPressedViewPhone() {
    // final phone = order.value.orderingUser.phone;
    // final phoneUri = Uri.parse("tel:$phone");
    // launchUrl(phoneUri);
  }

  onPressedViewMaps() {
    // final latitude = order.value.orderInfo.deliveryCoordinateLatitude;
    // final longitude = order.value.orderInfo.deliveryCoordinateLongitude;
    // final url =
    //     'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    ///intended use of deprecated method
    ///because known bug in new implementation launchUrl() that cause gmaps to open in webview
    // ignore: deprecated_member_use
    // launch(url);
  }

  void onPressedViewWhatsApp() {
    // final phone = order.value.orderingUser.phone;
    // final waNumber = phone.replaceFirst("0", "+62");
    // final waUri = Uri.parse('whatsapp://send?phone=$waNumber');
    // launchUrl(waUri);
  }

  void onChangeCheck(bool checked, ProductOrder productOrder) {
    if (checked) {
      productOrdersChecked.add(productOrder);
    } else {
      productOrdersChecked.remove(productOrder);
    }
    _calculateCheckedTotalPrice();
  }

  void _calculateCheckedTotalPrice() {
    // double total = 0;
    // for (final po in productOrdersChecked) {
    //   total += po.totalPrice;
    // }
    // totalCheckedPrice.value = Utils.formatNumberToCurrency(total.toInt());
  }
}
