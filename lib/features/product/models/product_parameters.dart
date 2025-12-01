class ProductParameter {
  int id;
  String slug;
  String name;
  String? attribute_count;

  ProductParameter({
    required this.id,
    required this.slug,
    required this.name,
    this.attribute_count,
  });

  factory ProductParameter.fromJson(Map<String, dynamic> json) {
    return ProductParameter(
      id: (json["id"]),
      slug: json["slug"],
      name: json["name"],
      attribute_count: json["attribute_count"],
    );
  }
  //
}
