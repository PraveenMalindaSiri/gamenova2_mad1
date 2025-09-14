// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mad_1_gamenova_1/core/colors.dart';
import 'package:mad_1_gamenova_1/core/game.dart';
import 'package:mad_1_gamenova_1/core/games_lists.dart';
import 'package:mad_1_gamenova_1/views/pages/main_nav.dart';
import 'package:mad_1_gamenova_1/views/pages/product_view.dart';
import 'package:mad_1_gamenova_1/views/widgets/card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              color:  !isDark ? AppColors.darkGray : Colors.white,
              
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditionSection(String edition, List<Game> games) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
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
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MainNavScreen(selectPageIndex: 1),
                        ),
                      );
                    },
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
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: GameCard(game: games[index]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ProductViewScreen(game: games[index]),
                        ),
                      );
                    },
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
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) {
              return Column(
                children: [
                  _buildIntro(),
                  _buildEditionSection('Physical Editions', pGames),
                  _buildEditionSection("Digital Editions", dGames),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildIntroLand(),
                  _buildEditionSection('Physical Editions', pGames),
                  _buildEditionSection("Digital Editions", dGames),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
