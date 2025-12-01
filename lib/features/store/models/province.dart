class Province {
  int id;
  String name;
  String? slug;

  Province({required this.id, required this.name, this.slug});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(id: (json["id"]), name: json["name"], slug: json["slug"]);
  }
}
