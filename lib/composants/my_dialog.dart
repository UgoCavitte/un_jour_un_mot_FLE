import 'package:flutter/material.dart';
import 'package:un_jour_un_mot/composants/my_buttons.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';

const String _fermer = "Fermer";
const EdgeInsets _paddingTexte = EdgeInsets.all(10);

class MyDialog extends Dialog {
  late final String titre;
  late final RichText text;
  late final BuildContext context;
  MyDialog({
    super.key,
    required this.context,
    required this.titre,
    required this.text,
  }) : super(
         backgroundColor: ConstantesCouleurs.blanc,
         child: Column(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             // Texte
             Flexible(
               child: ListView(
                 padding: _paddingTexte,
                 shrinkWrap: true,
                 children: [
                   MyTextGeneralTitre(titre),
                   ConstantesPaddingMargin.espaceRichTextBox,
                   text,
                 ],
               ),
             ),

             // Bouton
             SizedBox(
               width: double.infinity,
               child: MyButton(
                 couleur: MyButtonColor.bleuPlein,
                 texte: _fermer,
                 onPressed: () => Navigator.pop(context),
               ),
             ),
           ],
         ),
       );
}
