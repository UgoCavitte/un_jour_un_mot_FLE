import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/activites/constantes_textes_activites.dart';
import 'package:un_jour_un_mot/activites/moteur_activites_mots.dart';
import 'package:un_jour_un_mot/composants/animations/icon_check_animee.dart';
import 'package:un_jour_un_mot/composants/animations/icon_fail_animee.dart';
import 'package:un_jour_un_mot/composants/my_buttons.dart';
import 'package:un_jour_un_mot/composants/my_progress_bars.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';
import 'package:un_jour_un_mot/misc/lettres.dart';
import 'package:un_jour_un_mot/objects/mot.dart';

/*
 * Cette activité propose une liste de mots très similaires dont un est le mot
 * du jour avec la bonne orthographe
 * 
 * INTERROGATION : Est-ce qu'il faut que je fasse moi-même une liste de fausses
 * orthographes ou bien est-ce que c'est l'application qui doit s'en occuper ?
 */

const int _maxEtapes = 5;
const int _maxPropositions = 4;
const double _ratioMaxLettresChangeables = 0.5;

class JeuTrouveOrthographe extends StatelessWidget {
  final Mot mot;
  const JeuTrouveOrthographe({super.key, required this.mot});

  @override
  Widget build(BuildContext context) {
    if (!context.watch<ProviderJeuTrouveOrthographe>().initialise) {
      context.read<ProviderJeuTrouveOrthographe>().initialisation(mot);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            // Barre de progression
            _getBarreDeProgression(context),

            // Consigne
            _getConsigne(),

            SizedBox(height: ConstantesPaddingMargin.espaceEntreTitreEtSuite),

            // Orthographes proposées
            _getOrthographesProposees(context),

            _getAnimation(context),
          ],
        ),

        // Étape suivante si la partie est finie
        if (context.watch<ProviderJeuTrouveOrthographe>().fini)
          _getBoutonSuite(context),
      ],
    );
  }

  Widget _getBarreDeProgression(BuildContext context) {
    ProviderJeuTrouveOrthographe provider =
        context.watch<ProviderJeuTrouveOrthographe>();

    return MyProgressBar(
      index: provider.fini ? _maxEtapes : provider.etapeEnCours,
      total: _maxEtapes,
    );
  }

  Widget _getConsigne() {
    return MyTextGeneralTitre(texteTrouveOrthographeConsigne.toUpperCase());
  }

  Widget _getOrthographesProposees(BuildContext context) {
    ProviderJeuTrouveOrthographe provider =
        context.watch<ProviderJeuTrouveOrthographe>();

    List<MyButton> toShow = provider.listeBoutons[provider.etapeEnCours];

    // Recherche les boutons à griser
    for (int i = 0; i < toShow.length; i++) {
      if (provider.mauvaisesReponsesTentees.contains(toShow[i].texte)) {
        toShow[i] = MyButton(
          texte: toShow[i].texte,
          couleur: MyButtonColor.grisClairPlein,
          onPressed: () {},
        );
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: toShow,
    );
  }

  Widget _getAnimation(BuildContext context) {
    // Mauvaise réponse
    if (!context.watch<ProviderJeuTrouveOrthographe>().animationBonneReponse) {
      return SizedBox(
        height: 90,
        width: 90,
        child: Center(child: IconFailAnimee(key: UniqueKey())),
      );
    }

    // Premier tour -> rien
    if (context.watch<ProviderJeuTrouveOrthographe>().etapeEnCours == 0) {
      return SizedBox();
    }
    // Bonne réponse
    else {
      return SizedBox(
        height: 90,
        width: 90,
        child: Center(child: IconCheckAnimee(key: UniqueKey())),
      );
    }
  }

  Widget _getBoutonSuite(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MyButton(
        texte: texteTrouveOrthographeSuite,
        couleur: MyButtonColor.bleuPlein,
        onPressed:
            () => context.read<ProviderMoteurActiviteMots>().etapeSuivante(),
      ),
    );
  }
}

