import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realstateclient/screens/order_screen.dart';
import 'package:realstateclient/screens/products_page.dart';
import 'package:realstateclient/screens/profile_screen.dart';
import 'package:realstateclient/widgets/navigation_drawer.dart';
import 'package:realstateclient/widgets/search_product_delegate.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<String> titles = const ["Home Screen", "Profile", "Orders"];

  int currentIndex = 0;
  List<Widget> widgetsList = [
    const ProductsPage(),
    const ProfileScreen(),
    const OrderScreen()
  ];

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      const BottomNavigationBarItem(icon: Icon(Icons.book), label: "Booking"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: SearchProductDelegate(ref));
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: widgetsList[currentIndex],
      ),
      drawer: const ProfileDrawer(),
      bottomNavigationBar: CupertinoTabBar(
          items: items,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          }),
    );
  }
}
