import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:un_jour_un_mot/ads/ads.dart';
import 'package:un_jour_un_mot/data/gestion_memoire.dart';
import 'package:un_jour_un_mot/data/init_firebase.dart';
import 'package:un_jour_un_mot/global_providers/provider_connect.dart';
import 'package:un_jour_un_mot/main.dart';
import 'package:un_jour_un_mot/objects/mot.dart';

enum LoadingStatus { initialisation, tutoriel, rgpd, charge }

enum EtapeInitialisation {
  checkingTutorial,
  fetchingWords,
  autoConnecting,
  rgpd,
  fini,
}

abstract class Data {
  static LoadingStatus loadingStatus = LoadingStatus.initialisation;

  static EtapeInitialisation etapeInitialisation =
      EtapeInitialisation.checkingTutorial;

  // Liste utilisée par l'application pour son bon fonctionnement
  static List<Mot> listeMots = [];

  // Liste des mots faits par l'utilisateur
  static Map<DateTime, bool> listeMotsUser = {};

  static bool isPremium = false;

  // true = faut montrer, false = faut pas montrer
  static bool tutorielDebut = true;

  ///////////////////////////////////////////////////////////////
  ////////////////////////// FONCTIONS //////////////////////////
  ///////////////////////////////////////////////////////////////

  // Programme d'initialisation
  static Future<void> initialiserData(ProviderLoading provider) async {
    // Initialisiation des pubs
    Ads.initialisation();

    // Vérifie si le tutoriel a été fait
    if (!kIsWeb) {
      Data.etapeInitialisation = EtapeInitialisation.checkingTutorial;
      await GestionMemoire.chargerTutoriel();

      // Active les notifs
      if (tutorielDebut) {
        FirebaseMessaging messaging = FirebaseMessaging.instance;

        await messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
      }

      await Future.delayed(Duration(milliseconds: 300));
      provider.nextStep();
    }

    // Récupère les mots
    Data.etapeInitialisation = EtapeInitialisation.fetchingWords;
    await InitFirebase.getMots();
    provider.nextStep();

    // Essaie de connecter l'utilisateur
    Data.etapeInitialisation = EtapeInitialisation.autoConnecting;
    await Login.autoConnect();
    Data.etapeInitialisation = EtapeInitialisation.fini;
    provider.nextStep();
  }
}
