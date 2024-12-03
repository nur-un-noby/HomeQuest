import 'package:flutter/material.dart';
import 'package:realstateclient/screens/add_order_screen.dart';
import 'package:realstateclient/screens/add_product_screen.dart';
import 'package:realstateclient/screens/layout.dart';
import 'package:realstateclient/screens/login_screen.dart';
import 'package:realstateclient/screens/order_detatil.dart';
import 'package:realstateclient/screens/producr_details_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: HomeScreen()),
  '/add-property': (_) => const MaterialPage(child: CreateProductScreen()),
  '/product/:id': (route) => MaterialPage(
          child: ProductDetailScreen(
        productId: route.pathParameters['id']!,
      )),
  '/create-order/:id': (route) => MaterialPage(
          child: CreateOrderScreen(
        productId: route.pathParameters['id']!,
      )),
  '/order/:id': (route) => MaterialPage(
          child: OrderDetails(
        orderId: route.pathParameters['id']!,
      )),
});
