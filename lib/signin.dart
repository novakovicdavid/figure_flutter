import 'dart:convert';

import 'package:figure_flutter/backend.dart';
import 'package:flutter/material.dart';

import 'mainpage.dart';
import 'main.dart';


class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<StatefulWidget> createState() => SignInFormState();

}

class SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  static RegExp emailRegex = RegExp(
      "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,}");
  var emailValidator = (String? email) {
    if (email == null || !emailRegex.hasMatch(email)) {
      return "Please enter a valid email";
    }
    return null;
  };
  var passwordValidator = (String? password) {
    if (password == null || password.length < 6) {
      return "Password must be >= 6 characters long";
    }
    return null;
  };
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    var title = Text(
        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 3.0),
        "Login.");
    return (Scaffold(body: Column(
          children: [
            Expanded(
                child: Center(
                    child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: title)))),
            Container(margin: const EdgeInsets.only(left: 30, right: 30, bottom: 60), child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) => emailValidator(value),
                      onChanged: (value) => email = value,
                      decoration: const InputDecoration(
                          labelText: "Email"
                      ),
                    ),
                    TextFormField(
                      validator: (value) => passwordValidator(value),
                      onChanged: (value) => password = value,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: "Password"
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var data = {
                              "email": email,
                              "password": password
                            };
                            var result = await login(data);
                            print('a');
                            if (result != null) {
                              print('b');
                              sessionToken = result["sessionToken"];
                              sessionProfile = result["sessionProfile"];
                              localStorage.setString(
                                  "session_token", sessionToken);
                              localStorage.setString(
                                  "profile", jsonEncode(sessionProfile));
                              setState(() {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainWidget()),
                                      (route) => false,
                                );
                              });
                            }
                          }
                        },
                        child: const Text("Sign up"))
                  ],
                )))
          ],
        ))
    );
  }
}