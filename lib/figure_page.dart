import 'package:cached_network_image/cached_network_image.dart';
import 'package:figure_flutter/backend.dart';
import 'package:figure_flutter/browse.dart';
import 'package:flutter/material.dart';

class FigurePage extends StatelessWidget {
  final int id;

  const FigurePage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return (SafeArea(
        child: Scaffold(
      body: FutureBuilder(
        future: getFigure(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              snapshot.data == null) {
            return Container();
          }
          var figure = snapshot.data!;
          return (Column(children: [
            CachedNetworkImage(
              imageUrl: figure.url,
              placeholder: (context, url) => AspectRatio(
                  aspectRatio: figure.width / figure.height,
                  child: const Center(
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator()))),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Text(figure.title),
            Text(figure.description ?? ""),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                              body: BrowsePage(
                                  profileId: figure.profileDTO!.id))));
                },
                child: Text(figure.profileDTO!.username))
          ]));
        },
      ),
    )));
  }
}
