import 'package:figure_flutter/backend.dart';
import 'package:figure_flutter/infinity_scroll.dart';
import 'package:flutter/cupertino.dart';

class BrowsePage extends StatelessWidget {
  final int? profileId;
  const BrowsePage({this.profileId, super.key});

  @override
  Widget build(BuildContext context) {
    return (
        FutureBuilder(
            future: getFirstFigures(profileId),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) return Container();
              var figures = snapshot.data!;
              if (figures.isEmpty) return Container();
              return (
                  FigureListView(firstFigures: figures, profileId: profileId)
              );
            })
    );
  }
}