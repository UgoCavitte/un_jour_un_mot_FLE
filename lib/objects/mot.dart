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

enum MotStatut { pasOuvert, reussi, rate }

class Mot {
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
}
