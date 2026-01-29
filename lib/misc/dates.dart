import 'package:un_jour_un_mot/objects/mot.dart';

enum ComparaisonDates { anterieur, egal, ulterieur }

enum PartiesDate { annee, mois, jour }

abstract class Dates {
  // Optimiser en transformer le String en int et en faisant une comparaison classique
  static ComparaisonDates comparerDates({
    required DateTime dateRef,
    required DateTime dateChecked,
  }) {
    if (dateRef.year < dateChecked.year) {
      return ComparaisonDates.ulterieur;
    }
    if (dateRef.year > dateChecked.year) {
      return ComparaisonDates.anterieur;
    }

    // Si les années sont égales, on regarde les mois
    if (dateRef.month < dateChecked.month) {
      return ComparaisonDates.ulterieur;
    }
    if (dateRef.month > dateChecked.month) {
      return ComparaisonDates.anterieur;
    }

    // Si les mois aussi sont égaux, alors on regarde les jours
    if (dateRef.day < dateChecked.day) {
      return ComparaisonDates.ulterieur;
    }
    if (dateRef.day > dateChecked.day) {
      return ComparaisonDates.anterieur;
    }

    return ComparaisonDates.egal;
  }

  static String formaterDatePourAffichage(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static DateTime fromStringSlashToDate(String string) {
    List<String> divided = string.split("");

    List<String> year = [];
    List<String> month = [];
    List<String> day = [];

    PartiesDate partiesDate = PartiesDate.annee;

    for (int i = 0; i < divided.length; i++) {
      // On change de partie si on tombe sur un slash
      if (divided[i] == '/') {
        if (partiesDate == PartiesDate.annee) {
          partiesDate = PartiesDate.mois;
        } else if (partiesDate == PartiesDate.mois) {
          partiesDate = PartiesDate.jour;
        }
      }
      // Si c'était pas un slash, on complète
      else {
        switch (partiesDate) {
          case PartiesDate.annee:
            year.add(divided[i]);
            break;
          case PartiesDate.mois:
            month.add(divided[i]);
            break;
          case PartiesDate.jour:
            day.add(divided[i]);
            break;
        }
      }
    }

    return DateTime(
      int.parse(year.join()),
      int.parse(month.join()),
      int.parse(day.join()),
    );
  }

  // Dates with slashes and no zeroes
  static DateTime fromStringToDate(String string) {
    List<String> divided = string.split("");

    List<String> year = [];
    List<String> month = [];
    List<String> day = [];

    // year
    while (divided.first != "/") {
      year.add(divided.first);
      divided.removeAt(0);
    }
    divided.removeAt(0);

    // month
    while (divided.first != "/") {
      month.add(divided.first);
      divided.removeAt(0);
    }
    divided.removeAt(0);

    // day
    while (divided.isNotEmpty) {
      day.add(divided.first);
      divided.removeAt(0);
    }


    return DateTime(
      int.parse(year.join()),
      int.parse(month.join()),
      int.parse(day.join()),
    );
  }

  // Year/month/day
  static String fromDateToString(DateTime date) {
    return "${date.year}/${date.month}/${date.day}";
  }
}
