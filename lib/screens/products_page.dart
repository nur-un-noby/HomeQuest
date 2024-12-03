import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realstateclient/controllers/product_controller.dart';
import 'package:realstateclient/core/widgets/error_text.dart';
import 'package:realstateclient/core/widgets/loader.dart';
import 'package:realstateclient/widgets/product_card.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  String? selectedCatagory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          ref.watch(getAllProductsProvider).when(
              data: (data) {
                return Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 10),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: data[index]);
                      }),
                );
              },
              error: (e, s) => ErrorText(text: e.toString()),
              loading: () => const Loader())
        ],
      ),
    );
  }
}
