import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realstateclient/controllers/auth_controller.dart';
import 'package:realstateclient/controllers/product_controller.dart';
import 'package:realstateclient/core/widgets/error_text.dart';
import 'package:realstateclient/core/widgets/loader.dart';
import 'package:realstateclient/widgets/product_card.dart';
import 'package:routemaster/routemaster.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Your Properties",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                    onPressed: () {
                      Routemaster.of(context).push('/add-property');
                    },
                    child: const Text("Add Property"))
              ],
            ),
            const SizedBox(height: 20),
            ref.watch(getProductsByUserIdProvider(user.uid)).when(
                data: (data) {
                  if (data.isEmpty) {
                    return const ErrorText(text: 'No Properties Found');
                  }
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
      ),
    );
  }
}
