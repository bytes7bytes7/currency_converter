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

  String getFlag() {
    final int firstLetter = letters!.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = letters!.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}
