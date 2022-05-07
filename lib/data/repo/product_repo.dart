import 'package:mapalus_partner/data/models/product.dart';
import 'package:mapalus_partner/data/services/firebase_services.dart';

abstract class ProductRepoContract {
  Future<Product> readProduct(int id);

  Future<List<Product>> readProducts(int start, int end);

  Future<Product> searchProduct();
}

class ProductRepo extends ProductRepoContract {
  FirestoreService firestore = FirestoreService();

  @override
  Future<Product> readProduct(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> readProducts(int start, int end) async {
    return await firestore.getProducts(start, end);
  }

  @override
  Future<Product> searchProduct() {
    throw UnimplementedError();
  }

  Future<Product> updateProduct(Product product) async {
    return await firestore.updateProduct(product);
  }

  Future<Product> createProduct(Product product) async {
    return await firestore.createProduct(product);
  }

  Future<void> deleteProduct(String productId) async {
    await firestore.deleteProduct(productId);
  }
}