import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realstateclient/controllers/auth_controller.dart';
import 'package:realstateclient/controllers/product_controller.dart';
import 'package:realstateclient/controllers/product_provider.dart';
import 'package:realstateclient/core/widgets/error_text.dart';
import 'package:realstateclient/core/widgets/loader.dart';
import 'package:realstateclient/models/product_model.dart';
import 'package:routemaster/routemaster.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return ref.watch(getProductByIdProvider(productId)).when(
        data: (product) {
          return Scaffold(
            appBar: AppBar(
              title: Text("${product.title} Details"),
              actions: [
                user.uid == product.userId
                    ? IconButton(
                        onPressed: () {
                          ref
                              .read(productControllerProvider.notifier)
                              .deleteProduct(product.id);
                          Routemaster.of(context).pop();
                        },
                        icon: const Icon(Icons.delete),
                      )
                    : const SizedBox()
              ],
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
                        const Icon(Icons.title),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          "Name: ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          product.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
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
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          product.price.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
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
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          product.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
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
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Text(
                          product.description,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: user.uid == product.userId
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          ref
                              .read(productProvider.notifier)
                              .update((state) => product as ProductModel?);

                          Routemaster.of(context)
                              .push('/create-order/${product.id}');
                        },
                        child: const Text(
                          "Add Rent",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
          );
        },
        error: (e, s) => ErrorText(text: e.toString()),
        loading: () => const Loader());
  }
}
