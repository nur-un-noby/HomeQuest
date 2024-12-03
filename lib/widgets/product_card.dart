import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realstateclient/core/themes/colours.dart';
import 'package:realstateclient/models/product_model.dart';
import 'package:routemaster/routemaster.dart';

class ProductCard extends ConsumerWidget {
  ProductModel product;

  ProductCard({super.key, required this.product});
  void navigateToProductDetails(BuildContext context, String id) {
    Routemaster.of(context).push('/product/$id');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 244, 243, 243),
                offset: Offset(0, 2),
                blurRadius: 1,
                spreadRadius: 1)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => navigateToProductDetails(context, product.id),
              child: SizedBox(
                height: 110,
                width: double.infinity,
                child: Image.network(product.imageUrl),
              ),
            ),
            Text(
              product.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              'Price: ${product.price} TK.',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: Text(
                'Location: ${product.location}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
