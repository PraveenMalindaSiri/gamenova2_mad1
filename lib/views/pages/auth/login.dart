// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/service/user_service.dart';
import 'package:gamenova2_mad1/views/pages/auth/register.dart';
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
      final user = await UserService.login(EmailCnt.text, PassCnt.text);
      print(user.token);
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      //
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
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 30)),

          // password
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: PassCnt,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ("Please fill the password corectly.");
                }
                return null;
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
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
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (!formkey.currentState!.validate()) return;
                      setState(() => _isLoading = true);
                      try {
                        await _login();
                        if (!mounted) return;
                      } finally {
                        if (mounted) setState(() => _isLoading = false);
                      }
                    },
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

          Padding(padding: EdgeInsets.only(bottom: 10)),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildHeader(400),
                      _buildForm(context),
                      _buildFooter(),
                    ],
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
