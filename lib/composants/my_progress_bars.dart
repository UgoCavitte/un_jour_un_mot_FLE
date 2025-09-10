import 'package:flutter/material.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';

class MyProgressBar extends StatelessWidget {
  final int index;
  final int total;

  const MyProgressBar({super.key, required this.index, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: LinearProgressIndicator(
        value: index / (total),
        color: ConstantesCouleurs.rouge,
      ),
    );
  }
}
