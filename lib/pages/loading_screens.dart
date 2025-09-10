import 'package:flutter/material.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/composants/type_dots.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';
import 'package:un_jour_un_mot/constantes/constantes_textes.dart';
import 'package:un_jour_un_mot/data/data.dart';

const int _totalEtapes = 4;
const Map _mapEtapeTexte = {
  EtapeInitialisation.checkingTutorial: stringChargementCheckingTutorial,
  EtapeInitialisation.fetchingWords: stringChargementFetchingWords,
  EtapeInitialisation.autoConnecting: stringChargementAutoConnect,
  EtapeInitialisation.rgpd: stringChargementRGPD,
};
const Map _mapEtapeOrdre = {
  EtapeInitialisation.checkingTutorial: 0,
  EtapeInitialisation.fetchingWords: 1,
  EtapeInitialisation.autoConnecting: 2,
  EtapeInitialisation.rgpd: 3,
};

class LoadingScreens extends StatelessWidget {
  const LoadingScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantesCouleurs.blanc,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: ConstantesPaddingMargin.paddingGeneralElements,
              child: MyTextGeneral(
                _mapEtapeTexte[Data.etapeInitialisation],
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: ConstantesPaddingMargin.paddingGeneralElements,
              child: MyDots(
                dotsCount: _totalEtapes,
                position: _mapEtapeOrdre[Data.etapeInitialisation],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
