import 'package:flutter/material.dart';
import 'package:mad_1_gamenova_1/core/colors.dart';
import 'package:mad_1_gamenova_1/views/pages/cart.dart';
import 'package:mad_1_gamenova_1/views/pages/home.dart';
import 'package:mad_1_gamenova_1/views/pages/login.dart';
import 'package:mad_1_gamenova_1/views/pages/products_screen.dart';
import 'package:mad_1_gamenova_1/views/pages/wishlist.dart';

class MainNavScreen extends StatefulWidget {
  final int selectPageIndex;
  const MainNavScreen({super.key, required this.selectPageIndex});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  void navigate(BuildContext context, int index) {
    if (index != widget.selectPageIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MainNavScreen(selectPageIndex: index);
          },
        ),
      );
    }
  }

  Widget getPage() {
    if (widget.selectPageIndex == 1) {
      return ProductsScreen();
    }
    if (widget.selectPageIndex == 2) {
      return WishlistScreen();
    }
    if (widget.selectPageIndex == 3) {
      return CartScreen();
    } else {
      return HomeScreen();
    }
  }

  Widget drawerItem(String text, int index) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainNavScreen(selectPageIndex: index),
          ),
        );
      },
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Center(child: Text("GameNova", style: TextStyle(fontSize: 30))),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.all(10),
                child: drawerItem("Home", 0),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: drawerItem("Games", 1),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: drawerItem("Wishlist", 2),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: drawerItem("Cart", 3),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
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
                    SizedBox(width: 5,),
                    Icon(Icons.logout, size: 22,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: getPage(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BottomNavigationBar(
          currentIndex: widget.selectPageIndex,
          onTap: (value) {
            navigate(context, value);
          },
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.blueGrey,
          elevation: 0, // remove shadow
          backgroundColor: Theme.of(context).colorScheme.secondary,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(color: Colors.grey),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.games), label: "Games"),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Wishlist",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: "Cart",
            ),
          ],
        ),
      ),
    );
  }
}
