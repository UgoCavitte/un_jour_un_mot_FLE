import 'package:dots_indicator/dots_indicator.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';

class MyDots extends DotsIndicator {
  MyDots({super.key, required super.dotsCount, required int position})
    : super(
        position: position.toDouble(),
        decorator: DotsDecorator(activeColor: ConstantesCouleurs.rouge),
      );
}
