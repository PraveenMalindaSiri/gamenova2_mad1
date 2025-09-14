// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final CardHolder = TextEditingController();
  final CardNo = TextEditingController();
  final ExpireDate = TextEditingController();
  final SecNo = TextEditingController();
  String? $success;

  final formkey = GlobalKey<FormState>();

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
            return ("Accept only 4 digits");
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
                    buildDate(context, 200),
                    SizedBox(width: 20),
                    buildSecNo(context, 180),
                  ],
                );
              } else {
                return Column(
                  children: [
                    buildDate(context, 400),
                    Padding(padding: EdgeInsets.only(bottom: 15)),
                    buildSecNo(context, 400),
                  ],
                );
              }
            },
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          // button
          ElevatedButton(
            onPressed: () {
              if (formkey.currentState!.validate()) {
                setState(() {
                  $success = "You purchased products correctly.";
                });
              }
            },
            child: Text(
              'PAYMENT',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),

          Padding(padding: EdgeInsets.only(bottom: 10)),
          if ($success != null)
            Text(
              $success!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
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
