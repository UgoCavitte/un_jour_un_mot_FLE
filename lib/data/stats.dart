import 'package:un_jour_un_mot/data/data.dart';

abstract class Stats {
  static int nbrMotsDevines = Data.listeMotsUser.values.where((t) => t == true).length;
  static int nbrMotsEssayes = Data.listeMotsUser.length;

  static int get ratio =>
      nbrMotsEssayes == 0 ? 0 : (nbrMotsDevines / nbrMotsEssayes * 100).round();
}
