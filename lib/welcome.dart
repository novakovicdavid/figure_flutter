import 'package:animations/animations.dart';
import 'package:figure_flutter/signin.dart';
import 'package:figure_flutter/signup.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var welcomeText = Text(
        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 3.0),
        "Welcome to Figure.");
    ContainerTransitionType containerTransitionType =
        ContainerTransitionType.fade;
    return (Column(
      children: [
        Expanded(
            flex: 7,
            child: Center(
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                        margin: const EdgeInsets.only(left: 40, right: 40),
                        child: welcomeText)))),
        Expanded(
            flex: 3,
            child: Column(children: [
              OpenContainer(
                transitionType: containerTransitionType,
                transitionDuration: const Duration(milliseconds: 500),
                openBuilder: (context, _) => const SignupForm(),
                closedElevation: 0,
                closedColor: Colors.blue,
                closedBuilder: (context, _) => Container(
                  alignment: Alignment.center,
                  width: 100,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                      fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              OpenContainer(
                transitionType: containerTransitionType,
                transitionDuration: const Duration(milliseconds: 500),
                openBuilder: (context, _) => const SignInForm(),
                closedElevation: 0,
                closedColor: Colors.blue,
                closedBuilder: (context, _) => Container(
                  alignment: Alignment.center,
                  width: 100,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ]))
      ],
    ));
  }
}
