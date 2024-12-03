import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:realstateclient/controllers/auth_controller.dart';
import 'package:realstateclient/controllers/order_controller.dart';
import 'package:realstateclient/controllers/product_controller.dart';
import 'package:realstateclient/core/widgets/error_text.dart';
import 'package:realstateclient/core/widgets/loader.dart';
import 'package:routemaster/routemaster.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;

    return ref.watch(getUserOrdersProvider(user.uid)).when(
        data: (orders) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(tabs: [
                  Tab(
                    text: 'Notifications',
                  ),
                  Tab(
                    text: 'Orders',
                  ),
                ]),
              ),
              body: TabBarView(
                children: [
                  ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          style: ListTileStyle.list,
                          shape: RoundedRectangleBorder(
                              
                              borderRadius: BorderRadius.circular(10)),
                          
                          title: ref
                              .watch(getProductByIdProvider(
                                  orders[index].productId))
                              .when(
                                  data: (product) {
                                    return Text(product.title,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold));
                                  },
                                  error: (error, stackRace) =>
                                      ErrorText(text: error.toString()),
                                  loading: () => const Loader()),
                          subtitle: Text(
                              "Total: ${orders[index].total} Date: ${DateFormat.yMMMd().format(orders[index].createdAt)}"),
                          trailing: Text(
                            orders[index].status,
                            style: const TextStyle(fontSize: 17),
                          ),
                          onTap: () {
                            Routemaster.of(context)
                                .push('/order/${orders[index].id}');
                          },
                        );
                      }),
                  ref.watch(getOrdersByOwnerIdProvider(user.uid)).when(
                      data: (data) {
                        return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: ref
                                    .watch(getProductByIdProvider(
                                        data[index].productId))
                                    .when(
                                        data: (product) {
                                          return Text(product.title,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold));
                                        },
                                        error: (error, stackRace) =>
                                            ErrorText(text: error.toString()),
                                        loading: () => const Loader()),
                                subtitle: Text(
                                    "Total: ${data[index].total} Date: ${DateFormat.yMMMd().format(data[index].createdAt)}"),
                                trailing: Text(
                                  data[index].status,
                                  style: const TextStyle(fontSize: 17),
                                ),
                                onTap: () {
                                  Routemaster.of(context)
                                      .push('/order/${data[index].id}');
                                },
                              );
                            });
                      },
                      error: (error, stackRace) =>
                          ErrorText(text: error.toString()),
                      loading: () => const Loader())
                ],
              ),
            ),
          );
        },
        error: (error, stackRace) => ErrorText(text: error.toString()),
        loading: () => const Loader());
  }
}
