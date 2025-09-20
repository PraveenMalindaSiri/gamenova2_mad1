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
  String? error;

  Future<void> loadCart() async {
    setState(() => _isLoading = true);
    try {
      final auth = context.read<AuthProvider>();
      final token = auth.token ?? '';

      final list = await CartService.getCart(token);

      setState(() {
        _cart = list;
        _isLoading = false;
      });
      calcCartTotal();
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
      // await CartService.deleteCartItem(id: id);
      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Removed',
        message: "'${item.product.title}' removed from Cart.",
        type: NoticeType.success,
      );
      loadCart();
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
        title: 'Deleteing item failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    }
  }

  void calcCartTotal() {
    double sum = 0;
    for (final item in _cart) {
      final price = double.tryParse(item.product.price.toString()) ?? 0;
      sum += price * item.quantity;
    }
    setState(() => totalPrice = sum);
  }

  void checkout(total) {
    setState(() {
      if (total == 0) {
        error = "You cannot proceed to checkout with an empty cart";
      } else if (!agreed) {
        error = "You must agree with the terms and conditions.";
      } else {
        error = null;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PaymentScreen();
            },
          ),
        );
      }
    });
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
        if (error != null)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(error!, style: TextStyle(color: Colors.red)),
          ),
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
                              game: item.product,
                              isWishlist: false,
                              onRemove: () => remove(item),
                            );
                          } else {
                            return ItemPortraitView(
                              amount: item.quantity,
                              game: item.product,
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
