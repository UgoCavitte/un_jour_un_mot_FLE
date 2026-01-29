import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/activites/moteur_activites_mots.dart';
import 'package:un_jour_un_mot/ads/ads.dart';
import 'package:un_jour_un_mot/composants/my_buttons.dart';
import 'package:un_jour_un_mot/composants/my_dividers.dart';
import 'package:un_jour_un_mot/composants/my_flush_bars.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/composants/page_mots/carte_mot_a_afficher.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';
import 'package:un_jour_un_mot/constantes/constantes_textes.dart';
import 'package:un_jour_un_mot/data/data.dart';
import 'package:un_jour_un_mot/data/stats.dart';
import 'package:un_jour_un_mot/global_providers/provider_connect.dart';
import 'package:un_jour_un_mot/global_providers/provider_loaded_banner.dart';
import 'package:un_jour_un_mot/misc/dates.dart';
import 'package:un_jour_un_mot/objects/mot.dart';
import 'package:un_jour_un_mot/pages/page_home.dart';

class PageMots extends StatelessWidget {
  const PageMots({super.key});

  @override
  Widget build(BuildContext context) {
    ProviderConnect providerConnect = context.watch<ProviderConnect>();
    context.watch<ProviderAdBanner>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Haut avec les infos sur l'utilisateur
        if (providerConnect.isUserConnected)
          _carteUtilisateur(providerConnect)
        else if (providerConnect.isUserConnecting)
          _connexionEnCours()
        else
          _boutonConnexion(providerConnect),

        // Publicité bannière
        _pub(context),

        // Liste des mots faits et à faire
        Expanded(child: CarteMotsAAfficher()),

        // Bouton "faire le mot du jour"
        _boutonMotDuJour(context),
      ],
    );
  }

  Widget _carteUtilisateur(ProviderConnect providerConnect) {
    return Container(
      alignment: Alignment.center,
      padding: ConstantesPaddingMargin.paddingGeneralElements,
      margin: ConstantesPaddingMargin.marginGeneralElements,
      decoration: BoxDecoration(
        gradient: ConstantesCouleurs.gradientBleuBleuClair,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Colonne avec les infos du compte
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MyTextGeneral(
                    color: ConstantesCouleurs.blanc,
                    providerConnect.currentUser?.displayName ??
                        stringNomInconnu,
                  ),
                  MyTextGeneral(
                    color: ConstantesCouleurs.blanc,
                    providerConnect.currentUser?.email ?? stringMailInconnu,
                  ),
                  MyTextGeneral(
                    color: ConstantesCouleurs.blanc,
                    Data.isPremium ? stringPremium : stringNonPremium,
                  ),
                ],
              ),
            ),
            // Ligne séparatrice
            MyVerticalDivider(color: ConstantesCouleurs.blanc),

            // Stats de l'utilisateur
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Nombre de mots devinés par l'utlisateur
                  MyTextGeneral(
                    color: ConstantesCouleurs.blanc,
                    "Mots devinés : ${Stats.nbrMotsDevines}",
                  ),

                  // Nombre de mots faits par l'utilisateur
                  MyTextGeneral(
                    color: ConstantesCouleurs.blanc,
                    "Mots essayés : ${Stats.nbrMotsEssayes}",
                  ),

                  // Ratio
                  MyTextGeneral(
                    color: ConstantesCouleurs.blanc,
                    "Ratio : ${Stats.ratio} %",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _connexionEnCours() {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextGeneral(
              color: ConstantesCouleurs.rouge,
              stringConnexionEnCours,
            ),
            SizedBox(height: ConstantesPaddingMargin.espaceEntreTitreEtSuite),
            CircularProgressIndicator(color: ConstantesCouleurs.rouge),
          ],
        ),
      ),
    );
  }

  Widget _boutonConnexion(ProviderConnect providerConnect) {
    return SizedBox(
      width: double.infinity,
      child: MyButton(
        texte: stringSeConnecter,
        couleur: MyButtonColor.gradientRouge,
        onPressed: () async {
          await providerConnect.connectUser();
        },
      ),
    );
  }

  // TODO
  Widget _boutonMotDuJour(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MyButton(
        texte: stringFaireLeMotDuJour,
        couleur: MyButtonColor.gradientBleu,
        onPressed: () async {
          try {
            // Trouve le mot avec la date du jour
            MotNouveau motDuJour = Data.listeMots.firstWhere(
              (test) =>
                  Dates.comparerDates(
                    dateRef: test.date,
                    dateChecked: DateTime.now(),
                  ) ==
                  ComparaisonDates.egal,
            );

            // Vérifie que l'utilisateur est connecté
            if (!Provider.of<ProviderConnect>(
              context,
              listen: false,
            ).isUserConnected) {
              if (await confirm(
                    context,
                    content: MyTextGeneral(stringObligationConnexion),
                    textOK: MyTextGeneralTitre(stringCompris),
                    textCancel: MyTextGeneralTitre(""),
                  ) &&
                  context.mounted) {
                return;
              }
            }

            // Lancement
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (_) => ProviderMoteurActiviteMots(),
                        ),
                      ],
                      child: MoteurActivitesMots(mot: motDuJour),
                    ),
              ),
            );
          } catch (e) {
            MyFlushBar(
              message: FlushBarMessage.pasDeMotDuJour,
              typeMessage: FlushBarTypeMessage.rouge,
            ).show();
          }
        },
      ),
    );
  }

  Widget _pub(BuildContext context) {
    // Si l'onglet n'est pas actif
    if (Provider.of<ProviderPageHome>(context).index != 0) {
      return AdBanner.showWhenNotLoaded();
    }

    if (AdBanner.statutPub != StatutPub.loaded) {
      AdBanner.load(context);
      return AdBanner.showWhenNotLoaded();
    }

    return Expanded(child: AdBanner.show());
  }
}

class ProviderPageMots with ChangeNotifier {}