class ProviderJeuTrouveOrthographe with ChangeNotifier {
  bool initialise = false;
  bool fini = false;

  final List<String> mauvaisesReponsesTentees = [];
  bool nouvelleEtape = true;

  late final Mot mot;
  late final List<String> motLettres;

  int etapeEnCours = 0;

  bool animationBonneReponse = true;

  final List<String> listePropositions =
      []; // N'inclut pas la bonne orthographe

  final List<List<MyButton>> listeBoutons = [];

  void initialisation(Mot mot) {
    this.mot = mot;
    motLettres = mot.mot.split("");

    // Créations des fausses orthographes
    Random random = Random();
    for (int i = 0; i < _maxEtapes * (_maxPropositions - 1); i++) {
      // Sélection du nombre de lettres différentes à changer
      int qtAChanger =
          random.nextInt(
            (mot.mot.length * _ratioMaxLettresChangeables).floor(),
          ) +
          1;

      // Tourne tant que le nombre de lettres à changer n'a pas été atteint
      List<int> indexFaits = [];
      for (int j = 0; j < qtAChanger; j++) {
        // Cherche un index jusqu'à en trouver un qui n'est pas dans la liste des déjà faits
        int nouvelIndex = 0;
        do {
          nouvelIndex = random.nextInt(motLettres.length);
        } while (indexFaits.contains(nouvelIndex));
        indexFaits.add(nouvelIndex);
      }

      // Change les lettres des index pour une autre
      List<String> motEnCoursDeModif = [];
      motEnCoursDeModif.addAll(motLettres);
      for (int index in indexFaits) {
        // Cherche une lettre jusqu'à en trouver une autre
        String nouvelleLettre = "";
        do {
          nouvelleLettre =
              Lettres.listeLettresPourRemplacer[random.nextInt(
                Lettres.listeLettresPourRemplacer.length,
              )];
        } while (nouvelleLettre.toUpperCase() == motLettres[index]);
        motEnCoursDeModif[index] = nouvelleLettre;
      }

      // Vérifie que cette mauvaise orthographe n'a pas déjà été proposée
      if (listePropositions.contains(motEnCoursDeModif.join())) {
        i--; // Annule le tour
      } else {
        listePropositions.add(motEnCoursDeModif.join());
      }
    }

    _initialisationBoutons();

    initialise = true;
  }

  void _initialisationBoutons() {
    for (int i = 0; i < _maxEtapes; i++) {
      List<MyButton> toAdd = [];

      // Ajoute les fausses propositions
      for (int j = 0; j < (_maxPropositions - 1); j++) {
        String mot = listePropositions[j + ((_maxPropositions - 1) * i)];
        toAdd.add(
          MyButton(
            texte: mot,
            onPressed: () {
              if (!fini) {
                check(mot);
              }
            },
          ),
        );
      }

      toAdd.add(
        MyButton(
          texte: mot.mot,
          onPressed: () {
            if (!fini) {
              check(mot.mot);
            }
          },
        ),
      );

      toAdd.shuffle();

      listeBoutons.add([]); // Création de l'espace en mémoire
      listeBoutons[i].addAll(toAdd);
    }
  }

  void check(String proposition) {
    // Si ça correspond
    if (proposition == mot.mot) {
      // Dernière étape ?
      if (etapeEnCours == _maxEtapes - 1) {
        fini = true;
        animationBonneReponse = true;
        nouvelleEtape = false;
      } else {
        etapeEnCours++;
        animationBonneReponse = true;
        mauvaisesReponsesTentees.clear();
        nouvelleEtape = true;
      }

      notifyListeners();
    }
    // Si ça ne correspond pas
    else {
      mauvaisesReponsesTentees.add(proposition);
      animationBonneReponse = false;
      nouvelleEtape = false;
      notifyListeners();
    }
  }
}
