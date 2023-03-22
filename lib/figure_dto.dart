import 'package:figure_flutter/profile_dto.dart';

class FigureDTO {
  FigureDTO({
    required this.id,
    required this.title,
    required this.description,
    required this.width,
    required this.height,
    required this.url,
    this.profileDTO
  });

  int id;
  String title;
  String? description;
  int width;
  int height;
  String url;
  ProfileDTO? profileDTO;

  factory FigureDTO.fromJson(Map<String, dynamic> json) => FigureDTO(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      width: json["width"],
      height: json["height"],
      url: json["url"],
      profileDTO: ProfileDTO.fromJson(json["profile"]));
}
