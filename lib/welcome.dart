import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return (Column(
      children: [
        Expanded(
            flex: 7,
            child: Center(
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                        margin: const EdgeInsets.only(left: 40, right: 40),
                        child: Text(
                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(fontSizeFactor: 3.0),
                            "Welcome to Figure."))))),
        Expanded(
            flex: 3,
            child: Column(children: [
              FilledButton(onPressed: () {}, child: const Text("Sign Up")),
              Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: FilledButton(
                      onPressed: () {}, child: const Text("Login"))),
            ]))
      ],
    ));
  }
}
