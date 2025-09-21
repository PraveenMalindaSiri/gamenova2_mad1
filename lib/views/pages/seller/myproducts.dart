import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:gamenova2_mad1/core/provider/auth_provider.dart';
import 'package:gamenova2_mad1/core/service/seller_service.dart';
import 'package:gamenova2_mad1/views/pages/seller/create.dart';
import 'package:gamenova2_mad1/views/widgets/card.dart';
import 'package:gamenova2_mad1/views/widgets/dialog_helper.dart';
import 'package:provider/provider.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  List<Product> games = [];
  bool _isLoading = true;
  String sellertoken = '';

  Future<void> loadSellerProducts() async {
    setState(() => _isLoading = true);
    try {
      final auth = context.read<AuthProvider>();
      final token = auth.token ?? '';
      sellertoken = token;

      final list = await SellerService.getSellerGames(token);

      setState(() {
        games = list;
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
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    loadSellerProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ManageGame(token: sellertoken);
              },
            ),
          );
        },
        label: Text("Add"),
        icon: Icon(Icons.add),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : games.isEmpty
          ? Center(child: Text("No Wishlist available."))
          : ListView.separated(
              separatorBuilder: (_, __) =>
                  const Padding(padding: EdgeInsets.all(5)),
              itemCount: games.length,
              itemBuilder: (context, index) {
                return Center(
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 350,
                        child: GameCard(game: games[index]),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageGame(
                            game: games[index],
                            token: sellertoken,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
