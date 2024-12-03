import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realstateclient/controllers/product_controller.dart';
import 'package:realstateclient/core/widgets/error_text.dart';
import 'package:realstateclient/core/widgets/loader.dart';
import 'package:routemaster/routemaster.dart';

class SearchProductDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchProductDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchProductsProvider(query)).when(
        data: (products) => ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  onTap: () => navigateToProductDetails(context, product.id),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(product.imageUrl),
                  ),
                  title: Text(
                    product.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
        error: (e, s) => ErrorText(text: e.toString()),
        loading: () => const Loader());
  }

  void navigateToProductDetails(BuildContext context, String id) {
    Routemaster.of(context).push('/product/$id');
  }
}
