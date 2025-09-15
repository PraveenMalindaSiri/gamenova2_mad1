import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:gamenova2_mad1/views/pages/customer/payment.dart';
import 'package:gamenova2_mad1/views/widgets/button.dart';
import 'package:gamenova2_mad1/views/widgets/itemLanscape.dart';
import 'package:gamenova2_mad1/views/widgets/itemPortrait.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool agreed = false;
  double totalPrice = 0;
  String? error;

  void remove(Product game) {
    //
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
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ListView.builder(
                  // itemCount: ,
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
          ),
          buildTotalPrice(),
        ],
      ),
    );
  }
}
