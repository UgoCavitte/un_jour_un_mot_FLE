import 'package:flutter/material.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_textes.dart';

class ContainerTitre extends InputDecorator {
  final Widget childWidget;
  final String title;

  ContainerTitre({required this.title, required this.childWidget, super.key})
    : super(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ConstantesCouleurs.bleu),
          ),
          label: Text(
            title,
            style: TextStyle(
              color: ConstantesCouleurs.bleu,
              fontSize: fontSizeStandard,
            ),
          ),
        ),
        child: childWidget,
      );
}
