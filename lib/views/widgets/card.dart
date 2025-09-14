// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:mad_1_gamenova_1/core/game.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 200,
        height: 300,
        constraints: BoxConstraints(maxWidth: 200, maxHeight: 400),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 11, 43, 69),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  game.image,
                  fit: BoxFit.fill,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    game.type,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Rs.${game.price}',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 15,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
