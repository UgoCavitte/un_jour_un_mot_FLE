import 'package:flutter/material.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';

class MyVerticalDivider extends Padding {
  MyVerticalDivider({super.key, Color? color})
    : super(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: VerticalDivider(
          color: color ?? ConstantesCouleurs.noir,
          width: 1,
          thickness: 1,
        ),
      );
}
