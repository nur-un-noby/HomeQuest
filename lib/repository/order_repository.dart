import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:realstateclient/core/type_def.dart';
import 'package:realstateclient/core/widgets/failure.dart';
import 'package:realstateclient/models/order_model.dart';
import 'package:realstateclient/repository/constants_provider.dart';

final orderRepositoryProvider =
    Provider((ref) => OrderRepository(firestore: ref.read(firestoreProvider)));

class OrderRepository {
  final FirebaseFirestore _firestore;
  OrderRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _orders => _firestore.collection('orders');

  FutureVoid createOrder(OrderModel order) async {
    try {
      final res = await _orders.doc(order.id).set(order.toMap());
      // ignore: void_checks
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<OrderModel>> getOrdersById(String userId) {
    return _orders
        .where(
          'userId',
          isEqualTo: userId,
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<OrderModel> getOrderDetails(String id) async {
    try {
      final response = await _orders.doc(id).get();
      final order = OrderModel.fromMap(response.data() as Map<String, dynamic>);
      return order;
    } catch (e) {
      log(e.toString());
      throw Failure(e.toString());
    }
  }

  Stream<List<OrderModel>> getOrdersByOwnerId(String ownerId) {
    return _orders
        .where(
          'ownerId',
          isEqualTo: ownerId,
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  FutureVoid cancelOrder(String id) async {
    try {
      final res = await _orders.doc(id).delete();
      // ignore: void_checks
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid updateOrderStatus(String id, String status) async {
    try {
      final res = await _orders.doc(id).update({'status': status});
      // ignore: void_checks
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
