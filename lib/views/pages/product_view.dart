// ignore_for_file: non_constant_identifier_names, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:gamenova2_mad1/core/provider/auth_provider.dart';
import 'package:gamenova2_mad1/core/service/cart_service.dart';
import 'package:gamenova2_mad1/core/service/wishlist_service.dart';
import 'package:gamenova2_mad1/views/widgets/button.dart';
import 'package:gamenova2_mad1/views/widgets/dialog_helper.dart';
import 'package:provider/provider.dart';

class ProductViewScreen extends StatefulWidget {
  final Product game;

  const ProductViewScreen({super.key, required this.game});
  @override
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  int? amount;
  String? error;
  final AmountCnt = TextEditingController(text: "1");
  final formkey = GlobalKey<FormState>();
  bool _isLoading = true;

  Widget myIMG(String path, double width, double height) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            path,
            fit: BoxFit.fill,
            width: width,
            height: height,
          ),
        ),
      ),
    );
  }

  Future<void> addToWishlist(int amount, Product game) async {
    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthProvider>();
      final token = auth.token ?? '';

      await WishlistService.addToWishlist(
        token: token,
        productId: game.id,
        quantity: amount,
      );

      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Added to Wishlist',
        message: "'${game.title}' added to Wishlist.",
        type: NoticeType.success,
      );
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
        title: 'Adding to Wishlist failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    }
  }

  Future<void> addToCart(int amount, Product game) async {
    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthProvider>();
      final uid = auth.userId;

      await CartService.addItem(uid!, game.id, amount);

      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Added to Cart',
        message: "'${game.title}' added to Cart.",
        type: NoticeType.success,
      );
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);

      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Adding to Cart failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    }
  }

  Widget buildAmount() {
    return Form(
      key: formkey,
      child: SizedBox(
        width: 300,
        child: TextFormField(
          controller: AmountCnt,
          keyboardType: TextInputType.number,
          style: Theme.of(context).textTheme.bodyMedium, // input color
          validator: (value) {
            if (value == null || value.isEmpty) {
              return ("Please fill the Amount corectly.");
            }

            final Amount = int.tryParse(value);

            if (Amount == null) {
              return ("Amount must be a number.");
            }
            if (Amount <= 0) {
              return ("Amount must be at least 1.");
            }
            if (widget.game.type.toLowerCase() == "digital" && Amount > 1) {
              return ("You can't add more than 1 Digital Edition");
            }

            return null;
          },
          decoration: InputDecoration(
            labelText: 'Amount',
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSticker(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'font1',
          ),
        ),
      ),
    );
  }

  Widget buildDetails(String topic, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            topic,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontFamily: 'font1'),
            textAlign: TextAlign.center,
          ),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontFamily: 'font1'),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildPortrait() {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(bottom: 10)),

          // name
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              widget.game.title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontSize: 24),
            ),
          ),

          // price
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Rs.${widget.game.price}",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontSize: 24),
            ),
          ),

          // img
          myIMG(widget.game.imageUrl, 300, 300),
          Padding(padding: EdgeInsets.only(bottom: 10)),

          // stickers
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildSticker('${widget.game.type} Edition'),
                  buildSticker('${widget.game.genre} games'),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildSticker(widget.game.platform),
                  buildSticker('${widget.game.ageRating}+'),
                ],
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),

          // description
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              widget.game.description,
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(fontFamily: 'font2'),
              textAlign: TextAlign.center,
            ),
          ),

          // details
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: buildDetails("Released Date:", widget.game.releasedAt!),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: buildDetails("Size:", "${widget.game.size}GB"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: buildDetails("Company:", widget.game.company),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: buildDetails("Duration:", "${widget.game.duration}H"),
          ),

          // amount
          buildAmount(),
          Padding(padding: EdgeInsets.only(bottom: 10)),

          // error
          if (error != null)
            Text(
              error!,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          Padding(padding: EdgeInsets.only(bottom: 10)),

          // buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MyButton("Add To Wishlist", () {
                if (formkey.currentState!.validate()) {
                  final amount = int.parse(AmountCnt.text);
                  addToWishlist(amount, widget.game);
                }
              }, Colors.black),
              MyButton("Add To Cart", () {
                if (formkey.currentState!.validate()) {
                  final amount = int.parse(AmountCnt.text);
                  addToCart(amount, widget.game);
                }
              }, Colors.black),
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
        ],
      ),
    );
  }

  Widget buildLandscape() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                // IMG
                myIMG(widget.game.imageUrl, 250, 250),

                // stickers
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildSticker('${widget.game.type} Edition'),
                          buildSticker('${widget.game.genre} games'),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildSticker(widget.game.platform),
                          buildSticker('${widget.game.ageRating}+'),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
              ],
            ),
            Column(
              children: [
                Padding(padding: EdgeInsets.only(bottom: 10)),

                // name
                Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: Text(
                    widget.game.title,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(fontSize: 24),
                  ),
                ),

                // price
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Rs.${widget.game.price}",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(fontSize: 24),
                  ),
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: buildDetails(
                          "Released Date:",
                          widget.game.releasedAt!,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: buildDetails("Size:", "${widget.game.size}GB"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: buildDetails("Company:", widget.game.company),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: buildDetails(
                          "Duration:",
                          "${widget.game.duration}H",
                        ),
                      ),
                    ],
                  ),
                ),

                // amount input
                buildAmount(),
                Padding(padding: EdgeInsets.only(bottom: 10)),

                // error
                if (error != null)
                  Text(
                    error!,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),

                // buttons
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyButton("Add To Wishlist", () {
                        if (formkey.currentState!.validate()) {
                          final amount = int.parse(AmountCnt.text);
                          addToWishlist(amount, widget.game);
                        }
                      }, Colors.black),
                      MyButton("Add To Cart", () {
                        if (formkey.currentState!.validate()) {
                          final amount = int.parse(AmountCnt.text);
                          addToCart(amount, widget.game);
                        }
                      }, Colors.black),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Center(child: Text("GameNova", style: TextStyle(fontSize: 30))),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [buildPortrait()],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [buildLandscape()],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
