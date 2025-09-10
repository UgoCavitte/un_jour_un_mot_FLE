import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/activites/constantes_textes_activites.dart';
import 'package:un_jour_un_mot/activites/moteur_activites_mots.dart';
import 'package:un_jour_un_mot/composants/animations/icon_check_animee.dart';
import 'package:un_jour_un_mot/composants/animations/icon_fail_animee.dart';
import 'package:un_jour_un_mot/composants/my_buttons.dart';
import 'package:un_jour_un_mot/composants/my_dialog.dart';
import 'package:un_jour_un_mot/composants/my_flush_bars.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/constantes/constantes_autres.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';
import 'package:un_jour_un_mot/constantes/constantes_textes.dart';
import 'package:un_jour_un_mot/data/data.dart';
import 'package:un_jour_un_mot/data/init_firebase.dart';
import 'package:un_jour_un_mot/data/stats.dart';
import 'package:un_jour_un_mot/misc/lettres.dart';
import 'package:un_jour_un_mot/objects/mot.dart';

class Pendu extends StatelessWidget {
  final Mot mot;

  const Pendu({super.key, required this.mot});

  @override
  Widget build(BuildContext context) {
    if (!context.watch<ProviderPendu>().initialise) {
      context.read<ProviderPendu>().initialisation(mot);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView(
          shrinkWrap: true,
          // Rang supérieur
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250, maxHeight: 250),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Première colonne de lettres ratées
                  _getColonneGauche(context),

                  // Pendu
                  _getIllustration(context),

                  // Deuxième colonne de lettres ratées
                  _getColonneDroite(context),
                ],
              ),
            ),

            // Mot en train d'être deviné
            _getMot(context),

            // Textfield avec bouton de validation -> accepte une lettre ou un mot
            _getTF(context),

            // Victoire/défaite
            _getVictoireDefaite(context),
          ],
        ),

        // Étape suivante si la partie est finie
        if (context.watch<ProviderPendu>().fini)
          _getBoutonSuite(context)
        else
          _getLigneBoutons(context),
      ],
    );
  }

  // Mot en train d'être deviné
  Widget _getMot(BuildContext context) {
    List<Widget> cases = [];

    // Création des cases

    List<String> trouve = context.watch<ProviderPendu>().trouve;
    List<String> motDivise = context.watch<ProviderPendu>().motDivise;
    List<String> motDiviseSansDiacritique =
        context.watch<ProviderPendu>().motDiviseSansDiacritique;

    for (int i = 0; i < motDivise.length; i++) {
      // La lettre a été devinée
      if (trouve.contains(motDiviseSansDiacritique[i])) {
        cases.add(
          Padding(
            padding: ConstantesPaddingMargin.paddingGeneralElements,
            child: MyTextLettrePendu(
              motDivise[i].toUpperCase(),
              isItAVowel: Lettres.isItAVowel(motDivise[i]),
            ),
          ),
        );
      }
      // La lettre n'a pas encore été devinée
      else {
        cases.add(
          Padding(
            padding: ConstantesPaddingMargin.paddingGeneralElements,
            child: MyTextLettrePendu(
              "_",
              isItAVowel: Lettres.isItAVowel(motDivise[i]),
            ),
          ),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: cases,
    );
  }

  // Tf + bouton
  Widget _getTF(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Textfield
        Expanded(
          child: Padding(
            padding: ConstantesPaddingMargin.paddingGeneralElements,
            child: TextField(
              enabled: !context.watch<ProviderPendu>().fini,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp('[a-zA-Zàâéèêëûüùôö]'),
                ),
              ],
              controller: controller,
            ),
          ),
        ),
        // Bouton
        MyButton(
          texte: textePenduVerifier,
          onPressed: () {
            if (controller.text.isNotEmpty) {
              context.read<ProviderPendu>().check(
                controller.text,
                context: context,
              );
            }
          },
        ),
      ],
    );
  }

  // Dessin du pendu
  Widget _getIllustration(BuildContext context) {
    return Expanded(
      child: Container(
        margin: ConstantesPaddingMargin.marginGeneralElements,
        decoration: bordureNoireFine,
        child:
            context.watch<ProviderPendu>().illustrations[_penduStateMap[context
                .watch<ProviderPendu>()
                .penduState]],
      ),
    );
  }

  // Colonne avec les lettres proposées mais fausses
  Widget _getColonneGauche(BuildContext context) {
    return Container(
      margin: ConstantesPaddingMargin.marginGeneralElements,
      padding: ConstantesPaddingMargin.paddingGeneralElements,
      decoration: bordureNoireFine,
      child: SizedBox(
        width: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
              context
                  .watch<ProviderPendu>()
                  .lettresFausses
                  .map(
                    (lettre) => MyTextLettreFaussePendu(lettre.toUpperCase()),
                  )
                  .toList(),
        ),
      ),
    );
  }

  // Colonne avec les mots proposés mais faux
  Widget _getColonneDroite(BuildContext context) {
    return Container(
      margin: ConstantesPaddingMargin.marginGeneralElements,
      padding: ConstantesPaddingMargin.paddingGeneralElements,
      decoration: bordureNoireFine,
      child: SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
              context
                  .watch<ProviderPendu>()
                  .motsEssayes
                  .map((mot) => MyTextGeneral(mot))
                  .toList(),
        ),
      ),
    );
  }

  // Bouton passer à la suite
  Widget _getBoutonSuite(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MyButton(
        texte: textePenduSuite,
        couleur: MyButtonColor.bleuPlein,
        onPressed:
            () => context.read<ProviderMoteurActiviteMots>().etapeSuivante(),
      ),
    );
  }

  // S'affiche jusqu'à ce que l'utilisateur gagne/perde
  Widget _getLigneBoutons(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Abandonner
          Expanded(
            child: MyButton(
              texte: textePenduBoutonAbandonner,
              onPressed:
                  () => context.read<ProviderPendu>().abandonner(context),
            ),
          ),
          // Principes
          Expanded(
            child: MyButton(
              texte: textePenduBoutonPrincipes,
              onPressed:
                  () => showDialog(
                    context: context,
                    builder:
                        (BuildContext context) => MyDialog(
                          context: context,
                          titre: titrePrincipesPendu,
                          text: principesPendu,
                        ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // Victoire / défaite
  Widget _getVictoireDefaite(BuildContext context) {
    if (context.watch<ProviderPendu>().fini) {
      // Défaite
      if (!context.watch<ProviderPendu>().reussi) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyTextGeneral('Perdu ! Le mot était "${mot.mot}"'),
            SizedBox(
              height: 90,
              width: 90,
              child: Center(child: IconFailAnimee()),
            ),
          ],
        );
      }

      // Victoire
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 90,
            width: 90,
            child: Center(child: IconCheckAnimee()),
          ),
        ],
      );
    }
    return SizedBox();
  }
}

