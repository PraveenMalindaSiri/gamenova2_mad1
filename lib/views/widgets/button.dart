// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mad_1_gamenova_1/core/colors.dart';

Widget MyButton(String name, Function func, Color mainColor) {
  return ElevatedButton(
    onPressed: () => func(),
    style: ElevatedButton.styleFrom(
      backgroundColor: mainColor,
      foregroundColor: mainColor == Colors.white ? Colors.black : AppColors.neon,
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      textStyle: TextStyle(fontSize: 16)
    ),
    child: Text(name),
  );
}
