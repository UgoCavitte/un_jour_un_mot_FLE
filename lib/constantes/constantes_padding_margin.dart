import 'package:flutter/material.dart';

abstract final class ConstantesPaddingMargin {
  static final EdgeInsets paddingGeneralElements = EdgeInsets.all(5);
  static final EdgeInsets marginGeneralElements = EdgeInsets.all(5);
  static final EdgeInsets paddingLignesTableau = EdgeInsets.fromLTRB(
    2,
    1,
    2,
    1,
  );
  static final EdgeInsets paddingElementLigneTableau = EdgeInsets.fromLTRB(
    3,
    1,
    6,
    1,
  );

  static final double espaceEntreTitreEtSuite = 20;

  static final WidgetSpan espaceRichTextSpan = WidgetSpan(
    child: SizedBox(height: 30),
  );
  static final SizedBox espaceRichTextBox = SizedBox(height: 10);
}
