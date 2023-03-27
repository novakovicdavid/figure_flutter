import 'package:animations/animations.dart';
import 'package:figure_flutter/signin.dart';
import 'package:figure_flutter/signup.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final Tween<double> _tweenSize;
  late final AnimationController _animationController;
  late final Animation<double> _animationSize;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _tweenSize = Tween<double>(begin: 0.1, end: 60.0);
    _animationSize = _tweenSize.animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        child: Text(
                            style: TextStyle(fontSize: _animationSize.value),
                            "Welcome to Figure."))))),
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
