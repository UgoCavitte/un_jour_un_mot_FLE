import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';

class IconCheckAnimee extends StatefulWidget {
  const IconCheckAnimee({super.key});

  @override
  State<StatefulWidget> createState() => _IconCheckAnimeeState();
}

class _IconCheckAnimeeState extends State<IconCheckAnimee>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // De 0 à 1
  double prog = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.addListener(_update);
    _controller.forward();
  }

  void _update() {
    setState(() {
      prog = _controller.value;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (prog < 0.5) {
      return Transform.rotate(
        angle: (prog / 0.5) * 2 * math.pi,
        child: Icon(
          Icons.check_circle,
          color: ConstantesCouleurs.vert,
          size: prog / 0.5 * 50,
        ),
      );
    } else if (prog < 1) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70 * prog,
            height: 70 * prog,
            decoration: BoxDecoration(
              color: Color.fromARGB(
                (1 / prog * 256).round(),
                ConstantesCouleurs.vert.r.toInt(),
                ConstantesCouleurs.vert.g.toInt(),
                ConstantesCouleurs.vert.b.toInt(),
              ),
              shape: BoxShape.circle,
            ),
          ),

          // Le container blanc permet de régler le problème de la partie
          // transparente de l'icône
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          Icon(Icons.check_circle, color: ConstantesCouleurs.vert, size: 50),
        ],
      );
    } else {
      return Icon(
        Icons.check_circle,
        color: ConstantesCouleurs.vert,
        size: prog * 50,
      );
    }
  }
}
