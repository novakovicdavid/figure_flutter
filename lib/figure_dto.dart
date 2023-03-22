class FigureDTO {
  FigureDTO({
    required this.id,
    required this.title,
    required this.description,
    required this.width,
    required this.height,
    required this.url,
  });

  int id;
  String title;
  String? description;
  int width;
  int height;
  String url;

  factory FigureDTO.fromJson(Map<String, dynamic> json) => FigureDTO(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      width: json["width"],
      height: json["height"],
      url: json["url"]);
}
