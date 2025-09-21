import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/cart.dart';
import 'package:gamenova2_mad1/core/provider/auth_provider.dart';
import 'package:gamenova2_mad1/core/service/cart_service.dart';
import 'package:gamenova2_mad1/views/pages/customer/payment.dart';
import 'package:gamenova2_mad1/views/widgets/button.dart';
import 'package:gamenova2_mad1/views/widgets/dialog_helper.dart';
import 'package:gamenova2_mad1/views/widgets/itemLanscape.dart';
import 'package:gamenova2_mad1/views/widgets/itemPortrait.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cart = [];
  bool _isLoading = true;

  bool agreed = false;
  double totalPrice = 0;
  String token = '';

  // Future<void> loadCart() async {
  //   setState(() => _isLoading = true);
  //   try {
  //     final auth = context.read<AuthProvider>();
  //     final userId = auth.user!.id;

  //     final items = await CartService.getCart(userId);
  //     if (!mounted) return;

  //     setState(() {
  //       _cart = items;
  //       _isLoading = false;
  //     });
  //     calcCartTotal();
  //   } catch (e) {
  //     if (!mounted) return;
  //     setState(() {
  //       _isLoading = false;
  //       error = 'Failed to load cart: $e';
  //     });
  //   }
  // }

  Future<void> loadCart() async {
    setState(() => _isLoading = true);
    try {
      final auth = context.read<AuthProvider>();
      final token2 = auth.token ?? '';
      token = token2;

      final list = await CartService.getCartAPI(token);

      setState(() {
        _cart = list;
      });

      if (mounted) setState(() => _isLoading = false);
    } on TimeoutException {
      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Network timeout',
        message: 'Please check your connection and try again.',
        type: NoticeType.warning,
      );
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);

      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Loading Cart failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    }
  }

  Future<void> remove(CartItem item) async {
    try {
      final auth = context.read<AuthProvider>();
      final userId = auth.user!.id;

      await CartService.removeItem(userId, item.productId);

      if (!mounted) return;
      setState(() {
        _cart.removeWhere((c) => c.productId == item.productId);
      });
      calcCartTotal();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Removed from cart')));
    } catch (e) {
      if (!mounted) return;
      showNoticeDialog(
        context: context,
        title: 'Remove failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    }
  }

  void calcCartTotal() {
    double sum = 0;
    for (final item in _cart) {
      final price = double.tryParse(item.product!.price.toString()) ?? 0;
      sum += price * item.quantity;
    }
    setState(() => totalPrice = sum);
  }

  void checkout(total) async {
    // if (total == 0) {
    //   await showNoticeDialog(
    //     context: context,
    //     title: 'Checkout failed',
    //     message: "You cannot proceed to checkout with an empty cart",
    //     type: NoticeType.error,
    //   );
    //   return;
    // } else
    if (!agreed) {
      await showNoticeDialog(
        context: context,
        title: 'Checkout failed',
        message: "You must agree with the terms and conditions.",
        type: NoticeType.error,
      );
      return;
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return PaymentScreen(token: token);
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Widget buildTotalPrice() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Checkbox(
                  value: agreed,
                  onChanged: (bool? value) {
                    setState(() {
                      agreed = value ?? false;
                    });
                  },
                ),
                Text("Terms and conditions"),
              ],
            ),
            Text("Rs.${totalPrice.toString()}"),
          ],
        ),
        MyButton("CHECK OUT", () => checkout(totalPrice), Colors.black),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _cart.isEmpty
                ? Center(child: Text("No Cart available."))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return ListView.builder(
                        itemCount: _cart.length,
                        itemBuilder: (context, index) {
                          final item = _cart[index];
                          if (constraints.maxWidth > 800) {
                            return ItemLanscapeView(
                              amount: item.quantity,
                              game: item.product!,
                              isWishlist: false,
                              onRemove: () => remove(item),
                            );
                          } else {
                            return ItemPortraitView(
                              amount: item.quantity,
                              game: item.product!,
                              isWishlist: false,
                              onRemove: () => remove(item),
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
          buildTotalPrice(),
        ],
      ),
    );
  }
}
