import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/activites/constantes_textes_activites.dart';
import 'package:un_jour_un_mot/activites/moteur_activites_mots.dart';
import 'package:un_jour_un_mot/composants/animations/icon_check_animee.dart';
import 'package:un_jour_un_mot/composants/animations/icon_fail_animee.dart';
import 'package:un_jour_un_mot/composants/my_buttons.dart';
import 'package:un_jour_un_mot/composants/my_clavier.dart';
import 'package:un_jour_un_mot/composants/my_progress_bars.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';
import 'package:un_jour_un_mot/objects/mot.dart';

/*
 * Cette activité présente un certain nombre de fois le mot avec des lettres
 * manquantes
 * Plus on avance dans l'activité, plus il y a de lettres manquantes
 */

class JeuCompleter extends StatelessWidget {
  final Mot mot;
  const JeuCompleter({super.key, required this.mot});

  @override
  Widget build(BuildContext context) {
    if (!context.watch<ProviderJeuCompleter>().initialise) {
      context.read<ProviderJeuCompleter>().initialisation(mot);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            // Barre de progression
            _getBarreDeProgression(context),

            // Consigne
            _getConsigne(),

            SizedBox(height: ConstantesPaddingMargin.espaceEntreTitreEtSuite),

            // Mot avec lacune(s)
            _getMotAvecLacune(context),

            SizedBox(height: ConstantesPaddingMargin.espaceEntreTitreEtSuite),

            // Lettres proposées
            _getLettresProposees(context),

            SizedBox(height: ConstantesPaddingMargin.espaceEntreTitreEtSuite),

            // Animation
            _getAnimation(context),
          ],
        ),

        // Étape suivante si la partie est finie
        if (context.watch<ProviderJeuCompleter>().fini)
          _getBoutonSuite(context),
      ],
    );
  }

  Widget _getBarreDeProgression(BuildContext context) {
    ProviderJeuCompleter provider = context.watch<ProviderJeuCompleter>();

    return MyProgressBar(
      index: provider.fini ? provider.totalEtapes : provider.etapeEnCours,
      total: provider.totalEtapes,
    );
  }

  Widget _getConsigne() {
    return MyTextGeneralTitre(texteCompleterConsigne.toUpperCase());
  }

  Widget _getMotAvecLacune(BuildContext context) {
    List<Widget> cases = [];

    ProviderJeuCompleter variables = context.watch<ProviderJeuCompleter>();

    // Création des cases en prenant compte des lettres trouvées par l'utilisateur
    List<String> motAvecLacuneDivise = variables
        .motsAvecLacune[variables.etapeEnCours]
        .split("");

    for (int i = 0; i < motAvecLacuneDivise.length; i++) {
      if (motAvecLacuneDivise[i] == "_") {
        String lettreACheck = variables.mot.mot.split("")[i];
        cases.add(
          MyTextLettrePendu(
            variables.lettresFaites.contains(lettreACheck) ? lettreACheck : "_",
          ),
        );
      } else {
        cases.add(MyTextLettrePendu(motAvecLacuneDivise[i]));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: cases,
    );
  }

  Widget _getLettresProposees(BuildContext context) {
    ProviderJeuCompleter provider = context.watch<ProviderJeuCompleter>();
    return MyClavier(
      lettres: provider.lettresProposees.toSet(),
      lettresGrisees: provider.lettresFaites,
      callBack: (lettre) {
        if (!provider.fini) {
          provider.updateLettre(lettre);
        }
      },
    );
  }

  Widget _getBoutonSuite(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MyButton(
        texte: texteCompleterSuite,
        couleur: MyButtonColor.bleuPlein,
        onPressed:
            () => context.read<ProviderMoteurActiviteMots>().etapeSuivante(),
      ),
    );
  }

  Widget _getAnimation(BuildContext context) {
    ProviderJeuCompleter provider = context.watch<ProviderJeuCompleter>();

    // Si l'utilisateur a fait une faute
    if (provider.erreur) {
      return SizedBox(
        height: 90,
        width: 90,
        child: Center(child: IconFailAnimee(key: UniqueKey())),
      );
    }

    // L'utilisateur a trouvé le mot précédent ou a terminé
    if (provider.nouveauMot) {
      return SizedBox(
        height: 90,
        width: 90,
        child: Center(child: IconCheckAnimee(key: UniqueKey())),
      );
    }

    return SizedBox();
  }
}

