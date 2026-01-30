/*
 * Cet élément a plusieurs paramètres à récupérer de la base de données :
 * - date
 * - le mot en lui-même
 * - définition / traduction
 * 
 * Il en a d'autres qu'il gère lui-même :
 * - réussi ou pas
 */

/*
 * Suppression des exemples
 * Raison : chronophage et peu rentable
 */

import 'package:un_jour_un_mot/data/data.dart';

enum MotStatut { pasOuvert, reussi, rate }

abstract class Mot {
  final DateTime date; // jour, mois, année seulement
  final String mot;
  final String definition;
  // final List<String> exemple;
  final Map<String, String> traductions;
  MotStatut fait = MotStatut.pasOuvert;

  Mot({
    required this.date,
    required this.mot,
    required this.definition,
    // required this.exemple,
    required this.traductions,
  });

  static void setFirstAvailableID() {
    Data.firstAvailableID = -2;
    for (int i = 0; i < Data.listeMots.length; i++) {
      if (!Data.listeMotsUser.containsKey(i)) {
        Data.firstAvailableID = i;
        break;
      }
    }
  }
}

class MotNouveau extends Mot {
  final int id; // remplace la date

  MotNouveau({required this.id, required super.mot, required super.definition, required super.traductions, required super.date});
}
