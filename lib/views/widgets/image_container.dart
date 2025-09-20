import 'package:flutter/material.dart';

Widget productImage(String pathOrUrl, double height) {
  // final isUrl = pathOrUrl.startsWith(
  //   'http',
  // ); // accept with full or half url of an img
  final src = '';
  // final src = isUrl
  //     ? pathOrUrl
  //     : 'https://gamenova.s3.ap-south-1.amazonaws.com/$pathOrUrl';
  return Image.network(
    src,
    height: height,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 200),
  );
}
