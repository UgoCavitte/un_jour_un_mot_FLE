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
 * Le jeu propose un clavier custom avec les lettres du mot
 * L'utilisateur doit réécrire le mot un certain nombre de fois
 * L'ordre des lettres importe !
 * L'ordre des touches change à chaque fois
 */

const int _maxEtapes = 3;

class JeuReecrire extends StatelessWidget {
  final Mot mot;

  const JeuReecrire({super.key, required this.mot});

  @override
  Widget build(BuildContext context) {
    if (!context.watch<ProviderJeuReecrire>().initialise) {
      context.read<ProviderJeuReecrire>().initialisation(mot);
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
        if (context.watch<ProviderJeuReecrire>().fini) _getBoutonSuite(context),
      ],
    );
  }

  Widget _getBarreDeProgression(BuildContext context) {
    ProviderJeuReecrire provider = context.watch<ProviderJeuReecrire>();

    return MyProgressBar(
      index: provider.fini ? _maxEtapes : provider.etapeEnCours,
      total: _maxEtapes,
    );
  }

  Widget _getConsigne() {
    return MyTextGeneralTitre(texteReecrireConsigne.toUpperCase());
  }

  Widget _getMotAvecLacune(BuildContext context) {
    List<Widget> lettresAAfficher = [];
    ProviderJeuReecrire provider = context.watch<ProviderJeuReecrire>();

    for (int i = 0; i < provider.motLettres.length; i++) {
      // Si la lettre a déjà été devinée
      if (i < provider.indexLettreEnCours) {
        lettresAAfficher.add(MyTextLettrePendu(provider.motLettres[i]));
      }
      // Sinon "_"
      else {
        lettresAAfficher.add(MyTextLettrePendu("_"));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: lettresAAfficher,
    );
  }

  Widget _getLettresProposees(BuildContext context) {
    ProviderJeuReecrire provider = context.watch<ProviderJeuReecrire>();
    return MyClavier(
      lettres: provider.lettresProposees.toSet(),
      lettresGrisees: provider.lettresFausses.toSet(),
      callBack: (lettre) {
        if (!provider.fini) {
          provider.update(lettre);
        }
      },
    );
  }

  Widget _getAnimation(BuildContext context) {
    ProviderJeuReecrire provider = context.watch<ProviderJeuReecrire>();

    if (provider.erreur) {
      return SizedBox(
        height: 90,
        width: 90,
        child: Center(child: IconFailAnimee(key: UniqueKey())),
      );
    }

    if (provider.nouveauMot || provider.fini) {
      return SizedBox(
        height: 90,
        width: 90,
        child: Center(child: IconCheckAnimee(key: UniqueKey())),
      );
    } else {
      return SizedBox();
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

class ProviderJeuReecrire with ChangeNotifier {
  bool initialise = false;
  bool fini = false;

  late final Mot mot;
  late final List<String> motLettres;

  int etapeEnCours = 0;

  bool erreur = false;
  bool nouveauMot = false;

  // Tout ce qui concerne la mécanique du jeu
  int indexLettreEnCours = 0;
  List<String> lettresProposees =
      []; // Touches du clavier -> l'ordre change à chaque tour

  List<String> lettresFausses = [];

  void initialisation(Mot mot) {
    this.mot = mot;
    motLettres = mot.mot.split("");

    // Initialisation des listes etc.
    lettresProposees.addAll(motLettres);
    lettresProposees.shuffle();

    initialise = true;
  }

  // Change l'ordre des touches et réinitialise ce qu'il faut
  void _nouveauTour() {
    indexLettreEnCours = 0;
    lettresProposees.shuffle();
    nouveauMot = true;
    etapeEnCours++;
  }

  void update(String lettre) {
    nouveauMot = false;
    erreur = false;

    // Vérification de la lettre
    if (lettre == motLettres[indexLettreEnCours]) {
      lettresFausses.clear();

      // Si la lettre était la dernière
      if (indexLettreEnCours == motLettres.length - 1) {
        indexLettreEnCours++;

        _checkDernierTour();
      }
      // Sinon, passer à la lettre suivante
      else {
        indexLettreEnCours++;
        notifyListeners();
      }
    }
    // Sinon, l'utilisateur s'est trompé et il faut griser la lettre
    else {
      lettresFausses.add(lettre);
      erreur = true;
      notifyListeners();
    }
  }

  void _checkDernierTour() {
    // Si ce tour n'était pas le dernier
    if (etapeEnCours < _maxEtapes - 1) {
      _nouveauTour();
      notifyListeners();
    }
    // Sinon, marquer la fin
    else {
      fini = true;
      notifyListeners();
    }
  }
}
