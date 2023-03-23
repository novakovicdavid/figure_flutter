class ProfileDTO {
  int id;
  String username;
  String? displayName;

  ProfileDTO({required this.id, required this.username, this.displayName});

  factory ProfileDTO.fromJson(Map<String, dynamic> json) => ProfileDTO(
      id: json["id"],
      username: json["username"],
      displayName: json["display_name"]);

  toJson() {
    return {
      "id": id,
      "username": username,
      "display_name": displayName
    };
  }
}
