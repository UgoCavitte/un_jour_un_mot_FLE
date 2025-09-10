import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/activites/pages/explication.dart';
import 'package:un_jour_un_mot/activites/pages/fin.dart';
import 'package:un_jour_un_mot/activites/pages/introduction.dart';
import 'package:un_jour_un_mot/activites/pages/jeu_completer.dart';
import 'package:un_jour_un_mot/activites/pages/jeu_reecrire.dart';
import 'package:un_jour_un_mot/activites/pages/jeu_trouve_orthographe.dart';
import 'package:un_jour_un_mot/activites/pages/pendu.dart';
import 'package:un_jour_un_mot/ads/ads.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_icones.dart';
import 'package:un_jour_un_mot/constantes/constantes_textes.dart';
import 'package:un_jour_un_mot/data/data.dart';
import 'package:un_jour_un_mot/data/init_firebase.dart';
import 'package:un_jour_un_mot/misc/dates.dart';
import 'package:un_jour_un_mot/objects/mot.dart';
import 'package:un_jour_un_mot/pages/page_home.dart';

class MoteurActivitesMots extends StatelessWidget {
  final Mot mot;

  const MoteurActivitesMots({super.key, required this.mot});

  @override
  Widget build(BuildContext context) {
    // Ce qu'il faut afficher
    Widget toShow;

    // Gère ce qu'il faut afficher
    switch (context.watch<ProviderMoteurActiviteMots>().etapeActivite) {
      case EtapeActivite.introduction:
        toShow = Introduction(mot: mot);
        break;

      case EtapeActivite.pendu:
        AdInterstital.load(); // Charge une pub interstielle avant le pendu pour la montrer pendant la transition vers les explications

        toShow = ChangeNotifierProvider(
          create: (_) => ProviderPendu(),
          child: Pendu(mot: mot),
        );
        break;

      case EtapeActivite.explication:
        AdInterstital.show(); // Montre la pub interstielle
        toShow = Explication(mot: mot);
        break;

      case EtapeActivite.jeuCompleter:
        toShow = ChangeNotifierProvider(
          create: (_) => ProviderJeuCompleter(),
          child: JeuCompleter(mot: mot),
        );
        break;

      case EtapeActivite.jeuTrouveOrthographe:
        toShow = ChangeNotifierProvider(
          create: (_) => ProviderJeuTrouveOrthographe(),
          child: JeuTrouveOrthographe(mot: mot),
        );
        break;

      case EtapeActivite.jeuReecrireAvecLettres:
        AdInterstital.load();
        toShow = ChangeNotifierProvider(
          create: (_) => ProviderJeuReecrire(),
          child: JeuReecrire(mot: mot),
        );
        break;

      case EtapeActivite.fin:
        AdInterstital.show();
        toShow = Fin(mot: mot);
        break;
    }

    // Intégrer ce widget dans un scaffold avec tout le nécessaire
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstantesCouleurs.blanc,
        appBar: AppBar(
          title: MyTitreAppBar(_getTitreAppBarActivite()),
          centerTitle: true,
          foregroundColor: ConstantesCouleurs.blanc,
          backgroundColor: ConstantesCouleurs.bleu,
          leading: IconButton(
            onPressed: () => _backButton(context),
            icon: ConstantesIcones.iconeBack,
            tooltip: stringBack,
          ),
        ),
        body: toShow,
      ),
    );
  }

  String _getTitreAppBarActivite() {
    return "Mot du jour - ${Dates.formaterDatePourAffichage(mot.date)}";
  }

  void _backButton(BuildContext context) async {
    ProviderMoteurActiviteMots provider =
        Provider.of<ProviderMoteurActiviteMots>(context, listen: false);

    var nav = Navigator.of(context);

    // Si l'utilisateur n'est qu'à l'introduction
    if (provider.etapeActivite == EtapeActivite.introduction) {
      if (await confirm(
        context,
        content: MyTextGeneral(stringConfirmationSortirIntroduction),
        textOK: MyTextGeneralTitre(stringOui),
        textCancel: MyTextGeneralTitre(stringAnnuler),
      )) {
        nav.pushAndRemoveUntil(
          MaterialPageRoute(
            builder:
                (context) => ChangeNotifierProvider(
                  create: (_) => ProviderPageHome(),
                  child: SafeArea(child: PageHome(index: 0)),
                ),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        return;
      }
    }
    // Si l'utilisateur en est au pendu
    else if (provider.etapeActivite == EtapeActivite.pendu) {
      if (await confirm(
        context,
        content: MyTextGeneral(stringConfirmationSortirPendu),
        textOK: MyTextGeneralTitre(stringOui),
        textCancel: MyTextGeneralTitre(stringAnnuler),
      )) {
        // Met à jour la liste qu'utilise l'appli
        Data
            .listeMots
            .firstWhere((motDeLaListe) => motDeLaListe.date == mot.date)
            .fait = MotStatut.rate;

        // Met à jour la liste utilisée pour la sauvegarde sur la DB
        Data.listeMotsUser.addEntries([
          MapEntry<DateTime, bool>(mot.date, false),
        ]);

        // Puis on fait la sauvegarde
        await InitFirebase.enregistrerMotsFaits();

        // Utiliser cette fonction plutôt que "pop" permet de rafraîchir la page
        nav.pushAndRemoveUntil(
          MaterialPageRoute(
            builder:
                (context) => ChangeNotifierProvider(
                  create: (_) => ProviderPageHome(),
                  child: SafeArea(child: PageHome(index: 0)),
                ),
          ),
          (_) => false,
        );
      } else {
        return;
      }
    }
    // Dans tous les autres cas
    else {
      if (await confirm(
        context,
        content: MyTextGeneral(stringConfirmationSortirAutre),
        textOK: MyTextGeneralTitre(stringOui),
        textCancel: MyTextGeneralTitre(stringAnnuler),
      )) {
        // Utiliser cette fonction plutôt que "pop" permet de rafraîchir la page
        nav.pushAndRemoveUntil(
          MaterialPageRoute(
            builder:
                (context) => ChangeNotifierProvider(
                  create: (_) => ProviderPageHome(),
                  child: SafeArea(child: PageHome(index: 0)),
                ),
          ),
          (_) => false,
        );
      } else {
        return;
      }
    }
  }
}

enum EtapeActivite {
  introduction, // Infos sur la date etc.
  pendu, // Jeu de pendu
  explication, // Définition etc.
  jeuCompleter, // Compléter le mot avec les lettres proposées
  jeuTrouveOrthographe, // Retrouver la bonne orthographe dans une liste
  jeuReecrireAvecLettres, // Réécrire le mot entièrement avec les lettres proposées
  fin, // Écran de fin
}

class ProviderMoteurActiviteMots with ChangeNotifier {
  EtapeActivite etapeActivite = EtapeActivite.introduction;

  void etapeSuivante() {
    switch (etapeActivite) {
      case EtapeActivite.introduction:
        etapeActivite = EtapeActivite.pendu;
        break;
      case EtapeActivite.pendu:
        etapeActivite = EtapeActivite.explication;
        break;
      case EtapeActivite.explication:
        etapeActivite = EtapeActivite.jeuCompleter;
        break;
      case EtapeActivite.jeuCompleter:
        etapeActivite = EtapeActivite.jeuTrouveOrthographe;
        break;
      case EtapeActivite.jeuTrouveOrthographe:
        etapeActivite = EtapeActivite.jeuReecrireAvecLettres;
        break;
      case EtapeActivite.jeuReecrireAvecLettres:
        etapeActivite = EtapeActivite.fin;
        break;
      case EtapeActivite.fin: // Rien, ce cas n'est jamais rencontré
        break;
    }

    notifyListeners();
  }
}
