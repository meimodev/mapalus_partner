import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mapalus_partner/shared/routes.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class HomeController extends GetxController {
  UserRepoPartner userRepo = Get.find<UserRepoPartner>();
  OrderRepo orderRepo = Get.find<OrderRepo>();
  ProductRepo productRepo = Get.find<ProductRepo>();
  AppRepo appRepo = Get.find<AppRepo>();
  PartnerRepo partnerRepo = Get.find<PartnerRepo>();

  ///incredibly dangerous and unmaintainable !! Do not access straight service without repository layer
  FirestoreService firestoreService = FirestoreService();

  RxList<OrderApp> orders = <OrderApp>[].obs;
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
  void onReady() async {
    final notLatestVersion = !await appRepo.checkIfLatestVersion(false);
    if (notLatestVersion) {
      Get.offNamed(Routes.updateApp);
      return;
    }

    final isAlreadySignedIn = await userRepo.getSignedIn();
    if (isAlreadySignedIn == null) {
      Get.offNamed(Routes.signing);
      return;
    }
    _initPartnerFCMToken();
    _initNewOrderListener();
    super.onReady();
  }

  void onPressedProducts() {
    activeNavBottomIndex.value = 2;
    _loadProducts();
  }

  void onPressedOrders() {
    activeNavBottomIndex.value = 1;
    _loadTodayOrders();
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

  _loadTodayOrders() async {
    isLoading.value = true;
    var oo = await orderRepo.readOrdersToday();
    tecProductFilter.text = '';
    orders.value = List<OrderApp>.from(oo.reversed);
    // dev.log(orders.first.toString());

    //show the list on screen
    isLoading.value = false;
  }

  _loadProducts() async {
    isLoading.value = true;
    // await Future.delayed(1.seconds);

    var pp = await productRepo.readProducts();
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

  // void refreshOrders() {
  //   _loadOrders();
  // }

  Future<void> _initPartnerFCMToken() async {
    Partner partner = await partnerRepo.readPartner("089525699078");
    await FirebaseMessaging.instance.subscribeToTopic(partner.id);
  }

  void _initNewOrderListener() {
    orderRepo.firestore.getOrdersStream().listen((snapShot) {
      isLoading.value = true;
      if (orders.isEmpty) {
        // Populate order first time screen init
        orders.value = snapShot.docs
            .where((e) {
              final o = OrderApp.fromMap(e.data() as Map<String, dynamic>);
              // dev.log(o.toString());
              return o.orderTimeStamp.isSame(DateTime.now(), Units.DAY);
            })
            .map((e) => OrderApp.fromMap(e.data() as Map<String, dynamic>))
            .toList()
            .reversed
            .toList();
        isLoading.value = false;

        return;
      }

      var docChanges = snapShot.docChanges;
      for (var d in docChanges) {
        var map = d.doc.data() as Map<String, dynamic>;
        var order = OrderApp.fromMap(map);
        final existIndex =
            orders.indexWhere((element) => element.id == order.id);

        if (existIndex == -1) {
          orders.insert(0, order);
          Get.rawSnackbar(
            message: "New Order received | #${order.idMinified}",
          );
          FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: IosSounds.glass,
            looping: false,
            volume: 1,
            asAlarm: true,
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

  onPressedSettings() {
    Get.toNamed(Routes.settings);
  }

  void onPressedHistory() async {
    activeNavBottomIndex.value = 3;

    isLoading.value = true;
    var oo = await orderRepo.readOrders();
    tecProductFilter.text = '';
    orders.value = List<OrderApp>.from(oo.reversed);

    isLoading.value = false;
  }
}
