import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/activites/constantes_textes_activites.dart';
import 'package:un_jour_un_mot/activites/moteur_activites_mots.dart';
import 'package:un_jour_un_mot/composants/my_buttons.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';
import 'package:un_jour_un_mot/misc/dates.dart';
import 'package:un_jour_un_mot/objects/mot.dart';

/*
 * Présente l'étape du jour avec un court texte
 */

class Introduction extends StatelessWidget {
  final Mot mot;

  const Introduction({super.key, required this.mot});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            // Titre principal avec la date
            _getTitre(),
            SizedBox(height: ConstantesPaddingMargin.espaceEntreTitreEtSuite),

            // Explication de ce qui va être présenté
            _getExplication(),
            _getAppuyez(),
          ],
        ),
        // Bouton de lancement
        _getBoutonLancement(context),
      ],
    );
  }

  Widget _getTitre() {
    return Center(
      child: Padding(
        padding: ConstantesPaddingMargin.paddingGeneralElements,
        child: MyTextGeneralTitre(
          texteIntroTitre + Dates.formaterDatePourAffichage(mot.date),
        ),
      ),
    );
  }

  Widget _getExplication() {
    return Center(
      child: Padding(
        padding: ConstantesPaddingMargin.paddingGeneralElements,
        child: MyTextGeneral(
          texteIntroExplication,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _getAppuyez() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: ConstantesPaddingMargin.paddingGeneralElements,
        child: MyTextGeneral(texteIntroAppuyez),
      ),
    );
  }

  Widget _getBoutonLancement(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MyButton(
        texte: texteIntroSuivant,
        couleur: MyButtonColor.bleuPlein,
        onPressed:
            () => context.read<ProviderMoteurActiviteMots>().etapeSuivante(),
      ),
    );
  }
}
