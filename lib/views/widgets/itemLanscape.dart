import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:gamenova2_mad1/core/utility/colors.dart';
import 'package:gamenova2_mad1/views/pages/product_view.dart';
import 'package:gamenova2_mad1/views/widgets/button.dart';

class ItemLanscapeView extends StatelessWidget {
  final Product game;
  final int amount;
  final bool isWishlist;
  final VoidCallback onRemove;
  final void Function(int delta)? onUpdate;
  final VoidCallback? onCart;
  const ItemLanscapeView({
    super.key,
    required this.game,
    required this.amount,
    required this.isWishlist,
    required this.onRemove,
    this.onUpdate,
    this.onCart,
  });

  Widget updateWishlistAmnt(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => onUpdate!(-1),
          ),
          Text('$amount', style: Theme.of(context).textTheme.titleMedium),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => onUpdate!(1),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      game.title,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (game.type != 'digital') updateWishlistAmnt(context),
                  if (game.type == 'digital')
                    Text(
                      "x $amount",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    "Rs.${game.price * amount}",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  MyButton(
                    "Remove",
                    onRemove,
                    isDark ? Colors.white : Colors.black,
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  if (isWishlist && onCart != null)
                    MyButton("Add to Cart", onCart!, Colors.black),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
