import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/product.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  void remove(Product game) {
    //
  }

  void addToCart(int amount, Product game) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView.builder(
            // itemCount: entries.length,
            itemBuilder: (context, index) {
              if (constraints.maxWidth > 800) {
                //
              } else {
                //
              }
            },
          );
        },
      ),
    );
  }
}
