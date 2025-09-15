import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:gamenova2_mad1/core/utility/colors.dart';
import 'package:gamenova2_mad1/views/pages/product_view.dart';
import 'package:gamenova2_mad1/views/widgets/button.dart';

class ItemPortraitView extends StatelessWidget {
  final Product game;
  final int amount;
  final bool isWishlist;
  final VoidCallback onRemove;
  final VoidCallback? onCart;
  const ItemPortraitView({
    super.key,
    required this.game,
    required this.amount,
    required this.isWishlist,
    required this.onRemove,
    this.onCart,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkGray : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              spreadRadius: 4,
              blurRadius: 10,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductViewScreen(game: game),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  // in a container to give a border
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset(
                      game.imageUrl,
                      fit: BoxFit.fill,
                      height: 200,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              game.title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "x $amount",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rs.${game.price * amount}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyButton("Remove", onRemove, Colors.white),
                if (isWishlist && onCart != null)
                  MyButton("Add to Cart", onCart!, Colors.black),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
          ],
        ),
      ),
    );
  }
}