class ProviderJeuCompleter with ChangeNotifier {
  bool initialise = false;
  bool fini = false;

  late final int totalEtapes;
  int etapeEnCours = 0;
  final List<String> motsAvecLacune = [];
  final List<List<String>> lettresATrouver = [];

  late final List<String> motLettres;
  late final Mot mot;

  bool nouveauMot = false;
  bool erreur = false;

  final List<String> lettresProposees = []; // Lettres proposées à l'utilisateur
  Set<String> lettresFaites = {}; // Lettres que l'utilisateur a essayées

  void initialisation(Mot mot) {
    this.mot = mot;
    motLettres = mot.mot.split("");

    // Calcul du nombre de questions possible
    // On arrondit la moitié du nombre de lettres à l'unité supérieure
    totalEtapes = (mot.mot.length / 2).ceil();

    // On prend toutes les lettres différentes du mot
    // Le cast en Set permet d'éliminer les doublons
    List<String> lettresDifferentes = motLettres.toSet().toList();

    // On change le nombre total d'étapes pour le total de lettres si celui est inférieur à l'arrondi de la moitié à l'unité supérieure
    if (lettresDifferentes.length < totalEtapes) {
      totalEtapes = lettresDifferentes.length;
    }

    // Génération des mots avec lacunes
    // On enlève chaque lettre une seule fois
    // Les lettres sont choisies de manière aléatoire
    // La lacune s'ajoute aux lacunes précédentes
    lettresDifferentes.shuffle();
    // Divise le mot en lettres
    List<String> temp = motLettres;
    for (int i = 0; i < totalEtapes; i++) {
      // Récupère les index de la lettre en cours
      List<int> indexLettre =
          temp
              .asMap()
              .map(
                (index, element) =>
                    element == lettresDifferentes[i]
                        ? MapEntry(index, null)
                        : MapEntry(-1, null),
              )
              .keys
              .toList()
            ..removeWhere((index) => index == -1);

      // Choisit un index aléatoire dans cette liste et on remplace la lettre
      // en question par un tiret du bas
      indexLettre.shuffle();

      // On ajoute la lettre à la liste des lettres à trouver
      lettresATrouver.add([]); // Création de l'espace en mémoire pour l'index i
      lettresATrouver[i].add(temp[indexLettre[0]]);
      if (i != 0) lettresATrouver[i].addAll(lettresATrouver[i - 1]);

      // On replace cette lettre par un tiret
      temp[indexLettre[0]] = "_";

      // Puis on ajoute à la liste
      motsAvecLacune.add(temp.join());
    }

    // Initialisation des lettres
    lettresProposees.addAll(lettresDifferentes);
    lettresProposees.shuffle();

    initialise = true;
  }

  // Ajoute une lettre
  void updateLettre(String lettre) {
    nouveauMot = false;
    erreur = false;
    lettresFaites.add(lettre);

    // Vérifie si le mot est complet
    bool complet = true;
    for (var lettre in lettresATrouver[etapeEnCours]) {
      if (!lettresFaites.contains(lettre)) {
        complet = false;
        break;
      }
    }

    // Vérifie si l'utilisateur a fait une faute
    if (!lettresATrouver[etapeEnCours].contains(lettre)) {
      erreur = true;
    }

    if (complet) {
      motSuivant();
    } else {
      notifyListeners();
    }
  }

  void motSuivant() {
    // S'il reste encore une étape
    if (etapeEnCours < totalEtapes - 1) {
      lettresFaites = {};
      lettresProposees.shuffle();
      erreur = false;
      nouveauMot = true;
      etapeEnCours++;
      notifyListeners();
    }
    // Sinon fini
    else {
      fini = true;
      erreur = false;
      nouveauMot = true;
      notifyListeners();
    }
  }
}
