import 'package:flutter/material.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_icones.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';
import 'package:un_jour_un_mot/constantes/constantes_textes.dart';

enum MyButtonColor {
  gradientRouge,
  rougePlein,
  gradientBleu,
  bleuPlein,
  grisClairPlein,
}

enum _GradientOrColor { gradient, color }

Map<MyButtonColor, _GradientOrColor> _mapButtonGradientOrColor = {
  MyButtonColor.gradientRouge: _GradientOrColor.gradient,
  MyButtonColor.gradientBleu: _GradientOrColor.gradient,
  MyButtonColor.rougePlein: _GradientOrColor.color,
  MyButtonColor.bleuPlein: _GradientOrColor.color,
  MyButtonColor.grisClairPlein: _GradientOrColor.color,
};

Map<MyButtonColor, dynamic> _mapConstantToColor = {
  MyButtonColor.gradientRouge: ConstantesCouleurs.gradientRougeRougeClair,
  MyButtonColor.gradientBleu: ConstantesCouleurs.gradientBleuBleuClair,
  MyButtonColor.rougePlein: ConstantesCouleurs.rouge,
  MyButtonColor.bleuPlein: ConstantesCouleurs.bleu,
  MyButtonColor.grisClairPlein: ConstantesCouleurs.grisClair,
};

// Bouton classique personnalisable
class MyButton extends Padding {
  final String texte;

  MyButton({
    super.key,
    required this.texte,
    MyButtonColor couleur = MyButtonColor.rougePlein,
    required VoidCallback onPressed,
  }) : super(
         padding: ConstantesPaddingMargin.paddingGeneralElements,
         child: Container(
           decoration:
               _mapButtonGradientOrColor[couleur] ==
                       _GradientOrColor
                           .color // Si c'est un gradient, on applique un gradient
                   ? null
                   : BoxDecoration(
                     gradient: _mapConstantToColor[couleur],
                     borderRadius: BorderRadius.circular(10),
                   ),
           child: ElevatedButton(
             onPressed: onPressed,
             style: ElevatedButton.styleFrom(
               shadowColor:
                   _mapButtonGradientOrColor[couleur] == _GradientOrColor.color
                       ? null
                       : Colors.transparent,
               backgroundColor:
                   _mapButtonGradientOrColor[couleur] == _GradientOrColor.color
                       ? _mapConstantToColor[couleur]
                       : Colors.transparent,
             ),
             child: Text(
               texte,
               textAlign: TextAlign.center,
               style: textStyleBoutons,
             ),
           ),
         ),
       );
}

class MyButtonDejaFait extends IconButton {
  MyButtonDejaFait({super.key, required bool premium, VoidCallback? onPressed})
    : super(
        icon:
            premium
                ? ConstantesIcones.iconeReplayVerte
                : ConstantesIcones.iconeReplayGrisee,
        onPressed: premium ? onPressed : () {},
      );
}

class MyButtonLancerMot extends IconButton {
  MyButtonLancerMot({
    super.key,
    required super.onPressed,
  }) : super(
         icon: ConstantesIcones.iconePlayVerte,
       );
}
