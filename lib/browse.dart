import 'package:figure_flutter/backend.dart';
import 'package:figure_flutter/infinity_scroll.dart';
import 'package:flutter/cupertino.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});


  @override
  State<StatefulWidget> createState() => BrowsePageState();

}

class BrowsePageState extends State<BrowsePage> {


  @override
  Widget build(BuildContext context) {
    return (
        FutureBuilder(
          future: getFirstFigures(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) return Container();
            var figures = snapshot.data ?? [];
            if (figures.isEmpty) return Container();
            return (
              FigureListView(firstFigures: figures)
            );
          })
    );
  }

}