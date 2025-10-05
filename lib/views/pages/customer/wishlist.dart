import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/wishlist.dart';
import 'package:gamenova2_mad1/core/provider/auth_provider.dart';
import 'package:gamenova2_mad1/core/service/cart_service.dart';
import 'package:gamenova2_mad1/core/service/wishlist_service.dart';
import 'package:gamenova2_mad1/views/widgets/dialog_helper.dart';
import 'package:gamenova2_mad1/views/widgets/itemLanscape.dart';
import 'package:gamenova2_mad1/views/widgets/itemPortrait.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<WishlistItem> _wishlist = [];
  bool _isLoading = true;

  Future<void> loadWishlist() async {
    setState(() => _isLoading = true);
    try {
      final auth = context.read<AuthProvider>();
      final token = auth.token ?? '';

      final list = await WishlistService.getWishlist(token);

      setState(() {
        _wishlist = list;
      });

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
        title: 'Loading Wishlist failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    }
  }

  Future<void> addToCart(WishlistItem item) async {
    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthProvider>();
      final uid = auth.userId;
      final age = auth.age!;

      if (age < item.product.ageRating) {
        if (!mounted) return;
        await showNoticeDialog(
          context: context,
          title: 'Adding to Cart failed',
          message: "You are not old enough to buy this game!!!",
          type: NoticeType.warning,
        );
        setState(() => _isLoading = false);
        return;
      }

      if (item.product.type.toLowerCase() == 'digital') {
        final exists = await CartService.isInUserCart(uid!, item.product.id);
        if (exists) {
          if (!mounted) return;
          await showNoticeDialog(
            context: context,
            title: 'Adding to Cart failed',
            message: "You already have this digital item in the Cart",
            type: NoticeType.error,
          );
          setState(() => _isLoading = false);
          return;
        }
        await CartService.addItem(uid, item.productId, item.quantity);
      } else {
        await CartService.addItem(uid!, item.productId, item.quantity);
      }

      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Added to Cart',
        message: "'${item.product.title}' added to Cart.",
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
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> updateWishlistAmount(WishlistItem item, int delta) async {
    setState(() => _isLoading = true);
    final newQty = (item.quantity + delta);

    try {
      final auth = context.read<AuthProvider>();
      final token = auth.token ?? '';

      await WishlistService.updateWishlistItem(
        token: token,
        id: item.id,
        quantity: newQty,
      );

      print(item.product.type);

      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Updated Wishlist',
        message: "'${item.product.title}'updated Wishlist amount.",
        type: NoticeType.success,
      );
      loadWishlist();
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
        title: 'Updating Wishlist failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    }
  }

  Future<void> remove(WishlistItem item) async {
    try {
      final auth = context.read<AuthProvider>();
      final token = auth.token ?? '';

      await WishlistService.deleteWishlistItem(token: token, id: item.id);
      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Removed',
        message: "'${item.product.title}' removed from wishlist.",
        type: NoticeType.success,
      );
      loadWishlist();
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
        title: 'Deleting item failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _wishlist.isEmpty
          ? Center(child: Text("No Wishlist available."))
          : LayoutBuilder(
              builder: (context, constraints) {
                return ListView.builder(
                  itemCount: _wishlist.length,
                  itemBuilder: (context, index) {
                    final item = _wishlist[index];
                    if (constraints.maxWidth > 800) {
                      return ItemLanscapeView(
                        amount: item.quantity,
                        game: item.product,
                        isWishlist: true,
                        onCart: () => addToCart(item),
                        onRemove: () => remove(item),
                        onUpdate: (delta) => updateWishlistAmount(item, delta),
                        canRedirect: true,
                      );
                    } else {
                      return ItemPortraitView(
                        amount: item.quantity,
                        game: item.product,
                        isWishlist: true,
                        onCart: () => addToCart(item),
                        onRemove: () => remove(item),
                        onUpdate: (delta) => updateWishlistAmount(item, delta),
                        canRedirect: true,
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
