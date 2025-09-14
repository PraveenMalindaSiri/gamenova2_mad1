import 'package:flutter/material.dart';
import 'package:mad_1_gamenova_1/core/game.dart';
import 'package:mad_1_gamenova_1/core/games_lists.dart';
import 'package:mad_1_gamenova_1/views/pages/payment.dart';
import 'package:mad_1_gamenova_1/views/widgets/button.dart';
import 'package:mad_1_gamenova_1/views/widgets/itemLanscape.dart';
import 'package:mad_1_gamenova_1/views/widgets/itemPortrait.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool agreed = false;
  double totalPrice = 0;
  String? error;

  void remove(Game game) {
    setState(() {
      cartGames.remove(game);
    });
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
    final entries = cartGames.entries.toList();
    totalPrice = 0;
    entries.forEach((entry) {
      totalPrice += (entry.key.price * entry.value);
    });
    if (entries.isEmpty) {
      return Center(child: Text("No Cart Items"));
    } else {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      if (constraints.maxWidth > 800) {
                        return ItemLanscapeView(
                          game: entries[index].key,
                          amount: entries[index].value,
                          isWishlist: false,
                          onRemove: () => remove(entries[index].key),
                        );
                      } else {
                        return ItemPortraitView(
                          game: entries[index].key,
                          amount: entries[index].value,
                          isWishlist: false,
                          onRemove: () => remove(entries[index].key),
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
}
