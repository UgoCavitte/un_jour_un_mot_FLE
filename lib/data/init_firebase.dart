import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:un_jour_un_mot/data/data.dart';
import 'package:un_jour_un_mot/data/db_consts.dart';
import 'package:un_jour_un_mot/data/stats.dart';
import 'package:un_jour_un_mot/misc/dates.dart';
import 'package:un_jour_un_mot/objects/mot.dart';

abstract class InitFirebase {
  static final FirebaseFirestore dataBase = FirebaseFirestore.instance;

  // Récupère les mots depuis la base de données
  static Future<void> getMots() async {
    QuerySnapshot<Map<String, dynamic>> retrieved =
        await dataBase.collection(DbConsts.idListeMots).get();

    // Réinitialise la liste des mots au cas où elle n'était pas vide
    Data.listeMots.clear();

    // Regarde tous les mots de la base de données
    for (var element in retrieved.docs) {
      Data.listeMots.add(
        Mot(
          date: Dates.fromStringToDate(element.id), // l'id est la date
          mot: element[DbConsts.idMot] ?? "Défaut",
          definition: element[DbConsts.idDef] ?? "Défaut",
          traductions:
              Map.from(
                (element[DbConsts.idTraductions] ?? {"EN": "Défaut", "RU": "Défaut"}) as Map<String, dynamic>,
              ).cast<String, String>(),
        ),
      );
    }

    // Les trie par date
    Data.listeMots.sort((a, b) {
      switch (Dates.comparerDates(dateRef: a.date, dateChecked: b.date)) {
        case ComparaisonDates.anterieur:
          return 1;
        case ComparaisonDates.egal:
          return 0;
        case ComparaisonDates.ulterieur:
          return -1;
      }
    });
  }

  // Inscrit le statut premium
  static Future<void> setPrem(bool statut) async {
    await dataBase
        .collection(DbConsts.idUsers)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({DbConsts.idPremium: statut});
  }

  // Inscription des mots faits par l'utilisateur
  // L'appli récupère les mots faits par l'utilisateur à chaque ouverture
  // On ajoute le nouveau mot fait et on envoie la Map mise à jour à la base de
  // données
  static Future<void> enregistrerMotsFaits() async {
    // On commence par vérifier que l'utilisateur est connecté et existe
    if (FirebaseAuth.instance.currentUser == null) {
      debugPrintStack(
        label: "[app] User is not connected or Google SignIn account is null",
      );
      return;
    }

    // S'il est connecté, on vérifie qu'il a un fichier
    await doesUserExists();

    Map<String, bool> toSend = Data.listeMotsUser.map(
      (key, value) => MapEntry(Dates.fromDateToString(key), value),
    );

    // Envoi
    await InitFirebase.dataBase
        .collection(DbConsts.idUsers)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({DbConsts.idMotsFaits: toSend});
  }

  // Vérification que l'utilisateur existe, sinon création de son fichier
  static Future<void> doesUserExists() async {
    QuerySnapshot<Map<String, dynamic>> retrieved =
        await InitFirebase.dataBase.collection(DbConsts.idUsers).get();

    // Vérifie si l'utilisateur est dedans ou pas
    if (FirebaseAuth.instance.currentUser != null) {
      bool existe = retrieved.docs
          .map((element) => element.id)
          .contains(FirebaseAuth.instance.currentUser!.uid);

      // L'utilisateur existe
      if (existe) {
        return;
      }

      // L'utilisateur n'existe pas
      await InitFirebase.dataBase
          .collection(DbConsts.idUsers)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
            DbConsts.idCurrentUser: FirebaseAuth.instance.currentUser!.uid,
            DbConsts.idPremium: false,
            DbConsts.idMotsFaits: <String, bool>{},
          });
    }
    // Le compte Google est null
    else {
      debugPrintStack(
        label:
            "[app] The Google SignIn account is null, it is impossible to read or write current user's data.",
      );
    }
  }

  // Récupère toutes les données sur l'utilisateur : premium et liste
  static Future<void> getUserData() async {
    // On commence par vérifier que l'utilisateur est connecté et existe
    if (FirebaseAuth.instance.currentUser == null) {
      debugPrintStack(
        label: "[app] User is not connected or Google SignIn account is null",
      );
      return Future.value();
    }

    // S'il est connecté, on vérifie qu'il a un fichier
    await doesUserExists();

    // Récupère les données de l'utilisateur
    DocumentSnapshot<Map<String, dynamic>> retrieved =
        await InitFirebase.dataBase
            .collection(DbConsts.idUsers)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    // Statut premium
    Data.isPremium = retrieved[DbConsts.idPremium];

    // Reformate les String en dates
    Data.listeMotsUser =
        (retrieved[DbConsts.idMotsFaits] as Map<String, dynamic>).map(
          (key, value) =>
              MapEntry(Dates.fromStringSlashToDate(key), value as bool),
        );

    // Met à jour le statut de chaque mot selon cette liste
    for (var mot in Data.listeMots) {
      if (Data.listeMotsUser[mot.date] != null) {
        mot.fait =
            Data.listeMotsUser[mot.date]! ? MotStatut.reussi : MotStatut.rate;
      } else {
        mot.fait = MotStatut.pasOuvert;
      }
    }

    // S'occupe des stats
    Stats.nbrMotsEssayes = Data.listeMotsUser.length;
    Stats.nbrMotsDevines = 0;
    for (var motFait in Data.listeMotsUser.values) {
      if (motFait) Stats.nbrMotsDevines++;
    }

    return;
  }
}
