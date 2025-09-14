// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/user.dart';
import 'package:gamenova2_mad1/core/service/user_service.dart';
import 'package:gamenova2_mad1/views/pages/auth/login.dart';
import 'package:gamenova2_mad1/views/widgets/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final NameCnt = TextEditingController();
  final EmailCnt = TextEditingController();
  final AgeCnt = TextEditingController();
  final PassCnt = TextEditingController();
  final ConfPassCnt = TextEditingController();

  final List<String> roles = ["Customer", "Seller"];
  String? SelcRole = "Customer";

  final formkey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? error;

  Future<void> _register() async {
    if (!formkey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final role = (SelcRole ?? 'Customer').toLowerCase();

      final data = {
        "name": NameCnt.text.trim(),
        "email": EmailCnt.text.trim(),
        "role": role,
        "password": PassCnt.text.trim(),
        "password_confirmation": ConfPassCnt.text.trim(),
        if (AgeCnt.text.trim().isNotEmpty) "dob": AgeCnt.text.trim(),
      };

      final user = await UserService.register(data: data);
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      //
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget buildAge(context, double width) {
    return SizedBox(
      width: width,
      child: MyTextField(
        context,
        AgeCnt,
        "Date of Birth",
        prefixIcon: Icons.calendar_month,
        readOnly: true,
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime(now.year - 18, now.month, now.day),
            firstDate: DateTime(1900),
            lastDate: DateTime(now.year, now.month, now.day),
          );
          if (picked != null) {
            AgeCnt.text = picked.toIso8601String().split('T').first;
          }
        },
        validator: (value) => UserValidations.validDob(value),
      ),
    );
  }

  Widget buildRole(context, double width) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        value: SelcRole,
        items: roles
            .map((role) => DropdownMenuItem(value: role, child: Text(role)))
            .toList(),
        onChanged: (value) => setState(() => SelcRole = value),
        validator: (value) => value == null ? "Please select a Role" : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: "Select Role",
          labelText: "Select Role",
        ),
      ),
    );
  }

  Widget _buildForm(context) {
    final isCustomer = (SelcRole ?? '').toLowerCase() == 'customer';

    return Form(
      key: formkey,
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(bottom: 30)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: [
                // fullname
                MyTextField(
                  prefixIcon: Icons.title,
                  context,
                  NameCnt,
                  "Full Name",
                  validator: (value) => UserValidations.validName(value),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),

                // email
                MyTextField(
                  prefixIcon: Icons.email,
                  context,
                  EmailCnt,
                  "Email",
                  validator: (value) => UserValidations.validEmail(value),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),

                // password
                MyTextField(
                  prefixIcon: Icons.password,
                  context,
                  PassCnt,
                  "Password",
                  obscure: true,
                  validator: (value) => UserValidations.validPassword(value),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),

                // conf pass
                MyTextField(
                  prefixIcon: Icons.password,
                  context,
                  ConfPassCnt,
                  "Confirm Password",
                  obscure: true,
                  validator: (value) =>
                      UserValidations.validConfirmPassword(value, PassCnt.text),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
              ],
            ),
          ),

          // role and age builder
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRole(
                      context,
                      MediaQuery.of(context).size.width * 0.35,
                    ),
                    SizedBox(width: 20),
                    if (isCustomer)
                      buildAge(
                        context,
                        MediaQuery.of(context).size.width * 0.35,
                      ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    SizedBox(height: 7),
                    buildRole(context, MediaQuery.of(context).size.width * 0.7),
                    Padding(padding: EdgeInsets.only(bottom: 15)),
                    if (isCustomer)
                      buildAge(
                        context,
                        MediaQuery.of(context).size.width * 0.7,
                      ),
                  ],
                );
              }
            },
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),

          // button
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () {
                    if (formkey.currentState!.validate()) {
                      _register();
                    }
                  },
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'REGISTER',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
          ),
          SizedBox(height: 20),

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text('Log in'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(children: [_buildForm(context)]),
        ),
      ),
    );
  }
}
