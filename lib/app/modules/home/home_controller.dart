import 'dart:developer' as dev;

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_partner/shared/routes.dart';

class HomeController extends GetxController {
  UserRepoPartner userRepo = Get.find<UserRepoPartner>();
  OrderRepo orderRepo = Get.find<OrderRepo>();
  ProductRepo productRepo = Get.find<ProductRepo>();
  AppRepo appRepo = Get.find<AppRepo>();
  PartnerRepo partnerRepo = Get.find<PartnerRepo>();

  RxInt currentPageIndex = 0.obs;

  final PageController pageViewController = PageController(initialPage: 0);

  //TODO [OPTIMIZATION] use infinite scrolling implementation

  @override
  void onReady() async {
    final notLatestVersion = !await appRepo.checkIfLatestVersion(false);
    if (notLatestVersion) {
      Get.offNamed(Routes.updateApp);
      return;
    }

    // final isAlreadySignedIn = await userRepo.getSignedIn();
    // if (isAlreadySignedIn == null) {
    //   Get.offNamed(Routes.signing);
    //   return;
    // }

    _initPartnerFCMToken();
    // _initNewOrderListener();
    _initNotificationHandler();
    super.onReady();
  }

  void onPressedAddButton() {
    Get.toNamed(Routes.productDetail, arguments: null);
  }

  _initNotificationHandler() async {
    const androidChannel = AndroidNotificationChannel(
      'order_channel', // id
      'order channel',
      description: 'used to handle order notification exclusively',
      importance: Importance.high,
      enableVibration: true,
      enableLights: true,
      playSound: true,
      showBadge: true,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        dev.log("notification payload ${response.payload}");
      },
    );

    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(androidChannel);

    // final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    // if (initialMessage != null) {
    //   _handleMessage(
    //     message: initialMessage,
    //     flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    //     androidChannel: androidChannel,
    //   );
    // }

    FirebaseMessaging.onMessage.listen((event) {
      _handleMessage(
        message: event,
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        androidChannel: androidChannel,
      );
    });
    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   _handleMessage(
    //     message: event,
    //     flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    //     androidChannel: androidChannel,
    //   );
    // });
  }

  _handleMessage({
    required RemoteMessage message,
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    AndroidNotificationChannel? androidChannel,
  }) {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      AndroidNotification? android = notification.android;
      if (android != null) {
        AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails(
          androidChannel!.id,
          androidChannel.name,
          channelDescription: androidChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          enableVibration: true,
          enableLights: true,
        );

        NotificationDetails notificationDetails =
            NotificationDetails(android: androidNotificationDetails);

        //show

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          notificationDetails,
        );
        return;
      }
    }
  }

  Future<void> _initPartnerFCMToken() async {
    Partner partner = await partnerRepo.readPartner("089525699078");
    await FirebaseMessaging.instance.subscribeToTopic(partner.id);
  }

  // void _initNewOrderListener() {
  //   orderRepo.firestore.getOrdersStream().listen((snapShot) {
  //     isLoading.value = true;
  //     if (orders.isEmpty) {
  //       // Populate order first time screen init
  //       orders.value = snapShot.docs
  //           .where((e) {
  //             final o = OrderApp.fromMap(e.data() as Map<String, dynamic>);
  //             // dev.log(o.toString());
  //             return o.orderTimeStamp.isSame(DateTime.now(), Units.DAY);
  //           })
  //           .map((e) => OrderApp.fromMap(e.data() as Map<String, dynamic>))
  //           .toList()
  //           .reversed
  //           .toList();
  //       isLoading.value = false;
  //
  //       return;
  //     }
  //
  //     var docChanges = snapShot.docChanges;
  //     for (var d in docChanges) {
  //       var map = d.doc.data() as Map<String, dynamic>;
  //       var order = OrderApp.fromMap(map);
  //       final existIndex =
  //           orders.indexWhere((element) => element.id == order.id);
  //
  //       if (existIndex == -1) {
  //         orders.insert(0, order);
  //         Get.rawSnackbar(
  //           message: "New Order received | #${order.idMinified}",
  //         );
  //         // FlutterRingtonePlayer.play(
  //         //   android: AndroidSounds.notification,
  //         //   ios: IosSounds.glass,
  //         //   looping: false,
  //         //   volume: 1,
  //         //   asAlarm: true,
  //         // );
  //       } else {
  //         // orders.replaceRange(existIndex, existIndex, [order]);
  //         orders.removeAt(existIndex);
  //         orders.insert(existIndex, order);
  //         // Get.rawSnackbar(
  //         //   message: "Order #${order.idMinified} updated",
  //         // );
  //       }
  //     }
  //
  //     isLoading.value = false;
  //   });
  // }

  void onPressedNavigationButton(int value) {
    currentPageIndex.value = value;
    pageViewController.jumpToPage(value);
  }

  void onPageViewChanged(int value) {
    if (currentPageIndex.value != value) {
      currentPageIndex.value = value;
    }
  }
}
