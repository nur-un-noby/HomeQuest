import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realstateclient/controllers/auth_controller.dart';
import 'package:realstateclient/core/utils/upload_image.dart';
import 'package:realstateclient/core/widgets/show_snackbar.dart';
import 'package:realstateclient/models/product_model.dart';
import 'package:realstateclient/repository/products_repository.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final productControllerProvider = StateNotifierProvider((ref) {
  return ProductController(
      productRepository: ref.watch(productRepositoryProvider), ref: ref);
});

final getAllProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  return ref.watch(productControllerProvider.notifier).getAllProducts();
});

final searchProductsProvider = StreamProvider.family((ref, String query) {
  return ref.watch(productControllerProvider.notifier).searchProducts(query);
});

final getProductByIdProvider = StreamProvider.family((ref, String id) {
  return ref.watch(productControllerProvider.notifier).getProductById(id);
});

final getProductsByUserIdProvider = StreamProvider.family((ref, String userId) {
  return ref
      .watch(productControllerProvider.notifier)
      .getProductsByUserId(userId);
});

//controller

class ProductController extends StateNotifier<bool> {
  final ProductRepository _productRepository;
  final Ref _ref;

  ProductController(
      {required ProductRepository productRepository, required Ref ref})
      : _productRepository = productRepository,
        _ref = ref,
        super(false);

  Stream<List<ProductModel>> getAllProducts() {
    final res = _productRepository.getAllProducts();
    return res;
  }

  Stream<List<ProductModel>> searchProducts(String query) {
    final res = _productRepository.searchCommunites(query);
    log('searchProducts: $res');
    return res;
  }

  Stream<ProductModel> getProductById(String id) {
    return _productRepository.getProductById(id);
  }

  void addProduct({
    required BuildContext context,
    required String title,
    required String location,
    required String description,
    required double price,
    required File image,
  }) async {
    const uuid = Uuid();
    final id = uuid.v4();
    final user = _ref.read(userProvider)!;
    final imgUrl = await uploadImage(image: image, id: id);
    final ProductModel product = ProductModel(
        id: id,
        title: title,
        description: description,
        imageUrl: imgUrl,
        price: price,
        createdAt: DateTime.now(),
        location: location,
        userId: user.uid);

    final res = await _productRepository.addProduct(product);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Product Added Successfully');
      Routemaster.of(context).push('/');
    });
  }

  Stream<List<ProductModel>> getProductsByUserId(String userId) {
    return _productRepository.getProductsByUserId(userId);
  }

  void deleteProduct(String id) {
    _productRepository.deleteProduct(id);
  }
}
