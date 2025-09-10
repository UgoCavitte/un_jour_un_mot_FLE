abstract class Stats {
  static int nbrMotsDevines = 0;
  static int nbrMotsEssayes = 0;

  static int get ratio =>
      nbrMotsEssayes == 0 ? 0 : (nbrMotsDevines / nbrMotsEssayes * 100).round();
}