enum PenduState {
  vide,
  base,
  barreVerticale,
  barreHorizontale,
  corde,
  tete,
  tronc,
  bras,
  jambes,
}

const Map _penduStateMap = {
  PenduState.vide: 0,
  PenduState.base: 1,
  PenduState.barreVerticale: 2,
  PenduState.barreHorizontale: 3,
  PenduState.corde: 4,
  PenduState.tete: 5,
  PenduState.tronc: 6,
  PenduState.bras: 7,
  PenduState.jambes: 8,
};

const int _limitePenduState = 9;

class ProviderPendu with ChangeNotifier {
  bool initialise = false;

  bool fini = false;
  bool reussi = false;

  bool disclaimerMot = false;

  late final Mot mot;
  final List<String> lettresFausses = [];
  final List<String> trouve = []; // Liste des lettres trouvées
  List<String> motDivise = [];
  List<String> motDiviseSansDiacritique = [];
  PenduState penduState = PenduState.vide;
  List<String> motsEssayes = []; // Liste des mots proposés mais faux

  List<Image> illustrations = [];

  void initialisation(Mot mot) {
    this.mot = mot;

    // On divise le mot en lettres
    motDivise = mot.mot.split("");
    // On enlève les accents
    motDiviseSansDiacritique =
        motDivise.map((lettre) => Lettres.enleverDiacritique(lettre)).toList();

    // On ajoute la première lettre au trouvé
    trouve.add(motDiviseSansDiacritique[0]);

    // Initialiser les images
    for (int i = 0; i < _limitePenduState; i++) {
      illustrations.add(
        Image(image: AssetImage('assets/pendu/0$i.png'), fit: BoxFit.contain),
      );
    }
    initialise = true;
  }

