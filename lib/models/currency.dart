class Currency {
  Currency({
    this.code,
    this.letters,
    this.name,
    this.shortName,
    this.rate,
  });

  int? code;
  String? letters;
  String? name;
  String? shortName;
  double? rate; // USA dollar rate
}
