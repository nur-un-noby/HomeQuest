import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:realstateclient/core/constants/collection_constants.dart';
import 'package:realstateclient/core/type_def.dart';
import 'package:realstateclient/core/widgets/failure.dart';
import 'package:realstateclient/models/product_model.dart';
import 'package:realstateclient/repository/constants_provider.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(firestore: ref.read(firestoreProvider));
});

class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _products =>
      _firestore.collection(FirebaseConstants.propertiesCollection);

  Stream<List<ProductModel>> getAllProducts() {
    try {
      final products = _products.snapshots().map((event) => event.docs
          .map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>))
          .toList());
      return products;
    } catch (e) {
      log(e.toString());
      return Stream.value([]);
    }
  }

  Stream<List<ProductModel>> searchCommunites(String query) {
    return _products
        .where('location',
            isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
            isLessThan: query.isEmpty
                ? null
                : query.substring(0, query.length - 1) +
                    String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .snapshots()
        .map((events) {
      List<ProductModel> productlist = [];

      for (var doc in events.docs) {
        productlist
            .add(ProductModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return productlist;
    });
  }

  Stream<ProductModel> getProductById(String id) {
    return _products.doc(id).snapshots().map(
        (event) => ProductModel.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid addProduct(ProductModel product) async {
    try {
      await _products.doc(product.id).set(product.toMap());
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<ProductModel>> getProductsByUserId(String userId) {
    return _products.where('userId', isEqualTo: userId).snapshots().map(
        (event) => event.docs
            .map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  FutureVoid deleteProduct(String id) async {
    try {
      await _products.doc(id).delete();
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
