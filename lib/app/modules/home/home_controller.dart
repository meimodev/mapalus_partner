import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mapalus_partner/data/models/order.dart';
import 'package:mapalus_partner/data/models/partner.dart';
import 'package:mapalus_partner/data/models/product.dart';
import 'package:mapalus_partner/data/repo/order_repo.dart';
import 'package:mapalus_partner/data/repo/product_repo.dart';
import 'package:mapalus_partner/data/repo/user_repo.dart';
import 'package:mapalus_partner/shared/routes.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class HomeController extends GetxController {
  UserRepo userRepo = Get.find<UserRepo>();
  OrderRepo orderRepo = Get.find<OrderRepo>();
  ProductRepo productRepo = Get.find<ProductRepo>();

  RxList<Order> orders = <Order>[].obs;
  RxList<Product> products = <Product>[].obs;
  List<Product> _tempProducts = <Product>[];

  TextEditingController tecProductFilter = TextEditingController();

  var isLoading = false.obs;
  var activeNavBottomIndex = 1.obs;

  bool firstInit = true;

  //TODO [OPTIMIZATION] use infinite scrolling implementation

  @override
  void dispose() {
    tecProductFilter.dispose();
    super.dispose();
  }

  @override
  void onInit() {
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

  Future<void> onChangedProductFilter(String value) async {
    if (value.isEmpty) {
      products.value = List.of(_tempProducts);
      return;
    }

    List<Product> pp = List.of(_tempProducts);
    pp.retainWhere((element) {
      var pName = element.name.trim().toLowerCase();
      var pCategory = element.category.trim().toLowerCase();
      var val = value.trim().toLowerCase();
      return pName.contains(val) || pCategory.contains(val);
    });
    products.value = pp;
  }

  _loadOrders() async {
    isLoading.value = true;
    var oo = await orderRepo.readAllOrders(0, 0);
    tecProductFilter.text = '';
    orders.value = List<Order>.from(oo);

    //show the list on screen
    isLoading.value = false;
  }

  _loadProducts() async {
    isLoading.value = true;
    // await Future.delayed(1.seconds);

    var pp = await productRepo.readProducts(0, 0);
    var p = List<Product>.from(pp);
    // p.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    products.value = List<Product>.from(p);
    _tempProducts = List<Product>.of(products);
    //show the list on screen
    isLoading.value = false;
  }

  void onPressedAddButton() {
    Get.toNamed(Routes.productDetail, arguments: null);
  }

  void refreshOrders() {
    _loadOrders();
  }

  Future<void> _initPartnerFCMToken() async {
    Partner partner = await userRepo.firestore.getPartner("089525699078");
    await FirebaseMessaging.instance.subscribeToTopic(partner.id);
    debugPrint('Subscribed To ${partner.id}');
    // FirebaseMessaging.instance.onTokenRefresh.listen((event) async {
    //   partner.addNewToken(event);
    //   userRepo.firestore.updatePartner(partner);
    // });
    // var token = await FirebaseMessaging.instance.getToken();
    // if (token != null && !partner.fcmToken.contains(token)) {
    //   partner.addNewToken(token);
    //   userRepo.firestore.updatePartner(partner);
    // }
  }

  void _initNewOrderListener() {
    orderRepo.firestore.getOrdersStream().listen((snapShot) {
      isLoading.value = true;
      if (orders.isEmpty) {
        orders.value = snapShot.docs
            .map((e) => Order.fromMap(e.data() as Map<String, dynamic>))
            .toList()
            .reversed
            .toList();
        isLoading.value = false;
        return;
      }

      var docChanges = snapShot.docChanges;
      for (var d in docChanges) {
        var map = d.doc.data() as Map<String, dynamic>;
        var order = Order.fromMap(map);
        final existIndex =
            orders.indexWhere((element) => element.id == order.id);

        if (existIndex == -1) {
          orders.insert(0, order);
          Get.rawSnackbar(
            message: "New Order received | #${order.idMinified}",
          );
        } else {
          // orders.replaceRange(existIndex, existIndex, [order]);
          orders.removeAt(existIndex);
          orders.insert(existIndex, order);
          // Get.rawSnackbar(
          //   message: "Order #${order.idMinified} updated",
          // );
        }
      }

      FlutterRingtonePlayer.play(
        android: AndroidSounds.notification,
        ios: IosSounds.glass,
        looping: false,
        volume: 1,
        asAlarm: true,
      );

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