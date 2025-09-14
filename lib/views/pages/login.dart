// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mad_1_gamenova_1/views/pages/main_nav.dart';
import 'package:mad_1_gamenova_1/views/pages/register.dart';
import 'package:social_media_buttons/social_media_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UsernameCnt = TextEditingController();
  final PassCnt = TextEditingController();
  final formkey = GlobalKey<FormState>();

  String? error;

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
          // username
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: UsernameCnt,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ("Please fill the username corectly.");
                }
                // if (value.length < 6) {
                //   return ("Username should have at least 6 letters");
                // }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),

          // password
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: PassCnt,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ("Please fill the password corectly.");
                }
                // if (value.length < 8) {
                //   return ("Password should have at least 8 letters");
                // }
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
          ElevatedButton(
            onPressed: () {
              if (formkey.currentState!.validate()) {
                if (UsernameCnt.text == "123" && PassCnt.text == "123") {
                  setState(() {
                    error = null;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainNavScreen(selectPageIndex: 0),
                    ),
                  );
                } else {
                  setState(() {
                    error = "Invalid Username or Password. Please Try Again!";
                  });
                }
              }
            },
            child: Text(
              'LOG IN',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
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
