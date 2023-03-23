import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:figure_flutter/figure_dto.dart';

var httpclient = HttpClient();

Future<List<FigureDTO>> getFigures(int afterId, int? profileId) async {
  var connection = profileId == null
      ? await http.get(
      Uri.parse("https://backend.figure.novakovic.be/figures/browse/$afterId"))
      : await http.get(
      Uri.parse("https://backend.figure.novakovic.be/profile/$profileId/browse/$afterId"));
  var parsedResponseBody = jsonDecode(connection.body);
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

Future<List<FigureDTO>> getFirstFigures(int? profileId) async {
  var connection = profileId == null
      ? await http.get(
          Uri.parse("https://backend.figure.novakovic.be/figures/browse"))
      : await http.get(
          Uri.parse("https://backend.figure.novakovic.be/profile/$profileId/browse"));
  var parsedResponseBody = jsonDecode(connection.body);
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
  var connection = await http
      .get(Uri.parse("https://backend.figure.novakovic.be/figures/$id"));
  var parsedResponseBody = jsonDecode(connection.body);
  if (parsedResponseBody["figure"] != null) {
    return FigureDTO.fromJson(parsedResponseBody["figure"]);
  } else {
    return null;
  }
}
