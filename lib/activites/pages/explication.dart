import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/activites/constantes_textes_activites.dart';
import 'package:un_jour_un_mot/activites/moteur_activites_mots.dart';
import 'package:un_jour_un_mot/ads/ads.dart';
import 'package:un_jour_un_mot/composants/my_buttons.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';
import 'package:un_jour_un_mot/global_providers/provider_loaded_banner.dart';
import 'package:un_jour_un_mot/objects/mot.dart';

class Explication extends StatelessWidget {
  final Mot mot;

  const Explication({super.key, required this.mot});

  @override
  Widget build(BuildContext context) {
    context.watch<ProviderAdBanner>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            // Mot écrit en gros
            _getMotTitre(mot),

            SizedBox(height: ConstantesPaddingMargin.espaceEntreTitreEtSuite),

            // Définition
            _getDefinition(mot),

            SizedBox(height: ConstantesPaddingMargin.espaceEntreTitreEtSuite),

            // Exemples
            _getTraductions(mot),
          ],
        ),

        _getPub(context),

        // Bouton de suite
        _getBoutonSuite(context),
      ],
    );
  }

  // Mot écrit en gros
  Widget _getMotTitre(Mot mot) {
    return Align(
      alignment: Alignment.center,
      child: MyTextGrosTitreMajuscules(mot.mot.toUpperCase()),
    );
  }

  // Définition
  Widget _getDefinition(Mot mot) {
    return MyTextGeneral(mot.definition, textAlign: TextAlign.center);
  }

  // Exemples
  Widget _getTraductions(Mot mot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: mot.traductions.values.map((v) => MyTextItalique(v)).toList(),
    );
  }

  // Pub
  Widget _getPub(BuildContext context) {
    if (AdBanner.statutPub != StatutPub.loaded) {
      AdBanner.load(context);
      return AdBanner.showWhenNotLoaded();
    }

    return Expanded(child: AdBanner.show());
  }

  // Passer à la suite
  Widget _getBoutonSuite(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MyButton(
        texte: texteExplicationSuite,
        couleur: MyButtonColor.bleuPlein,
        onPressed:
            () => context.read<ProviderMoteurActiviteMots>().etapeSuivante(),
      ),
    );
  }
}
