class Setting {
  Setting({
    this.title,
    this.subtitle,
    this.value,
    this.icon,
  });

  String? title;
  String? subtitle;
  String? value;
  String? icon;

  Setting.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    subtitle = map['subtitle'];
    value = map['value'];
    icon = map['icon'];
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'value': value,
      'icon': icon,
    };
  }
}
