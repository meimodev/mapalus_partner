import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mapalus_partner/data/models/order.dart';
import 'package:mapalus_partner/data/models/partner.dart';
import 'package:mapalus_partner/data/models/product.dart';
import 'package:mapalus_partner/data/repo/order_repo.dart';
import 'package:mapalus_partner/data/repo/product_repo.dart';
import 'package:mapalus_partner/data/repo/user_repo.dart';
import 'package:mapalus_partner/shared/routes.dart';

class HomeController extends GetxController {
  UserRepo userRepo = Get.find<UserRepo>();
  OrderRepo orderRepo = Get.find<OrderRepo>();
  ProductRepo productRepo = Get.find<ProductRepo>();

  RxList<Order> orders = <Order>[].obs;
  RxList<Product> products = <Product>[].obs;

  var isLoading = false.obs;
  var activeNavBottomIndex = 1.obs;

  //TODO [OPTIMIZATION] use infinite scrolling implementation

  @override
  void onInit() {
    _initOrderNotifications();
    _initPartnerFCMToken();
    _initNewOrderListener();
    super.onInit();
  }

  void onPressedProducts() {
    activeNavBottomIndex.value = 2;
    _loadProducts();
  }

  void onPressedOrders() {
    activeNavBottomIndex.value = 1;
    _loadOrders();
  }

  _loadOrders() async {
    isLoading.value = true;
    var _orders = await orderRepo.readAllOrders(0, 0);
    orders.value = List<Order>.from(_orders.reversed);

    //show the list on screen
    isLoading.value = false;
  }

  _loadProducts() async {
    isLoading.value = true;
    // await Future.delayed(1.seconds);

    var _products = await productRepo.readProducts(0, 0);
    var p = List<Product>.from(_products);
    p.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    products.value = List<Product>.from(p);

    //show the list on screen
    isLoading.value = false;
  }

  void onPressedAddButton() {
    Get.toNamed(Routes.productDetail, arguments: null);
  }

  void refreshOrders() {
    _loadOrders();
  }

  Future<void> _initOrderNotifications() async {
    const AndroidNotificationChannel androidChannel =
        AndroidNotificationChannel(
      'order_channel', // id
      'order channel',
      description: 'used to handle order notification exclusively',
      importance: Importance.max,
      enableVibration: true,
      enableLights: true,
      playSound: true,
      showBadge: true,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    FirebaseMessaging.onMessage.listen((event) => _handleMessage(
          message: event,
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        ));

    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) => _handleMessage(
          message: event,
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin),
    );
    RemoteMessage? initMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initMessage != null) {
      _handleMessage(
        message: initMessage,
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
      );
    }
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
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidChannel!.id,
              androidChannel.name,
              channelDescription: androidChannel.description,
              playSound: androidChannel.playSound,
              enableLights: androidChannel.enableLights,
              enableVibration: androidChannel.enableVibration,
            ),
          ),
        );
        return;
      }

      Get.rawSnackbar(
        message: notification.title,
      );
    }
  }

  Future<void> _initPartnerFCMToken() async {
    Partner partner = await userRepo.firestore.getPartner("089525699078");
    FirebaseMessaging.instance.onTokenRefresh.listen((event) async {
      partner.fcmToken = event;
      userRepo.firestore.updatePartner(partner);
    });
    var _token = await FirebaseMessaging.instance.getToken();
    if (_token != null && partner.fcmToken != _token) {
      partner.fcmToken = _token;
      userRepo.firestore.updatePartner(partner);
    }
  }

  void _initNewOrderListener() {
    orderRepo.firestore.getOrdersStream().listen((snapShot) {
      isLoading.value = true;
      orders.value = snapShot.docs
          .map((e) => Order.fromMap(e.data() as Map<String, dynamic>))
          .toList()
          .reversed
          .toList();
      //TODO [OPTIMIZATION] read & build only the altered order in this list

      //TODO [OPTIMIZATION] specify the notification message of the updated content
      Get.rawSnackbar(message: "Order list updated");
      isLoading.value = false;
    });
  }

  void updateProductList(Product product, {bool isDeletion = false}) {
    if (isDeletion) {
      products.removeWhere((element) => element.id == product.id);
      return;
    }

    if (products.isEmpty) {
      products.add(product);
      return;
    }
    int index = products.indexWhere((element) => element.id == product.id);
    if (index <= -1) {
      products.add(product);
      return;
    }

    products.removeAt(index);
    products.insert(index, product);
  }
}