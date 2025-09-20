// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/provider/auth_provider.dart';
  import 'package:gamenova2_mad1/views/pages/auth/register.dart';
import 'package:gamenova2_mad1/views/pages/main_nav.dart';
import 'package:gamenova2_mad1/views/widgets/dialog_helper.dart';
import 'package:provider/provider.dart';
import 'package:social_media_buttons/social_media_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final EmailCnt = TextEditingController();
  final PassCnt = TextEditingController();
  final formkey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? error;

  Future<void> _login() async {
    if (!formkey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthProvider>();
      await auth.login(EmailCnt.text.trim(), PassCnt.text);

      if (!mounted) return;
      if (!auth.isLoggedIn) {
        await showNoticeDialog(
          context: context,
          title: 'Login failed',
          message: 'Invalid email or password.',
          type: NoticeType.error,
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavScreen(selectPageIndex: 0)),
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
        title: 'Login failed',
        // message: e.toString(),
        type: NoticeType.error,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildHeader(double width) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Image.asset(
          "assets/images/main/login_img.png",
          fit: BoxFit.fill,
          width: width,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Learn about us more:  '),
        SocialMediaButton.instagram(
          url: 'https://www.instagram.com/',
          size: 30,
          color: const Color.fromARGB(255, 176, 39, 48),
        ),
        SocialMediaButton.facebook(
          url: 'https://www.facebook.com/',
          size: 30,
          color: Colors.blueAccent,
        ),
        SocialMediaButton.youtube(
          url: 'https://youtube.com',
          size: 30,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildForm(context) {
    return Form(
      key: formkey,
      child: Column(
        children: [
          // email
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: EmailCnt,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ("Please fill the email corectly.");
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 15)),

          // password
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: PassCnt,
              style: Theme.of(context).textTheme.bodyMedium,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ("Please fill the password corectly.");
                }
                return null;
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          Padding(padding: EdgeInsets.only(bottom: 10)),
          if (error != null)
            Text(
              error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),

          Padding(padding: EdgeInsets.only(bottom: 10)),
          SizedBox(
            width: 300,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _login,
              icon: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.login),
              label: const Text(
                'LOG IN',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),

          Padding(padding: EdgeInsets.only(bottom: 20)),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
            child: Text('Register now...'),
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                // landscape
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [_buildHeader(300), _buildFooter()],
                          ),
                          _buildForm(context),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                // portrait
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Welcome to GameNova.",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        _buildHeader(400),
                        SizedBox(height: 20),
                        _buildForm(context),
                        SizedBox(height: 20),
                        _buildFooter(),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
