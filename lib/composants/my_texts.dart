import 'package:flutter/material.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_textes.dart';

class MyTextGeneral extends Text {
  MyTextGeneral(
    super.data, {
    super.key,
    super.textAlign = TextAlign.left,
    Color? color,
  }) : super(
         style: TextStyle(
           fontSize: fontSizeStandard,
           color: color ?? ConstantesCouleurs.bleu,
         ),
       );
}

class MyTextGeneralTitre extends Text {
  MyTextGeneralTitre(
    super.data, {
    super.key,
    super.textAlign = TextAlign.center,
  }) : super(style: textStyleGeneralTitre);
}

class MyTitreAppBar extends Text {
  MyTitreAppBar(super.data, {super.key}) : super(style: textStyleTitreAppBar);
}

class MyTextLigneTableau extends Text {
  MyTextLigneTableau(super.data, {super.key})
    : super(style: textStyleLigneTableau);
}

class MyTextLettrePendu extends Text {
  MyTextLettrePendu(super.data, {bool isItAVowel = false, super.key})
    : super(
        style:
            isItAVowel
                ? textStyleLettrePenduVoyelle
                : textStyleLettrePenduConsonne,
      );
}

class MyTextLettreFaussePendu extends Text {
  MyTextLettreFaussePendu(super.data, {super.key})
    : super(style: textStyleLettreFaussePendu);
}

class MyTextItalique extends Text {
  MyTextItalique(super.data, {super.key}) : super(style: textStyleItalique);
}

class MyTextGrosTitreMajuscules extends Text {
  MyTextGrosTitreMajuscules(super.data, {super.key})
    : super(style: textStyleGrosTitreMajuscules);
}
