import 'package:flutter/widgets.dart';
import 'package:un_jour_un_mot/composants/my_buttons.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';

class ContainerAchat extends Container {
  final String name;
  final String description;
  final String price;
  final String currency;
  final bool dejaAchete;

  final Function() callBack;

  ContainerAchat({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.dejaAchete,
    required this.callBack,
  }) : super(
         decoration: BoxDecoration(
           border: Border.all(width: 2),
           borderRadius: BorderRadius.circular(3),
         ),
         padding: ConstantesPaddingMargin.paddingGeneralElements,
         margin: ConstantesPaddingMargin.paddingGeneralElements,
         child: Row(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
             Expanded(
               flex: 10,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   MyTextGeneral(name),
                   const Text(""),
                   MyTextGeneral(description),
                   const Text(""),
                   MyTextGeneral("$price $currency"),
                 ],
               ),
             ),
             const Spacer(flex: 1),
             Expanded(
               flex: 4,
               child:
                   !dejaAchete
                       ? MyButton(texte: "Acheter", onPressed: callBack)
                       : MyTextGeneral(
                         "Déjà acheté !",
                         color: ConstantesCouleurs.rouge,
                       ),
             ),
           ],
         ),
       );
}
