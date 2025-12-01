class ProductAttribute {
  int id;
  String slug;
  String name;

  ProductAttribute({required this.id, required this.slug, required this.name});

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(id: (json["id"]), slug: json["slug"], name: json["name"]);
  }
}
