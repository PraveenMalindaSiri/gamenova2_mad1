import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/utility/colors.dart';
import 'package:gamenova2_mad1/views/pages/auth/login.dart';
import 'package:gamenova2_mad1/views/pages/customer/cart.dart';
import 'package:gamenova2_mad1/views/pages/customer/wishlist.dart';
import 'package:gamenova2_mad1/views/pages/home.dart';
import 'package:gamenova2_mad1/views/pages/products.dart';
import 'package:gamenova2_mad1/views/widgets/navbar.dart';

class MainNavScreen extends StatefulWidget {
  final int selectPageIndex;
  const MainNavScreen({super.key, required this.selectPageIndex});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.selectPageIndex;
  }

  @override
  void didUpdateWidget(covariant MainNavScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectPageIndex != widget.selectPageIndex) {
      _index = widget.selectPageIndex;
    }
  }

  void _navigate(int i) {
    if (_index == i) return;
    setState(() => _index = i);
  }

  Widget _drawerItem(String text, int index) {
    return TextButton(
      onPressed: () {
        _navigate(index);
        Navigator.pop(context);
      },
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }

  Widget _buildPage(int i) {
    switch (i) {
      case 0:
        return HomeScreen(onGoToTab: _navigate);
      case 1:
        return const ProductsScreen();
      case 2:
        return const WishlistScreen();
      case 3:
        return const CartScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Center(
          child: Text("GameNova", style: TextStyle(fontSize: 30)),
        ),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.all(10),
                child: _drawerItem("Home", 0),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: _drawerItem("Games", 1),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: _drawerItem("Wishlist", 2),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: _drawerItem("Cart", 3),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Log-Out",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.darkSkyBlue,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.logout, size: 22),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Keep tab states alive
      body: _buildPage(_index),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MyNavigation(currentIndex: _index, onTap: _navigate),
      ),
    );
  }
}
