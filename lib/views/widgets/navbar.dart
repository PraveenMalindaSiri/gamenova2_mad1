import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final String userRole;

  const MyNavigation({
    super.key,
    required this.currentIndex,
    required this.userRole,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GNav(
        selectedIndex: currentIndex,
        onTabChange: onTap,
        gap: 6,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        tabBackgroundColor: isDark ? Colors.white : Colors.black,
        backgroundColor: Colors.transparent, // Nav bar background
        activeColor: Theme.of(
          context,
        ).colorScheme.primary, // color for selected tab
        color: Colors.blueGrey, // color for unselected tabs
        iconSize: 24, // Icon size
        curve: Curves.easeInOut, // Animation curve
        tabs: [
          GButton(icon: Icons.home, text: "Home"),
          GButton(icon: Icons.games, text: "Games"),
          if (userRole.toLowerCase() == 'customer') ...[
            GButton(icon: Icons.favorite, text: "Wishlist"),
            GButton(icon: Icons.shopping_bag, text: "Cart"),
          ],
          if (userRole.toLowerCase() == 'seller') ...[
            GButton(
              icon: Icons.production_quantity_limits,
              text: "My Products",
            ),
          ],
        ],
      ),
    );
  }
}
