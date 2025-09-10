import 'package:flutter/material.dart';

abstract final class ConstantesCouleurs {
  static final Color bleu = Color(0xff00049f);
  static final Color bleuClair = Colors.lightBlue;
  static final Color rouge = Color(0xffff3131);
  static final Color orange = Color(0xffe39830);
  static final Color blanc = Color(0xffffffff);
  static final Color vert = Colors.green;
  static final Color grisClair = Color(0xffbebebe);
  static final Color noir = Colors.black;

  static final LinearGradient gradientBleuBleuClair = LinearGradient(
    colors: [bleu, bleuClair],
  );
  static final LinearGradient gradientRougeRougeClair = LinearGradient(
    colors: [rouge, orange],
  );
}
