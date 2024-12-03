import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realstateclient/controllers/auth_controller.dart';
import 'package:realstateclient/core/widgets/show_snackbar.dart';
import 'package:realstateclient/models/order_model.dart';
import 'package:realstateclient/repository/order_repository.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final orderControllerProvider =
    StateNotifierProvider<OrderController, bool>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return OrderController(orderRepository);
});

final getUserOrdersProvider = StreamProvider.family((ref, String userId) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return orderRepository.getOrdersById(userId);
});

final getOrderDetailsProvider =
    FutureProvider.family<OrderModel, String>((ref, String id) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return orderRepository.getOrderDetails(id);
});

final getOrdersByOwnerIdProvider = StreamProvider.family((ref, String ownerId) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return orderRepository.getOrdersByOwnerId(ownerId);
});



class OrderController extends StateNotifier<bool> {
  final OrderRepository _orderRepository;
  final uuid = const Uuid();
  OrderController(
    OrderRepository orderRepository,
  )   : _orderRepository = orderRepository,
        super(false);

  Future<void> createOrder(
      BuildContext context,
      WidgetRef ref,
      String name,
      String phone,
      String address,
      double price,
      String ownerId,
      String productId) async {
    state = true;
    final uid = ref.read(userProvider)!.uid;
    final id = uuid.v1();
    OrderModel order = OrderModel(
        productId: productId,
        id: id,
        phone: phone,
        address: address,
        userId: uid,
        status: "Pendding",
        total: price,
        ownerId: ownerId,
        createdAt: DateTime.now());
    final res = await _orderRepository.createOrder(order);
    state = false;

    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      showSnackBar(context, 'Order Placed Successfully');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<OrderModel>> getUserOrders(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    return _orderRepository.getOrdersById(user.uid);
  }

  Future<OrderModel> getOrderDetails(String id) async {
    return _orderRepository.getOrderDetails(id);
  }

  Stream<List<OrderModel>> getOrdersByOwnerId(String ownerId) {
    return _orderRepository.getOrdersByOwnerId(ownerId);
  }

  void cancelOrder(BuildContext context, String id) async {
    final res = await _orderRepository.cancelOrder(id);

    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      showSnackBar(context, "Cancel Order successfully ");
      Routemaster.of(context).pop();
    });
  }

  void updateStatus(BuildContext context, String id) async {
    final res = await _orderRepository.updateOrderStatus(id, "Accepted");

    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      showSnackBar(context, "Update Status");
    });
  }
}
