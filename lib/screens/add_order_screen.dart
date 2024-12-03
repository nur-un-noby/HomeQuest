import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realstateclient/controllers/auth_controller.dart';
import 'package:realstateclient/controllers/order_controller.dart';
import 'package:realstateclient/controllers/product_provider.dart';
import 'package:realstateclient/core/themes/app_themes.dart';
import 'package:realstateclient/core/widgets/show_snackbar.dart';

class CreateOrderScreen extends ConsumerStatefulWidget {
  final String productId;

  const CreateOrderScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateOrderScreenState();
}

class _CreateOrderScreenState extends ConsumerState<CreateOrderScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void createOrder(
      WidgetRef ref, double price, String ownerId, String productId) {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      showSnackBar(context, "All fields are required");
      return;
    }
    final bdPhoneNumberRegex = RegExp(r'^01[3-9]\d{8}$');

    if (!bdPhoneNumberRegex.hasMatch(phoneController.text)) {
      showSnackBar(context, "Invalid Phone Number");
      return;
    }
    ref.read(orderControllerProvider.notifier).createOrder(
        context,
        ref,
        nameController.text.trim(),
        phoneController.text.trim(),
        addressController.text.trim(),
        price,
        ownerId,
        productId);
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider)!;
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(productProvider)!;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Place New Order',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  "Information",
                  style: AppTheme.mediumTextStyle,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: "Enter your name",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: "Enter your Email",
                      enabled: false),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    hintText: "Enter your Phone",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    hintText: "Enter your Address",
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Price:${product.price}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(
                  "Product: ${product.title}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                InkWell(
                    onTap: () => createOrder(
                        ref, product.price, product.userId, product.id),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Place Order",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
