// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mad_1_gamenova_1/views/pages/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final UsernameCnt = TextEditingController();
  final NameCnt = TextEditingController();
  final EmailCnt = TextEditingController();
  final AgeCnt = TextEditingController();
  final PassCnt = TextEditingController();
  final List<String> roles = ["Customer", "Admin", "Seller"];
  String? SelcRole = "Customer";
  String? success;

  final formkey = GlobalKey<FormState>();

  Widget buildAge(context, double width) {
    return // age
    SizedBox(
      width: width,
      child: TextFormField(
        controller: AgeCnt,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return ("Enter the Age.");
          }

          final age = int.tryParse(value);

          if (age == null) {
            return ("Numbers only.");
          }
          if (age < 9) {
            return ("Enter 9 or above.");
          }

          return null;
        },
        decoration: InputDecoration(
          hintText: "Age",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildRole(context, double width) {
    return // role
    SizedBox(
      width: width,
      child: DropdownButtonFormField(
        value: "Customer", // default value
        items:
            roles.map((String role) {
              return DropdownMenuItem(value: role, child: Text(role));
            }).toList(),
        onChanged: (String? value) {
          setState(() {
            SelcRole = value!;
          });
        },
        validator: (value) {
          if (value == null) {
            return "Please select a Role";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Select Role",
          labelText: "Select Role",
        ),
      ),
    );
  }

  Widget _buildForm(context) {
    return Form(
      key: formkey,
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(bottom: 30)),

          // username
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: UsernameCnt,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ("Please fill the Username corectly.");
                }
                if (value.length < 6) {
                  return ("Username should have at least 6 letters");
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Username",
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
                  return ("Please fill the Password corectly.");
                }
                if (value.length < 8) {
                  return ("Password should have at least 8 letters");
                }
                return null;
              },
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),

          // fullname
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: NameCnt,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ("Please fill the Full Name corectly.");
                }
                if (value.length < 9) {
                  return ("Full Name should have at least 10 letters");
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Fullname",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),

          // email
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: EmailCnt,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ("Please fill the Email corectly.");
                }
                if (value.length < 9) {
                  return ("Email should have at least 10 letters");
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return "Please enter a valid email address.";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),

          // role and age builder
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildAge(context, 190),
                    SizedBox(width: 20),
                    buildRole(context, 190),
                  ],
                );
              } else {
                return Column(
                  children: [
                    buildAge(context, 400),
                    Padding(padding: EdgeInsets.only(bottom: 15)),
                    buildRole(context, 400),
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
                  success =
                      "'${NameCnt.text}' registered as '${UsernameCnt.text}' successfully and role is ${SelcRole!}";
                });
              }
            },
            child: Text(
              'REGISTER',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),

          if (success != null)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                success!,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text('Try Log in'),
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
