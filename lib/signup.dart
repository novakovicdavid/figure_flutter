import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:figure_flutter/browse.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<StatefulWidget> createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  static RegExp emailRegex = RegExp(
      "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,}");
  static RegExp usernameRegex = RegExp("^[a-zA-Z0-9]+-*[a-zA-Z0-9]+?");
  var usernameValidator = (String? username) {
    if (username == null || username.isEmpty) return 'Please enter a username';
    if (username.length < 3)
      return 'Username must be at least 3 characters long';
    if (!usernameRegex.hasMatch(username))
      return "Username is not valid. Only the characters A-Z, a-z and '-' are accepted.";
    return null;
  };
  var emailValidator = (String? email) {
    if (email == null || !emailRegex.hasMatch(email))
      return "Please enter a valid email";
    return null;
  };
  var passwordValidator = (String? password) {
    if (password == null || password.length < 6)
      return "Password must be >= 6 characters long";
    return null;
  };

  late String username;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    var title = Text(
        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 3.0),
        "Join Figure.");

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
                  validator: (value) => usernameValidator(value),
                  onChanged: (value) => username = value,
                  decoration: const InputDecoration(
                    labelText: "Username"
                  ),
                ),
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
                          "username": username,
                          "email": email,
                          "password": password
                        };
                        var json = jsonEncode(data);
                        var connection = await httpclient.postUrl(Uri.parse(
                            "https://backend.figure.novakovic.be/users/signup"));
                        connection.headers
                            .add("content-type", "application/json");
                        connection.headers.contentLength = json.length;
                        connection.write(json);
                        var response = await connection.close();
                        var parsedResponseBody =
                        jsonDecode(await readResponse(response));
                        if (parsedResponseBody["profile"] != null) {
                          setState(() {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BrowsePage()),
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
    )));
  }
}

Future<String> readResponse(HttpClientResponse response) {
  final completer = Completer<String>();
  final contents = StringBuffer();
  response.transform(utf8.decoder).listen((data) {
    contents.write(data);
  }, onDone: () => completer.complete(contents.toString()));
  return completer.future;
}