  void check(String entry, {required BuildContext context}) async {
    // On enlève les majuscules
    entry = entry.toLowerCase();

    // On enlève les accents
    entry =
        entry
            .split("")
            .map((lettre) => Lettres.enleverDiacritique(lettre))
            .toList()
            .join();

    // Lettre
    if (entry.length == 1) {
      // Lettre déjà proposée et fausse
      if (lettresFausses.contains(entry)) {
        MyFlushBar(
          message: FlushBarMessage.penduLettreDejaProposeeEtFausse,
        ).show();
        notifyListeners();
      }
      // Lettre déjà proposée et bonne
      else if (trouve.contains(entry)) {
        MyFlushBar(
          message: FlushBarMessage.penduLettreDejaProposeeEtBonne,
        ).show();
        notifyListeners();
      }
      // Lettre bonne
      else if (motDiviseSansDiacritique.contains(entry)) {
        trouve.add(entry);

        // Vérifier que le mot n'est pas complet
        if (trouve.length == motDiviseSansDiacritique.toSet().length) {
          fini = true;
          reussi = true;
          _marquerCommeFait(motStatut: MotStatut.reussi);
        }
        // S'il reste des lettres à deviner
        else {
          MyFlushBar(
            message: FlushBarMessage.penduLettreBonne,
            typeMessage: FlushBarTypeMessage.vert,
          ).show();
        }

        notifyListeners();
      }
      // Lettre fausse
      else {
        lettresFausses.add(entry);
        _enleverUneVie();
        MyFlushBar(
          message: FlushBarMessage.penduLettreFausse,
          typeMessage: FlushBarTypeMessage.rouge,
        ).show();
        notifyListeners();
      }
    }
    // Mot
    else {
      // Disclaimer
      if (!disclaimerMot) {
        if (await confirm(
          context,
          content: MyTextGeneral(textePenduConfirmContent),
          textOK: MyTextGeneralTitre(stringOui),
          textCancel: MyTextGeneralTitre(stringAnnuler),
        )) {
          disclaimerMot = true;
        } else {
          return;
        }
      }

      // Divise le mot
      List<String> entrySeparee = entry.split("");

      // Mot déjà proposé
      if (motsEssayes.contains(entrySeparee.join())) {
        MyFlushBar(message: FlushBarMessage.penduMotDejaPropose).show();
      }
      // Le mot correspond
      else if (entrySeparee.join() == motDiviseSansDiacritique.join()) {
        fini = true;
        reussi = true;
        _marquerCommeFait(motStatut: MotStatut.reussi);
        trouve.addAll(motDiviseSansDiacritique.toSet());
      }
      // Le mot ne correspond pas
      else {
        motsEssayes.add(entry);
        MyFlushBar(
          message: FlushBarMessage.penduMotFaux,
          typeMessage: FlushBarTypeMessage.rouge,
        ).show();
        _enleverUneVie();
      }
    }

    notifyListeners();
  }

  // En cas de victoire, défaite et sortie
  void _marquerCommeFait({required MotStatut motStatut}) async {
    // Met à jour la liste qu'utilise l'appli
    Data
        .listeMots
        .firstWhere((motDeLaListe) => motDeLaListe.date == mot.date)
        .fait = motStatut;

    // Met à jour la liste utilisée pour la sauvegarde sur la DB
    Data.listeMotsUser.addEntries([
      MapEntry<DateTime, bool>(
        mot.date,
        motStatut == MotStatut.reussi ? true : false,
      ),
    ]);

    // Met les stats à jour
    Stats.nbrMotsEssayes++;
    if (motStatut == MotStatut.reussi) Stats.nbrMotsDevines++;

    // Puis on fait la sauvegarde
    await InitFirebase.enregistrerMotsFaits();
  }

  void abandonner(BuildContext context) async {
    if (await confirm(
      context,
      content: MyTextGeneral(textePenduConfirmationAbandon),
      textOK: MyTextGeneralTitre(stringOui),
      textCancel: MyTextGeneralTitre(stringAnnuler),
    )) {
      fini = true;
      reussi = false;

      _marquerCommeFait(motStatut: MotStatut.rate);

      notifyListeners();
    }
  }

  void _enleverUneVie() {
    switch (penduState) {
      case PenduState.vide:
        penduState = PenduState.base;
        break;
      case PenduState.base:
        penduState = PenduState.barreVerticale;
        break;
      case PenduState.barreVerticale:
        penduState = PenduState.barreHorizontale;
        break;
      case PenduState.barreHorizontale:
        penduState = PenduState.corde;
        break;
      case PenduState.corde:
        penduState = PenduState.tete;
        break;
      case PenduState.tete:
        penduState = PenduState.tronc;
        break;
      case PenduState.tronc:
        penduState = PenduState.bras;
        break;
      case PenduState.bras:
        penduState = PenduState.jambes;
        fini = true;
        reussi = false;
        _marquerCommeFait(motStatut: MotStatut.rate);
        break;
      case PenduState.jambes:
        break;
    }
  }
}
