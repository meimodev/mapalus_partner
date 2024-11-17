import 'dart:developer' as dev;

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_partner/shared/routes.dart';

class HomeController extends GetxController {
  final appRepo = Get.find<AppRepo>();
  final partnerRepo = Get.find<PartnerRepo>();
  final userRepo = Get.find<UserRepo>();

  RxBool loading = true.obs;

  RxInt currentPageIndex = 0.obs;

  final PageController pageViewController = PageController(initialPage: 0);

  @override
  void onInit() async {
    super.onInit();

    final latestVersion = await appRepo.checkIfLatestVersion(false);
    if (!latestVersion) {
      Get.offNamed(Routes.updateApp);
      return;
    }

    final signedUser = await userRepo.getSignedUser();
    if (signedUser == null) {
      Get.offNamed(Routes.signing);
      return;
    }

    final partner = await partnerRepo.setCurrentPartner(signedUser.partnerId!);

    _initNotificationHandler();
    await partnerRepo.updatePartnerMetaData(partner!);
    loading.value = false;
  }

  void _initNotificationHandler() async {
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

    final initializationSettingsIos = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {
        dev.log('IOS Local Notification $id $title $body $payload');
      },
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIos,
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

  void _handleMessage({
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

  void onPressedNavigationButton(int value) {
    currentPageIndex.value = value;
    pageViewController.animateToPage(
      value,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  void onPageViewChanged(int value) {
    // if (currentPageIndex.value != value) {
    //   currentPageIndex.value = value;
    // }
  }
}
