// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/service/payment_service.dart';
import 'package:gamenova2_mad1/views/pages/customer/orderDetails.dart';
import 'package:gamenova2_mad1/views/widgets/dialog_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as gc;

class PaymentScreen extends StatefulWidget {
  final String token;
  const PaymentScreen({super.key, required this.token});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final CardHolder = TextEditingController();
  final Address = TextEditingController();
  final CardNo = TextEditingController();
  final ExpireDate = TextEditingController();
  final SecNo = TextEditingController();
  final formkey = GlobalKey<FormState>();

  bool _isSaving = false;
  int? id;

  Future<void> payment() async {
    if (!formkey.currentState!.validate()) return;
    setState(() {
      _isSaving = true;
    });
    try {
      final result = await PaymentService.payment(widget.token);
      id = result;
      if (!mounted) return;
      setState(() => _isSaving = false);
      await showNoticeDialog(
        context: context,
        title: 'Purchased',
        message: 'Game Purchased successfully.',
        type: NoticeType.success,
      );
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return OrderDetails(token: widget.token, id: id!);
          },
        ),
      );
    } on TimeoutException {
      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Network timeout',
        message: 'Please check your connection and try again.',
        type: NoticeType.warning,
      );
    } catch (e) {
      if (mounted) setState(() => _isSaving = false);

      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Purchasing failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    }
  }

  Future<void> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied.');
    }
  }

  Future<void> fillNearestName() async {
    await _ensureLocationPermission();

    final pos = await Geolocator.getCurrentPosition();

    try {
      final placemarks = await gc
          .placemarkFromCoordinates(
            pos.latitude,
            pos.longitude,
            localeIdentifier: 'en_LK',
          )
          .timeout(const Duration(seconds: 12));

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;

        final parts = <String?>[
          p.locality,
          p.administrativeArea,
          p.country,
        ].whereType<String>().where((s) => s.trim().isNotEmpty).toList();

        final line = parts.join(', ');
        if (line.isNotEmpty) Address.text = line;
      }
    } catch (_) {}
  }

  Widget buildDate(context, double width) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: ExpireDate,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return ("Enter the Expire Date.");
          }
          if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
            return "YYYY-MM-DD format only.";
          }

          final date = DateTime.tryParse(value);
          final now = DateTime.now();

          if (date == null) {
            return ("Numbers only.");
          }
          if (date.isBefore(now)) {
            return "Date must be in the future";
          }

          return null;
        },
        decoration: InputDecoration(
          hintText: "Expire Date",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildSecNo(context, double width) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: SecNo,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return ("Enter the Security No.");
          }

          final sec = int.tryParse(value);

          if (sec == null) {
            return ("Numbers Only");
          }
          if (SecNo.text.length != 3) {
            return ("Accept only 3 digits");
          }

          return null;
        },
        decoration: InputDecoration(
          hintText: "Security No.",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildForm(context) {
    return Form(
      key: formkey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // name
            SizedBox(
              width: 400,
              child: TextFormField(
                controller: CardHolder,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return ("Please fill the Card Holder name corectly.");
                  }
                  if (value.length < 6) {
                    return ("Card Holder name should have at least 6 letters");
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Card Holder",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),

            // card no
            SizedBox(
              width: 400,
              child: TextFormField(
                controller: CardNo,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return ("Please fill the Card No. corectly.");
                  }

                  final cn = int.tryParse(value);

                  if (cn == null) {
                    return ("Card No. must be a number.");
                  }
                  if (value.length < 12 || value.length > 19) {
                    return ("Card No. should have between 12 and 19 numbers");
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Card No.",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),

            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // buildDate(context, 200),
                      // SizedBox(width: 20),
                      buildSecNo(context, 400),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      // buildDate(context, 400),
                      // Padding(padding: EdgeInsets.only(bottom: 15)),
                      buildSecNo(context, 400),
                    ],
                  );
                }
              },
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),

            SizedBox(
              width: 400,
              child: TextFormField(
                controller: Address,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return ("Please fill the Address name corectly.");
                  }
                  if (value.length < 3) {
                    return ("Address name should have at least 3 letters");
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Address",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),

            // button
            ElevatedButton(
              onPressed: _isSaving ? null : payment,
              child: _isSaving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'PAYMENT',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fillNearestName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Center(child: Text("GameNova", style: TextStyle(fontSize: 30))),
      ),
      body: Center(child: SingleChildScrollView(child: _buildForm(context))),
    );
  }
}
