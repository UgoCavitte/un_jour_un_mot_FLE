import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_icones.dart';
import 'package:un_jour_un_mot/constantes/constantes_textes.dart';
import 'package:un_jour_un_mot/data/data.dart';
import 'package:un_jour_un_mot/data/gestion_memoire.dart';
import 'package:un_jour_un_mot/main.dart';
import 'package:un_jour_un_mot/pages/page_home.dart';

const _bodyStyle = TextStyle(fontSize: 19.0);

PageDecoration _pageDecoration = PageDecoration(
  titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
  bodyTextStyle: _bodyStyle,
  bodyPadding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
  pageColor: ConstantesCouleurs.blanc,
  imagePadding: EdgeInsets.zero,
);

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<StatefulWidget> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  void _onIntroEnd(BuildContext context) {
    GestionMemoire.enregistrerTutoriel(false);
    Data.tutorielDebut = false;

    // Si le tutoriel est lancé pendant le chargement (et pas depuis les paramètres), on termine le chargement
    if (Data.loadingStatus == LoadingStatus.tutoriel) {
      context.read<ProviderLoading>().nextStep();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder:
              (context) => ChangeNotifierProvider(
                create: (_) => ProviderPageHome(),
                child: SafeArea(child: PageHome(index: 0)),
              ),
        ),
        (_) => false,
      );
    }
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: ConstantesCouleurs.blanc,
      onDone: () => _onIntroEnd(context),
      showBackButton: true,
      back: ConstantesIcones.iconeBackBleue,
      next: ConstantesIcones.iconeNextBleue,
      done: const Text(
        stringFinir,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      safeAreaList: const [true, true, true, true],
      pages: [
        PageViewModel(
          title: "Bienvenue !",
          image: _buildImage("on_boarding/picture_1.jpg"),
          decoration: _pageDecoration,
          body:
              "Bienvenue dans l'application \"Un jour un mot FLE\" !\nCette application est principalement destinée aux étrangers souhaitant élargir leur vocabulaire français.\nChaque jour, vous apprendrez un nouveau mot (généralement un nom commun) grâce à différentes activités.",
        ),
        PageViewModel(
          title: "Amusez-vous bien !",
          image: _buildImage("on_boarding/picture_4.jpg"),
          decoration: _pageDecoration,
          body:
              "Si vous souhaitez revoir ce tutoriel, cela est possible dans les paramètres.\nSi vous rencontrez le moindre problème, n'hésitez pas à me contacter !",
        ),
      ],
    );
  }
}
