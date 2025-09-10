import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:un_jour_un_mot/ads/consentement/initialize_screen.dart';
import 'package:un_jour_un_mot/composants/container_titre.dart';
import 'package:un_jour_un_mot/composants/my_buttons.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';
import 'package:un_jour_un_mot/constantes/constantes_textes.dart';
import 'package:un_jour_un_mot/pages/on_boarding.dart';

/*
 * Ce menu permet de :
 * - revoir le mot de bienvenue ;
 * - changer les paramètres de confidentialité ;
 * - voir mes contacts.
 */

class MenuParametres extends StatelessWidget {
  const MenuParametres({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstantesCouleurs.blanc,
        appBar: AppBar(
          title: MyTitreAppBar(titreParametres),
          centerTitle: true,
          foregroundColor: ConstantesCouleurs.blanc,
          backgroundColor: ConstantesCouleurs.bleu,
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            _getBoutonBienvenue(context),
            if (!kIsWeb) _getBoutonConfidentialite(context),
            _getContacts(),
          ],
        ),
      ),
    );
  }

  Widget _getBoutonBienvenue(BuildContext context) {
    return MyButton(
      texte: stringRevoirTuto,
      onPressed:
          () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => OnBoarding())),
    );
  }

  Widget _getBoutonConfidentialite(BuildContext context) {
    // Android
    return Padding(
      padding: ConstantesPaddingMargin.paddingGeneralElements,
      child: MyButton(
        texte:
            "Changer les règles de confidentialité\n(only for EEA countries)",
        onPressed: () {
          ConsentInformation.instance.reset();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InitializeScreen(thenPop: true),
            ),
          );
        },
      ),
    );
  }

  Widget _getContacts() {
    return Padding(
      padding: ConstantesPaddingMargin.paddingGeneralElements,
      child: ContainerTitre(
        title: "Me contacter",
        childWidget: textParametresContacts,
      ),
    );
  }
}

class ProviderMenuParametres with ChangeNotifier {
  //
}
