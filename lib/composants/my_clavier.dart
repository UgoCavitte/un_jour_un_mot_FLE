import 'package:flutter/material.dart';
import 'package:un_jour_un_mot/composants/my_buttons.dart';

class MyClavier extends StatelessWidget {
  final Set<String> lettres; // Toutes les lettres
  final Set<String> lettresGrisees; // Seules les lettres grisees
  final Function(String lettre) callBack;

  const MyClavier({
    super.key,
    required this.lettres,
    required this.lettresGrisees,
    required this.callBack,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> touches = [];

    // Création des touches
    for (String lettre in lettres) {
      // Touche grisee
      if (lettresGrisees.contains(lettre)) {
        touches.add(
          MyButton(
            texte: lettre,
            couleur: MyButtonColor.grisClairPlein,
            onPressed: () {},
          ),
        );
      }
      // Touche valide
      else {
        touches.add(MyButton(texte: lettre, onPressed: () => callBack(lettre)));
      }
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: touches,
    );
  }
}
