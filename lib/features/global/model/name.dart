class Name {
  String? tk;
  String? en;
  String? ru;

  Name({this.tk, this.en, this.ru});

  factory Name.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return Name(tk: json["tk"], en: json["en"], ru: json["ru"]);
    }
    if (json is String) {
      return Name(tk: json);
    }
    return Name();
  }

  Map<String, dynamic> toJson() {
    return {"tk": tk, "en": en, "ru": ru};
  }
}
