import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'browse.dart';
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
    if (email == null || !emailRegex.hasMatch(email))
      return "Please enter a valid email";
    return null;
  };
  var passwordValidator = (String? password) {
    if (password == null || password.length < 6)
      return "Password must be >= 6 characters long";
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
                            var json = jsonEncode(data);
                            var connection = await httpclient.postUrl(Uri.parse(
                                "https://backend.figure.novakovic.be/users/signin"));
                            connection.headers
                                .add("content-type", "application/json");
                            connection.headers.contentLength = json.length;
                            connection.write(json);
                            var response = await connection.close();
                            var parsedResponseBody =
                            jsonDecode(await readResponse(response));
                            if (parsedResponseBody["profile"] != null) {
                              setState(() {
                                sessionToken = response.headers.value("Set-Cookie")!;
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
        ))
    );
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