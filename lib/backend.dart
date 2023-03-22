import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:figure_flutter/figure_dto.dart';

var httpclient = HttpClient();

Future<List<FigureDTO>> getFigures(int afterId) async {
  var connection = await httpclient.getUrl(
      Uri.parse("https://backend.figure.novakovic.be/figures/browse/$afterId"));
  var response = await connection.close();
  var parsedResponseBody = jsonDecode(await readResponse(response));
  if (parsedResponseBody["figures"] != null) {
    List<FigureDTO> figures = [];
    for (var figure in parsedResponseBody["figures"]) {
      figures.add(FigureDTO.fromJson(figure));
    }
    return figures;
  } else {
    return <FigureDTO>[];
  }
}

Future<List<FigureDTO>> getFirstFigures() async {
  var connection = await httpclient
      .getUrl(Uri.parse("https://backend.figure.novakovic.be/figures/browse"));
  var response = await connection.close();
  var parsedResponseBody = jsonDecode(await readResponse(response));
  if (parsedResponseBody["figures"] != null) {
    List<FigureDTO> figures = [];
    for (var figure in parsedResponseBody["figures"]) {
      figures.add(FigureDTO.fromJson(figure));
    }
    return figures;
  } else {
    return <FigureDTO>[];
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

Future<FigureDTO?> getFigure(int id) async {
  var connection = await httpclient.getUrl(
      Uri.parse("https://backend.figure.novakovic.be/figures/$id"));
  var response = await connection.close();
  var parsedResponseBody = jsonDecode(await readResponse(response));
  if (parsedResponseBody["figure"] != null) {
    return FigureDTO.fromJson(parsedResponseBody["figure"]);
  }
  else {
    return null;
  }
}
