// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mad_1_gamenova_1/core/game.dart';
import 'package:mad_1_gamenova_1/core/games_lists.dart';
import 'package:mad_1_gamenova_1/views/widgets/button.dart';

class ProductViewScreen extends StatefulWidget {
  final Game game;

  const ProductViewScreen({super.key, required this.game});
  @override
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  int? amount;
  String? error;
  final AmountCnt = TextEditingController(text: "1");
  final formkey = GlobalKey<FormState>();

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

  void addToWishlist(int amount, Game game) {
    if (wishlistGames.containsKey(game) &&
        game.type.toLowerCase() == 'digital') {
      setState(() {
        error = 'Already in the Wishlist cannot add more Digital Editions';
      });
      return;
    }
    if (wishlistGames.containsKey(game)) {
      setState(() {
        error = null;
        wishlistGames[game] = wishlistGames[game]! + amount;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added more ${amount.toString()} copies to the Wishlist',
          ),
          duration: Duration(milliseconds: 1000),
        ),
      );
    } else {
      setState(() {
        wishlistGames[game] = amount;
        error = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to wishlist'),
          duration: Duration(milliseconds: 1000),
        ),
      );
    }
  }

  void addToCart(int amount, Game game) {
    if (cartGames.containsKey(game) && game.type.toLowerCase() == 'digital') {
      setState(() {
        error = 'Already in the Cart cannot add more Digital Editions';
      });
      return;
    }
    // cheking if the key is in the list before adding
    if (cartGames.containsKey(game)) {
      // if exists update the amount
      setState(() {
        error = null;
        cartGames[game] = cartGames[game]! + amount;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added more ${amount.toString()} copies to the Cart'),
          duration: Duration(milliseconds: 1000),
        ),
      );
    } else {
      // else add the new item
      setState(() {
        error = null;
        cartGames[game] = amount;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to Cart'),
          duration: Duration(milliseconds: 1000),
        ),
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
              widget.game.name,
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
          myIMG(widget.game.image, 300, 300),
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
            child: buildDetails("Released Date:", widget.game.releasedDate),
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
                myIMG(widget.game.image, 250, 250),

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
                    widget.game.name,
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
                          widget.game.releasedDate,
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
