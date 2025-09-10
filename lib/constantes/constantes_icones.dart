import 'package:flutter/material.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';

abstract final class ConstantesIcones {
  // Icone bottom navigation bar
  static final Icon iconeHome = Icon(
    Icons.home,
    color: ConstantesCouleurs.rouge,
  );
  static final Icon iconeBoutique = Icon(
    Icons.store,
    color: ConstantesCouleurs.rouge,
  );

  // Autres
  static final Icon iconeParametres = Icon(Icons.settings);
  static final Icon iconeDevine = Icon(
    Icons.check,
    color: ConstantesCouleurs.vert,
  );
  static final Icon iconeRate = Icon(
    Icons.close,
    color: ConstantesCouleurs.rouge,
  );
  static final Icon iconePasDevine = Icon(
    Icons.question_mark,
    color: ConstantesCouleurs.rouge,
  );
  static final Icon iconePlayGrisee = Icon(
    Icons.play_arrow,
    color: ConstantesCouleurs.grisClair,
  );
  static final Icon iconeReplayVerte = Icon(
    Icons.replay,
    color: ConstantesCouleurs.vert,
  );
  static final Icon iconeReplayGrisee = Icon(
    Icons.replay,
    color: ConstantesCouleurs.grisClair,
  );
  static final Icon iconePlayVerte = Icon(
    Icons.play_arrow,
    color: ConstantesCouleurs.vert,
  );
  static final Icon iconeBack = Icon(
    Icons.arrow_back,
    color: ConstantesCouleurs.blanc,
  );
  static final Icon iconeBackBleue = Icon(
    Icons.arrow_back,
    color: ConstantesCouleurs.bleu,
  );
  static final Icon iconeNext = Icon(
    Icons.arrow_forward,
    color: ConstantesCouleurs.blanc,
  );
  static final Icon iconeNextBleue = Icon(
    Icons.arrow_forward,
    color: ConstantesCouleurs.bleu,
  );
  static final Icon iconeWait = Icon(
    Icons.timelapse,
    color: ConstantesCouleurs.grisClair,
  );
}
