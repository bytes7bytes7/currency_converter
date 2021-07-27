class Setting {
  Setting({
    this.title,
    this.subtitle,
    this.value,
    this.icon,
    this.description = '',
    this.options = const <String>[],
  });

  String? title;
  String? subtitle;
  String? value;
  String? icon;
  late String description;
  late List<String> options;

  Setting.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    subtitle = map['subtitle'];
    value = map['value'];
    icon = map['icon'];
    description = map['description'];
    options = map['options'].split(';').toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'value': value,
      'icon': icon,
      'description': description,
      'options': options,
    };
  }
}
