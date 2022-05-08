import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mapalus_partner/data/models/order.dart';
import 'package:mapalus_partner/data/models/partner.dart';
import 'package:mapalus_partner/data/models/product.dart';
import 'package:mapalus_partner/data/models/user_app.dart';

class FirestoreService {
  FirebaseFirestore fireStore;

  FirestoreService() : fireStore = FirebaseFirestore.instance;

  Future<List<Product>> getProducts(int start, int end) async {
    CollectionReference products = fireStore.collection('products');

    QuerySnapshot data = await products.get();

    List<Product> res = [];

    for (var element in data.docs) {
      var elementAsMap = element.data() as Map<String, dynamic>;
      res.add(Product.fromMap(elementAsMap));
    }
    return res;
  }

  Future<UserApp?> getUser(String phone) async {
    CollectionReference col = fireStore.collection('users');
    DocumentSnapshot doc = await col.doc(phone).get();

    if (doc.exists) {
      Map data = doc.data() as Map<String, dynamic>;
      print("firebase service getuser $data");
      UserApp userApp = UserApp(
        phone: phone,
        name: data["name"],
        orders: List<String>.from(data["orders"]),
      );
      return userApp;
    } else {
      return null;
    }
  }

  Future<bool> checkPhoneRegistration(String phone) async {
    CollectionReference col = fireStore.collection('users');
    DocumentSnapshot doc = await col.doc(phone).get();

    return doc.exists;
  }

  Future<UserApp> createUser(UserApp user) async {
    CollectionReference users = fireStore.collection('users');

    users.doc(user.phone).set(user.toMap()).then((value) {
      if (kDebugMode) {
        print('[FIRESTORE] USER successfully registered');
      }
    }).onError((e, _) {
      if (kDebugMode) {
        print('[FIRESTORE] USER creation error $e');
      }
    });

    return user;
  }

  Future<List<Map<String, dynamic>>> getDeliveryTimes() async {
    CollectionReference col = fireStore.collection('delivery_time');
    DocumentSnapshot doc = await col.doc('-env').get();

    Map data = doc.data() as Map<String, dynamic>;

    return Future.value(List<Map<String, dynamic>>.from(data["deliveries"]));
  }

  Future<Order> createOrder(Order order) async {
    CollectionReference orders = fireStore.collection('orders');

    orders.doc(order.generateId()).set(order.toMap()).then((_) {
      if (kDebugMode) {
        print('[FIRESTORE] ORDER successfully created');
      }
    }).onError((e, _) {
      if (kDebugMode) {
        print('[FIRESTORE] ORDER creation error $e');
      }
    });

    order.orderingUser.orders.add(order.generateId());
    CollectionReference users = fireStore.collection('users');

    users
        .doc(order.orderingUser.phone)
        .update({"orders": order.orderingUser.orders}).then((_) {
      if (kDebugMode) {
        print('[FIRESTORE] USER-ORDER successfully created');
      }
    }).onError((e, _) {
      if (kDebugMode) {
        print('[FIRESTORE] USER-ORDER creation error $e');
      }
    });

    return order;
  }

  Future<Order?> readOrder(String id) async {
    CollectionReference orders = fireStore.collection('orders');
    DocumentSnapshot doc = await orders.doc(id).get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return Order.fromMap(data);
    }
    return null;
  }

  Future<List<Order>> readOrders(int start, int end) async {
    CollectionReference orders = fireStore.collection('orders');

    QuerySnapshot data = await orders.get();

    List<Order> res = [];

    for (var element in data.docs) {
      var elementAsMap = element.data() as Map<String, dynamic>;
      res.add(Order.fromMap(elementAsMap));
    }
    return res;
  }

  Future<Order> updateOrder(Order order) async {
    CollectionReference orders = fireStore.collection('orders');

    orders.doc(order.generateId()).set(order.toMap()).then((_) {
      if (kDebugMode) {
        print('[FIRESTORE] ORDER successfully updated');
      }
    }).onError((e, _) {
      if (kDebugMode) {
        print('[FIRESTORE] ORDER update error $e');
      }
    });

    return order;
  }

  Stream<QuerySnapshot<Object?>> getOrdersStream() {
    CollectionReference orders = fireStore.collection('orders');
    return orders.snapshots();
  }

  Future<Partner> updatePartner(Partner partner) {
    CollectionReference partners = fireStore.collection('partners');

    partners.doc(partner.id).set(partner.toMap()).then((_) {
      if (kDebugMode) {
        print('[FIRESTORE] PARTNER successfully updated');
      }
    }).onError((e, _) {
      if (kDebugMode) {
        print('[FIRESTORE] PARTNER update error $e');
      }
    });

    return Future.value(partner);
  }

  Future<Partner> getPartner(String id) async {
    CollectionReference partners = fireStore.collection('partners');

    DocumentSnapshot doc = await partners.doc(id).get();

    final data = doc.data() as Map<String, dynamic>;
    print(data.toString());
    return Partner.fromMap(data);
  }

  Future<Product> updateProduct(Product product) {
    CollectionReference products = fireStore.collection('products');

    products.doc(product.id.toString()).set(product.toMap()).then((_) {
      if (kDebugMode) {
        print('[FIRESTORE] PRODUCT successfully updated');
      }
    }).onError((e, _) {
      if (kDebugMode) {
        print('[FIRESTORE] PRODUCT update error $e');
      }
    });

    return Future.value(product);
  }

  Future<Product> createProduct(Product product) async {
    CollectionReference products = fireStore.collection('products');

    DocumentReference docRef = await products.add(product.toMap());

    product.id = docRef.id;
    products.doc(product.id).set(product.toMap()).then((_) {
      if (kDebugMode) {
        print('[FIRESTORE] PRODUCT successfully created');
      }
    }).onError((e, _) {
      if (kDebugMode) {
        print('[FIRESTORE] PRODUCT creation error $e');
      }
    });

    return product;
  }

  deleteProduct(String productId) {
    CollectionReference products = fireStore.collection('products');

    products.doc(productId).delete().then((_) {
      if (kDebugMode) {
        print('[FIRESTORE] PRODUCT successfully deleted');
      }
    }).onError((e, _) {
      if (kDebugMode) {
        print('[FIRESTORE] PRODUCT deletion error $e');
      }
    });
  }

  Future<Object?> getAppVersion() async {
    CollectionReference app = fireStore.collection('app');
    DocumentSnapshot doc = await app.doc('mapalus_partner').get();
    return doc.data();
  }
}