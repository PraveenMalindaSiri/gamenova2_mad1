import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:gamenova2_mad1/core/utility/colors.dart';
import 'package:gamenova2_mad1/views/pages/product_view.dart';
import 'package:gamenova2_mad1/views/widgets/button.dart';
import 'package:gamenova2_mad1/views/widgets/image_container.dart';

class ItemLanscapeView extends StatelessWidget {
  final Product game;
  final int amount;
  final bool isWishlist;
  final VoidCallback onRemove;
  final void Function(int delta)? onUpdate;
  final VoidCallback? onCart;
  final bool canRedirect;
  const ItemLanscapeView({
    super.key,
    required this.game,
    required this.amount,
    required this.isWishlist,
    required this.onRemove,
    this.onUpdate,
    this.onCart,
    required this.canRedirect,
  });

  Widget updateWishlistAmnt(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
          constraints: BoxConstraints(maxWidth: 600, minHeight: 250),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 10, 8),
                child: GestureDetector(
                  onDoubleTap: () {
                    if (canRedirect) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductViewScreen(game: game),
                        ),
                      );
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SizedBox(
                        width: 220,
                        child: productImage(game.imageUrl, 220),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 10),

                    Text(
                      game.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    if (game.type.toLowerCase() != 'digital' && isWishlist)
                      updateWishlistAmnt(context),
                    if (game.type.toLowerCase() == 'digital')
                      Text(
                        "x $amount",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(height: 10),
                    Text(
                      "Rs.${game.price * amount}",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),

                    if (isWishlist && onCart != null)
                      MyButton("Add to Cart", onCart!, Colors.black),
                    SizedBox(height: 10),

                    MyButton("Remove", onRemove, Colors.white),

                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
