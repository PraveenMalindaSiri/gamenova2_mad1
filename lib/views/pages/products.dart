import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:gamenova2_mad1/core/service/product_service.dart';
import 'package:gamenova2_mad1/core/utility/colors.dart';
import 'package:gamenova2_mad1/views/pages/product_view.dart';
import 'package:gamenova2_mad1/views/widgets/card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _rpgGames = [];
  List<Product> _shooterGames = [];
  List<Product> _racingGames = [];

  bool _isLoading = true;

  Future<void> getSections() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final products = await ProductService.getAllProducts();

      final rpg = <Product>[];
      final shooter = <Product>[];
      final racing = <Product>[];

      print(products);

      for (final p in products) {
        final genre = p.genre.toLowerCase().trim();
        if (genre == 'rpg') {
          rpg.add(p);
        } else if (genre == 'shooter') {
          shooter.add(p);
        } else if (genre == 'racing') {
          racing.add(p);
        }
      }

      if (!mounted) return;
      setState(() {
        _rpgGames = rpg;
        _shooterGames = shooter;
        _racingGames = racing;
        _isLoading = false;
      });

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      if (!mounted) return;
    }
  }

  @override
  void initState() {
    super.initState();
    getSections();
  }

  Widget _buildGenreSection(String title, List<Product> games) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkGray : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: games.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: GameCard(game: games[index]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductViewScreen(game: games[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_rpgGames.isEmpty && _racingGames.isEmpty && _shooterGames.isEmpty) {
      return const Scaffold(body: Center(child: Text("No Games available.")));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_rpgGames.isNotEmpty)
              _buildGenreSection('RPG Games', _rpgGames),
            if (_shooterGames.isNotEmpty)
              _buildGenreSection('Shooter Games', _shooterGames),
            if (_racingGames.isNotEmpty)
              _buildGenreSection('Racing Games', _racingGames),
          ],
        ),
      ),
    );
  }
}
