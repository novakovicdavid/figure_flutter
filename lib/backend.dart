import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:figure_flutter/profile_dto.dart';
import 'package:http/http.dart' as http;

import 'package:figure_flutter/figure_dto.dart';

var httpclient = HttpClient();
String backend = "backend.figure.novakovic.be";
String scheme = "https";

Future<List<FigureDTO>> getFigures(int afterId, int? profileId) async {
  var connection = profileId == null
      ? await http.get(Uri.parse("$scheme://$backend/figures/browse/$afterId"))
      : await http.get(
          Uri.parse("$scheme://$backend/profile/$profileId/browse/$afterId"));
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
      ? await http.get(Uri.parse("$scheme://$backend/figures/browse"))
      : await http
          .get(Uri.parse("$scheme://$backend/profile/$profileId/browse"));
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
  var connection = await http.get(Uri.parse("$scheme://$backend/figures/$id"));
  var parsedResponseBody = jsonDecode(connection.body);
  if (parsedResponseBody["figure"] != null) {
    return FigureDTO.fromJson(parsedResponseBody["figure"]);
  } else {
    return null;
  }
}

login(data) async {
  return createSession(data, "users/signin");
}

signup(data) async {
  return createSession(data, "users/signup");
}

createSession(data, endpoint) async {
  var json = jsonEncode(data);
  var connection =
      await httpclient.postUrl(Uri.parse("$scheme://$backend/$endpoint"));
  connection.headers.add("content-type", "application/json");
  connection.headers.contentLength = json.length;
  connection.write(json);
  var response = await connection.close();
  var jsonString = await readResponse(response);
  var parsedResponseBody = jsonDecode(jsonString);
  if (parsedResponseBody["profile"] != null) {
    var sessionToken = response.headers.value("Set-Cookie")!.split("; ")[0];
    sessionToken = sessionToken.split("=")[1];
    var sessionProfile = ProfileDTO.fromJson(parsedResponseBody["profile"]);
    return {"sessionToken": sessionToken, "sessionProfile": sessionProfile};
  } else {
    return null;
  }
}
