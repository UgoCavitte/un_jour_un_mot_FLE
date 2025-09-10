import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/activites/constantes_textes_activites.dart';
import 'package:un_jour_un_mot/composants/animations/icon_check_animee.dart';
import 'package:un_jour_un_mot/composants/my_buttons.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';
import 'package:un_jour_un_mot/misc/dates.dart';
import 'package:un_jour_un_mot/objects/mot.dart';
import 'package:un_jour_un_mot/pages/page_home.dart';

class Fin extends StatelessWidget {
  final Mot mot;

  const Fin({super.key, required this.mot});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            // Titre
            _getTitre(),

            SizedBox(height: ConstantesPaddingMargin.espaceEntreTitreEtSuite),

            // Texte
            _getCorps(),

            SizedBox(height: ConstantesPaddingMargin.espaceEntreTitreEtSuite),

            // Animation
            SizedBox(
              height: 90,
              width: 90,
              child: Center(child: IconCheckAnimee()),
            ),
          ],
        ),
        // Bouton de lancement
        _getBoutonSortie(context),
      ],
    );
  }

  Widget _getTitre() {
    return Center(
      child: Padding(
        padding: ConstantesPaddingMargin.paddingGeneralElements,
        child: MyTextGeneralTitre(
          texteFiniTitre + Dates.formaterDatePourAffichage(mot.date),
        ),
      ),
    );
  }

  Widget _getCorps() {
    return Center(
      child: Padding(
        padding: ConstantesPaddingMargin.paddingGeneralElements,
        child: MyTextGeneral(
          texteFiniCorps1 + mot.mot + texteFiniCorps2,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _getBoutonSortie(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MyButton(
        texte: texteFiniSortir,
        couleur: MyButtonColor.bleuPlein,
        onPressed:
            () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder:
                    (context) => ChangeNotifierProvider(
                      create: (_) => ProviderPageHome(),
                      child: SafeArea(child: PageHome(index: 0)),
                    ),
              ),
              (_) => false,
            ),
      ),
    );
  }
}
