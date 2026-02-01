import 'package:flutter/material.dart';
import 'package:un_jour_un_mot/composants/page_mots/ligne_mot.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';
import 'package:un_jour_un_mot/data/data.dart';
import 'package:un_jour_un_mot/objects/mot.dart';

/*
 * Container avec les lignes des mots du jour
 */

class CarteMotsAAfficher extends StatelessWidget {
  const CarteMotsAAfficher({super.key});

  @override
  Widget build(BuildContext context) {

    // Afficher les mots
    return Container(
      alignment: Alignment.center,
      padding: ConstantesPaddingMargin.paddingGeneralElements,
      margin: ConstantesPaddingMargin.marginGeneralElements,
      decoration: BoxDecoration(
        gradient: ConstantesCouleurs.gradientBleuBleuClair,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(shrinkWrap: true, children: _getElements()),
    );
  }

  // Done words are shown + the one doable + 3
  List<Widget> _getElements() {
    List<MotNouveau> thatCanBeShown = Data.listeMots.where((mot) => mot.id <= Data.firstAvailableID + 3).toList();

    return thatCanBeShown.map((mot) => LigneMot(mot: mot)).toList();
  }
}
