import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:realstateclient/controllers/auth_controller.dart';
import 'package:realstateclient/controllers/order_controller.dart';
import 'package:realstateclient/controllers/product_controller.dart';
import 'package:realstateclient/core/widgets/error_text.dart';
import 'package:realstateclient/core/widgets/loader.dart';

class OrderDetails extends ConsumerWidget {
  final String orderId;
  const OrderDetails({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return ref.watch(getOrderDetailsProvider(orderId)).when(
        data: (order) {
          return ref.watch(getProductByIdProvider(order.productId)).when(
              data: (product) {
                return Scaffold(
                    appBar: AppBar(
                      title: Text("${product.title} order Details"),
                    ),
                    body: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 250,
                                width: double.infinity,
                                child: Image.network(product.imageUrl)),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.date_range),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "Order Date: ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(order.createdAt),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.safety_check),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "Status: ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  order.status,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.title),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "Name: ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Row(
                              children: [
                                const Icon(Icons.money),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "Price: ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  product.price.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.location_on),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "Location: ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.description),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Owner: ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  product.description,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    bottomNavigationBar: user.uid == product.userId
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  onPressed: () {
                                    ref
                                        .watch(orderControllerProvider.notifier)
                                        .cancelOrder(context, order.id);
                                  },
                                  child: Text(
                                    order.status == 'Pending'
                                        ? 'Cancel Order'
                                        : 'Order Cancelled',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  onPressed: () {
                                    ref
                                        .watch(orderControllerProvider.notifier)
                                        .updateStatus(context, order.id);
                                  },
                                  child: Text(
                                    order.status == 'Pending'
                                        ? 'Accept Order'
                                        : 'Order Accepted',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox());
              },
              error: (e, s) => ErrorText(text: e.toString()),
              loading: () => const Loader());
        },
        error: (e, s) => ErrorText(text: e.toString()),
        loading: () => const Loader());
  }
}
