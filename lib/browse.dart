import 'package:figure_flutter/backend.dart';
import 'package:figure_flutter/figure_dto.dart';
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
    print("hellooo");
    return (
        FutureBuilder(
          initialData: [FigureDTO(id: 0, title: "title", description: "description", width: 4, height: 4, url: "https://www.google.com/images/branding/googlelogo/1x/googlelogo_light_color_272x92dp.png")],
          future: getFirstFigures(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) return Container();
            var figures = snapshot.data ?? [];
            if (figures.isEmpty) return Container();
            print(figures[0].title);
            return (
              FigureListView(firstFigures: figures)
            );
          })
    );
  }

}