import 'package:flutter/material.dart';
import 'package:mad_1_gamenova_1/views/pages/digital_products.dart';
import 'package:mad_1_gamenova_1/views/pages/physical_products.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // if current is 0, show physical else digital
          Expanded(child: current == 0 ? PhysicalScreen() : DigitalScreen()),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      current = 0;
                    });
                  },
                  child: Text("Physical", style: TextStyle(fontSize: 18)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      current = 1;
                    });
                  },
                  child: Text("Digital", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
