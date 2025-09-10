abstract class Lettres {
  static final List<String> listeLettresPourRemplacer = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "é",
    "è",
    "ê",
    "f",
    "g",
    "h",
    "i",
    "î",
    "j",
    "l",
    "m",
    "n",
    "o",
    "ô",
    "p",
    "r",
    "s",
    "t",
    "u",
    "û",
    "v",
  ];

  static String enleverDiacritique(String string) {
    switch (string) {
      case "à" || "â":
        return "a";
      case "é" || "è" || "ê" || "ë":
        return "e";
      case "û" || "ü" || "ù":
        return "u";
      case "î" || "ï":
        return "i";
      case "ô" || "ö":
        return "o";
      case "ç":
        return "c";
      default:
        return string;
    }
  }

  static bool isItAVowel(String string) {
    string.toLowerCase();
    string = Lettres.enleverDiacritique(string);

    if (["a", "e", "i", "o", "u", "y"].contains(string)) {
      return true;
    }
    return false;
  }
}
