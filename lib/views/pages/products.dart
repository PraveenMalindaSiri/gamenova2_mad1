import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:gamenova2_mad1/core/service/product_service.dart';
import 'package:gamenova2_mad1/core/utility/colors.dart';
import 'package:gamenova2_mad1/views/pages/product_view.dart';
import 'package:gamenova2_mad1/views/widgets/card.dart';
import 'package:gamenova2_mad1/views/widgets/dialog_helper.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _rpgGames = [];
  List<Product> _shooterGames = [];
  List<Product> _racingGames = [];

  final List<String> types = ['All', "Physical", "Digital"];
  final List<String> platforms = ['All', "PC", "XBOX", "PS4", "PS5"];
  final List<String> genres = ['All', "Shooter", "RPG", "Racing"];

  String? _selectedType = "All";
  String? _selectedPlatform = "All";
  String? _selectedGenre = "All";

  bool _isLoading = true;

  Future<void> getSections() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final type = _selectedType == 'All' ? '' : _selectedType;
      final genre = _selectedGenre == 'All' ? '' : _selectedGenre;
      final platform = _selectedPlatform == 'All' ? '' : _selectedPlatform;

      final products = await ProductService.getAllProducts(
        genre: genre,
        platform: platform,
        type: type,
      );

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
        title: 'Loading Games failed',
        // message: e.toString(),
        type: NoticeType.error,
      );
    }
  }

  Widget buildTypes(context, double width) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: _selectedType,
        items: types
            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedType = value;
          });
          getSections();
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: "Select Edition",
        ),
      ),
    );
  }

  Widget buildGenre(context, double width) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        value: _selectedGenre,
        items: genres
            .map((genre) => DropdownMenuItem(value: genre, child: Text(genre)))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedGenre = value;
          });
          getSections();
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: "Select Genre",
        ),
      ),
    );
  }

  Widget buildPlatform(context, double width) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        value: _selectedPlatform,
        items: platforms
            .map(
              (platform) =>
                  DropdownMenuItem(value: platform, child: Text(platform)),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedPlatform = value;
          });
          getSections();
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: "Select Platforms",
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getSections();
  }

  Widget _buildGenreSection(String title, List<Product> games) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
              height: games.isEmpty ? 100 : 350,
              child: games.isEmpty
                  ? Center(child: Text("No $title available."))
                  : ListView.builder(
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
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        buildTypes(context, 120),
                        buildGenre(context, 120),
                        buildPlatform(context, 120),
                      ],
                    ),
                  ),
                  _buildGenreSection('RPG Games', _rpgGames),
                  _buildGenreSection('Shooter Games', _shooterGames),
                  _buildGenreSection('Racing Games', _racingGames),
                  Padding(padding: EdgeInsetsGeometry.only(bottom: 10)),
                ],
              ),
            ),
    );
  }
}
