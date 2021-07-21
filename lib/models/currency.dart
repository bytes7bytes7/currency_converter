class Currency {
  Currency({
    this.iso,
    this.name,
    this.country,
    this.rate,
  });

  String? iso;
  String? name;
  String? country;
  double? rate; // USA dollar rate

  String getFlag() {
    final int firstLetter = iso!.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = iso!.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}
