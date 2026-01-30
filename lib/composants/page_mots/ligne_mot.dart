import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/activites/moteur_activites_mots.dart';
import 'package:un_jour_un_mot/composants/my_buttons.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_icones.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';
import 'package:un_jour_un_mot/constantes/constantes_textes.dart';
import 'package:un_jour_un_mot/data/data.dart';
import 'package:un_jour_un_mot/global_providers/provider_connect.dart';
import 'package:un_jour_un_mot/misc/dates.dart';
import 'package:un_jour_un_mot/objects/mot.dart';

/*
 * Les lignes comprennent :
 * - la date
 * - le mot s'il a été deviné
 * - deviné/pas deviné/raté
 * - bouton de lancement
 */

class LigneMot extends StatelessWidget {
  final MotNouveau mot;

  const LigneMot({super.key, required this.mot});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: ConstantesPaddingMargin.paddingLignesTableau,
        // padding: EdgeInsets.all(30),
        child: Container(
          color: ConstantesCouleurs.blanc,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ID
              Expanded(child: _getElementID()),
              // Mot
              Expanded(child: _getElementMot()),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Deviné ou pas
                    Expanded(child: _getElementDevine()),
                    // Bouton
                    Expanded(child: _getElementBouton(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getElementID() {
    return Padding(
      padding: ConstantesPaddingMargin.paddingElementLigneTableau,
      child: MyTextLigneTableau(mot.id.toString()),
    );
  }

  Widget _getElementMot() {
    late String toShow;

    switch (mot.fait) {
      case MotStatut.pasOuvert:
        toShow = stringMotPasFait;
        break;
      case MotStatut.reussi || MotStatut.rate:
        toShow = mot.mot;
        break;
    }

    return Padding(
      padding: ConstantesPaddingMargin.paddingElementLigneTableau,
      child: MyTextLigneTableau(toShow),
    );
  }

  Widget _getElementDevine() {
    Icon? icone;

    switch (mot.fait) {
      case MotStatut.pasOuvert:
        icone = null;
      case MotStatut.reussi:
        icone = ConstantesIcones.iconeDevine;
      case MotStatut.rate:
        icone = ConstantesIcones.iconeRate;
    }

    return Padding(
      padding: ConstantesPaddingMargin.paddingElementLigneTableau,
      child: icone,
    );
  }

  Widget _getElementBouton(BuildContext context) {
    // Déjà fait
    if (mot.fait != MotStatut.pasOuvert) {
      return Padding(
        padding: ConstantesPaddingMargin.paddingElementLigneTableau,
        child: MyButtonDejaFait(
          premium: Data.isPremium,
          onPressed: () => lancerMot(mot: mot, context: context),
        ),
      );
    }

    // Le mot est devinable car [Data.firstAvailableID] correspond à son ID
    if (Data.firstAvailableID == mot.id) {
      return Padding(
        padding: ConstantesPaddingMargin.paddingElementLigneTableau,
        child: MyButtonLancerMot(
          premiumSiPasse: true, // TODO check this
          onPressed: () => lancerMot(mot: mot, context: context),
        ),
      );
    }

    // La date n'est pas encore passée
    return Padding(
      padding: ConstantesPaddingMargin.paddingElementLigneTableau,
      child: IconButton(icon: ConstantesIcones.iconeWait, onPressed: () {})
    );
  }

  void lancerMot({required MotNouveau mot, required BuildContext context}) async {
    // Vérifie que l'utilisateur est connecté
    if (!Provider.of<ProviderConnect>(context, listen: false).isUserConnected) {
      if (await confirm(
            context,
            content: MyTextGeneral(stringObligationConnexion),
            textOK: MyTextGeneralTitre(stringCompris),
            textCancel: MyTextGeneralTitre(""),
          ) &&
          context.mounted) {
        return;
      }
    }

    // Vérifie que l'utilisateur n'a pas déjà fait de mot aujourd'hui s'il n'est pas premium    
    if (Dates.fromDateToString(DateTime.now()) == Dates.fromDateToString(Data.lastDate) && !Data.isPremium) {
      if (await confirm(
            context,
            content: MyTextGeneral(stringLimiteQuotidienne),
            textOK: MyTextGeneralTitre(stringCompris),
            textCancel: MyTextGeneralTitre(""),
          ) &&
          context.mounted){
        return;
      }
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => ProviderMoteurActiviteMots(),
                ),
              ],
              child: MoteurActivitesMots(mot: mot),
            ),
      ),
    );
  }
}
