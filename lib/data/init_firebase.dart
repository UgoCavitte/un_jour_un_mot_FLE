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

    var retrieved = await dataBase.collection(DbConsts.idListeMotsNouveaux).get();

    Data.listeMots.clear();

    for (var element in retrieved.docs) {
      MotNouveau toAdd = MotNouveau(
          id: element[DbConsts.idId] ?? -1,
          mot: element[DbConsts.idMot] ?? "erreur",
          definition: element[DbConsts.idDef] ?? "erreur",
          traductions: Map.from(
                (element[DbConsts.idTraductions] ?? {"EN": "Défaut", "RU": "Défaut"}) as Map<String, dynamic>,
              ).cast<String, String>(),
          date: Dates.fromStringToDate(element[DbConsts.idOldDate]));

      Data.listeMots.add(toAdd);

      // TODO Add an error if a word has a -1 id or "erreur" somewhere
      if (toAdd.id == -1 || toAdd.mot == "erreur" || toAdd.definition == "erreur" || toAdd.traductions == {"EN": "Défaut", "RU": "Défaut"}) {
        debugPrintStack(label: "[app] Null field while loading words");
      }
    }

    // Les trie par date
    Data.listeMots.sort((a, b) => a.id.compareTo(b.id),);
    
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
      (key, value) => MapEntry(key.toString(), value),
    );

    // Envoi
    await InitFirebase.dataBase
        .collection(DbConsts.idUsers)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({DbConsts.idMotsNFaits: toSend});
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

    final data = retrieved.data();

    // Vérifie que ses données ont été mises à jour
    if (data != null && !data.containsKey(DbConsts.idMotsNFaits)) {
    
      debugPrintStack(label: "[app] Trying to update data for user: ${FirebaseAuth.instance.currentUser!.uid}");

      Map<String, bool> nm = {};
      Map<String, bool> om = (retrieved[DbConsts.idMotsFaits] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as bool),);

      for (var element in om.entries) {
        nm.putIfAbsent(
          Data.listeMots.singleWhere((t) => element.key == Dates.fromDateToString(t.date)).id.toString(),
          () => element.value);
      }

      await dataBase.collection(DbConsts.idUsers).doc(FirebaseAuth.instance.currentUser!.uid).update({
        DbConsts.idCurrentUser: FirebaseAuth.instance.currentUser!.uid,
        DbConsts.idMotsNFaits: nm,
        DbConsts.idPremium: Data.isPremium,
        DbConsts.idLastDate: Dates.fromDateToString(Data.lastDate)
      });

      retrieved = await InitFirebase.dataBase
            .collection(DbConsts.idUsers)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    }

    // Reformate les String en dates
    Data.listeMotsUser = (retrieved[DbConsts.idMotsNFaits] as Map<String, dynamic>).map((key, value) => MapEntry(int.parse(key), value as bool));

    // Met à jour le statut de chaque mot selon cette liste
    for (var mot in Data.listeMots) {
      if (Data.listeMotsUser[mot.id] != null) {
        mot.fait =
            Data.listeMotsUser[mot.id]! ? MotStatut.reussi : MotStatut.rate;
      } else {
        mot.fait = MotStatut.pasOuvert;
      }
    }

    // Last Date
    // Skip if equals to 1977
    if (!(retrieved[DbConsts.idLastDate] as String == Dates.fromDateToString(DateTime(1977)))) {
      Data.lastDate = Dates.fromStringSlashToDate(retrieved[DbConsts.idLastDate] as String);
    }

    Mot.setFirstAvailableID();

    // S'occupe des stats
    Stats.nbrMotsEssayes = Data.listeMotsUser.length;
    Stats.nbrMotsDevines = 0;
    for (var motFait in Data.listeMotsUser.values) {
      if (motFait) Stats.nbrMotsDevines++;
    }

    return;
  }

  static Future<void> updateLastDate () {
    String newDate = Dates.fromDateToString(DateTime.now());

    dataBase.collection(DbConsts.idUsers).doc(FirebaseAuth.instance.currentUser!.uid).update({
        DbConsts.idCurrentUser: FirebaseAuth.instance.currentUser!.uid,
        DbConsts.idMotsNFaits: Data.listeMotsUser.map((k, v) => MapEntry(k.toString(), v)),
        DbConsts.idPremium: Data.isPremium,
        DbConsts.idLastDate: newDate
      });

      return Future(() {});
  }
}
