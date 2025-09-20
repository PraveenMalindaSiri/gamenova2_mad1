// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:gamenova2_mad1/core/provider/auth_provider.dart';
import 'package:gamenova2_mad1/core/service/product_service.dart';
import 'package:gamenova2_mad1/core/utility/colors.dart';
import 'package:gamenova2_mad1/views/pages/product_view.dart';
import 'package:gamenova2_mad1/views/pages/seller/create.dart';
import 'package:gamenova2_mad1/views/widgets/card.dart';
import 'package:gamenova2_mad1/views/widgets/dialog_helper.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int)? onGoToTab;
  const HomeScreen({super.key, this.onGoToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _latestGames = [];
  List<Product> _featuredGames = [];
  bool _isLoading = true;

  Future<void> getSections() async {
    setState(() => _isLoading = true);
    // print("object");
    try {
      final sections = await ProductService.getHomeSreenSections();
      final List<Product> latest = sections['latest'] ?? [];
      final List<Product> featured = sections['featured'] ?? [];

      setState(() {
        _latestGames = latest;
        _featuredGames = featured;
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
        title: 'Loading Games failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void redirectSeller(Product game) {
    final auth = context.read<AuthProvider>();
    final token = auth.token ?? '';
    final role = auth.role ?? '';
    // print(role);
    if (role != 'seller') return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageGame(game: game, token: token),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getSections();
  }

  Widget _buildIntro() {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(bottom: 10)),

        // bg img
        Container(
          width: double.infinity,
          height: 500,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/main/main_img2.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(bottom: 20)),

              // Top Welcome
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Welcome to GameNova",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),

              // Intro
              Center(
                child: Text(
                  'Level up your game collection now. Buy physical or digital edition of your next game. No region locks. No other barriers. Just pure gaming vibe. Gear up and game on!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIntroLand() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkGray : Colors.white,
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
            children: [
              Padding(padding: EdgeInsets.only(top: 10)),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Welcome to GameNova",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: Text(
                    'Level up your game collection now. Buy physical or digital edition of your next game. No region locks. No other barriers. Just pure gaming vibe. Gear up and game on!',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: Image.asset(
              "assets/images/main/main_img.png",
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width * 0.3,
              color: !isDark ? AppColors.darkGray : Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String edition, List<Product> games) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkGray : Colors.white,
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
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    edition,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => widget.onGoToTab?.call(1),
                    child: Text(
                      "See more...",
                      style: TextStyle(
                        color: AppColors.darkSkyBlue,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            SizedBox(
              height: games.isEmpty ? 100 : 350,
              child: games.isEmpty
                  ? Center(child: Text("No $edition available."))
                  : ListView.separated(
                      separatorBuilder: (_, __) =>
                          const Padding(padding: EdgeInsets.all(5)),
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
                          onDoubleTap: () => redirectSeller(games[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 700) {
                    return Column(
                      children: [
                        _buildIntro(),
                        _buildSection('Latest Games', _latestGames),
                        _buildSection("Featured Games", _featuredGames),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildIntroLand(),
                        _buildSection('Latest Games', _latestGames),
                        _buildSection("Featured Games", _featuredGames),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                      ],
                    );
                  }
                },
              ),
            ),
    );
  }
}
