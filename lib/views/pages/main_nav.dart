import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/provider/auth_provider.dart';
import 'package:gamenova2_mad1/core/utility/colors.dart';
import 'package:gamenova2_mad1/views/pages/about.dart';
import 'package:gamenova2_mad1/views/pages/auth/login.dart';
import 'package:gamenova2_mad1/views/pages/customer/cart.dart';
import 'package:gamenova2_mad1/views/pages/customer/wishlist.dart';
import 'package:gamenova2_mad1/views/pages/home.dart';
import 'package:gamenova2_mad1/views/pages/products.dart';
import 'package:gamenova2_mad1/views/pages/seller/myproducts.dart';
import 'package:gamenova2_mad1/views/widgets/navbar.dart';
import 'package:gamenova2_mad1/views/widgets/network_info.dart';
import 'package:provider/provider.dart';

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
    final r = (context.read<AuthProvider>().role ?? '').toLowerCase();
    if (r == 'seller') {
      switch (i) {
        case 0:
          return HomeScreen(onGoToTab: _navigate);
        case 1:
          return const ProductsScreen();
        case 2:
          return const MyProducts();
        default:
          return const SizedBox.shrink();
      }
    } else {
      // customer
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
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final role = context.watch<AuthProvider>().role ?? '';
    final tabsCount = (role == 'seller') ? 3 : (role == 'customer' ? 4 : 2);
    if (_index >= tabsCount) _index = 0;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Center(
          child: Text("GameNova", style: TextStyle(fontSize: 30)),
        ),
        actions: [Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: NetworkInfo(),
        )],
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
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => About()),
                    );
                  },
                  child: Text(
                    "About",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              // logout
              TextButton(
                onPressed: () async {
                  final auth = context.read<AuthProvider>();
                  // print(auth.token);

                  if (auth.isLoggedIn) {
                    await auth.logout();
                    // print(auth.token);
                  }
                  if (!mounted) return;
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
        padding: isLandscape
            ? EdgeInsets.symmetric(vertical: 5, horizontal: 30)
            : EdgeInsets.only(bottom: 45),
        child: MyNavigation(
          currentIndex: _index,
          onTap: _navigate,
          userRole: role,
        ),
      ),
    );
  }
}
