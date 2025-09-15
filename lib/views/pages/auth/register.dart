// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/user.dart';
import 'package:gamenova2_mad1/core/service/user_service.dart';
import 'package:gamenova2_mad1/views/pages/auth/login.dart';
import 'package:gamenova2_mad1/views/widgets/dialog_helper.dart';
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
    final role = (SelcRole ?? 'Customer').toLowerCase();

    if (role == 'customer' && AgeCnt.text.trim().isEmpty) {
      setState(() => _isLoading = false);
      await showNoticeDialog(
        context: context,
        title: 'Date of Birth required',
        message: 'Please select your date of birth to continue.',
        type: NoticeType.warning,
      );
      return;
    }

    try {
      final data = {
        "name": NameCnt.text.trim(),
        "email": EmailCnt.text.trim(),
        "role": role,
        "password": PassCnt.text.trim(),
        "password_confirmation": ConfPassCnt.text.trim(),
      };
      final dobText = AgeCnt.text.trim();
      if (dobText.isNotEmpty) {
        data["dob"] = dobText;
      }

      final user = await UserService.register(data: data);
      if (!mounted) return;
      if (user.token == null || user.token!.isEmpty) {
        await showNoticeDialog(
          context: context,
          title: 'Registration failed',
          message: 'Try Again',
          type: NoticeType.error,
        );
        return;
      }

      await showNoticeDialog(
        context: context,
        title: 'Registered!',
        message: 'Your account is ready. Please log in.',
        type: NoticeType.success,
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
      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Registration failed',
        message: "Something went wrong",
        type: NoticeType.error,
      );
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
        onChanged: (value) {
          setState(() {
            SelcRole = value;
            if ((value ?? '').toLowerCase() == 'seller') {
              AgeCnt.clear();
            }
          });
        },
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
    final role = SelcRole;
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
                Text("Register as a $role"),
                Padding(padding: EdgeInsets.only(bottom: 10)),

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
                      MediaQuery.of(context).size.width * 0.34,
                    ),
                    SizedBox(width: 20),
                    if (isCustomer)
                      buildAge(
                        context,
                        MediaQuery.of(context).size.width * 0.34,
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
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.5,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _register,
              icon: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.login),
              label: const Text(
                'REGISTER',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                minimumSize: const Size.fromHeight(48),
              ),
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
  void dispose() {
    NameCnt.dispose();
    EmailCnt.dispose();
    AgeCnt.dispose();
    PassCnt.dispose();
    ConfPassCnt.dispose();
    super.dispose();
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
