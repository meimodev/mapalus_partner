import 'package:mapalus_partner/data/models/order.dart';
import 'package:mapalus_partner/data/models/order_info.dart';
import 'package:mapalus_partner/data/models/product_order.dart';
import 'package:mapalus_partner/data/models/rating.dart';
import 'package:mapalus_partner/data/models/user_app.dart';
import 'package:mapalus_partner/data/services/firebase_services.dart';
import 'package:mapalus_partner/shared/enums.dart';

abstract class OrderRepoContract {
  Future<Order> createOrder({
    required List<ProductOrder> products,
    required UserApp user,
    required OrderInfo orderInfo,
  });

  Future<Order?> readOrder(String id);

  Future<List<Order>> readOrders(UserApp user);

  Future<Order> updateOrderStatus({required Order order});

  Future<Order> rateOrder(Order order, Rating rating);
}

class OrderRepo extends OrderRepoContract {
  FirestoreService firestore = FirestoreService();

  @override
  Future<Order> createOrder({
    required List<ProductOrder> products,
    required UserApp user,
    required OrderInfo orderInfo,
  }) async {
    await Future.delayed(const Duration(seconds: 3));
    Order order = Order(
      orderingUser: user,
      status: OrderStatus.placed,
      products: products,
      orderInfo: orderInfo,
    );
    final newOrder = await firestore.createOrder(order);
    return Future.value(newOrder);
  }

  @override
  Future<Order> rateOrder(Order order, Rating rating) async {
    //new order with updated rating
    order.rating = rating;
    order.status = OrderStatus.finished;
    order.setFinishTimeStamp(rating.ratingTimeStamp);
    return await firestore.updateOrder(order);
  }

  @override
  Future<Order?> readOrder(String id) async {
    var res = await firestore.readOrder(id);
    return res;
  }

  @override
  Future<List<Order>> readOrders(UserApp user) async {
    var res = <Order>[];
    var userOrders = user.orders;
    for (String id in userOrders) {
      Order? o = await firestore.readOrder(id);
      if (o != null) {
        res.add(o);
      }
    }
    return res;
  }

  Future<List<Order>> readAllOrders(int start, int end) async {
    var orders = firestore.readOrders(start, end);

    return orders;
  }

  @override
  Future<Order> updateOrderStatus({required Order order}) async {
    var res = await firestore.updateOrder(order);
    return Future.value(res);
  }

  Stream broadcastOrders() {
    return firestore.getOrdersStream();
  }
}