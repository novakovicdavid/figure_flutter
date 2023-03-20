import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrowsePage extends StatelessWidget {
  const BrowsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BrowseWidget(),
    );
  }
}

class BrowseWidget extends StatefulWidget {
  const BrowseWidget({super.key});

  @override
  State<StatefulWidget> createState() => BrowseState();

}

class BrowseState extends State<BrowseWidget> {
  @override
  Widget build(BuildContext context) {
    return (
    Image.asset("assets/images/welcome_screen.png")
    );
  }

}