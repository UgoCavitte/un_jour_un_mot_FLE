import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/composants/container_produit.dart';
import 'package:un_jour_un_mot/composants/my_buttons.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';
import 'package:un_jour_un_mot/constantes/constantes_textes.dart';
import 'package:un_jour_un_mot/data/data.dart';
import 'package:un_jour_un_mot/data/db_consts.dart';
import 'package:un_jour_un_mot/data/init_firebase.dart';
import 'package:un_jour_un_mot/firebase_options.dart';
import 'package:un_jour_un_mot/global_providers/provider_connect.dart';
import 'package:un_jour_un_mot/objects/produit_paypal.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

const String _idPremium = "jour_mot_premium";
const String _currencyEUR = "EUR";

class PageBoutique extends StatelessWidget {
  const PageBoutique({super.key});

  /*
   * Il faut prévoir plusieurs situations :
   * - l'utilisateur n'est pas connecté
   * - l'utilisateur est connecté, mais la boutique est indisponible
   * - l'utilisateur est connecté, et la boutique est disponible
   */

  @override
  Widget build(BuildContext context) {
    ProviderConnect providerConnect = context.watch<ProviderConnect>();
    ProviderPageBoutique providerPageBoutique =
        context.watch<ProviderPageBoutique>();

    // Initialisation
    if (!providerPageBoutique.initialise) providerPageBoutique.initialisation();

    // L'utilisateur n'est pas connecté et ne se connecte pas
    if (!providerConnect.isUserConnected && !providerConnect.isUserConnecting) {
      return Center(
        child: MyButton(
          onPressed: () async {
            await providerConnect.connectUser();
          },
          texte: stringSeConnecter,
          couleur: MyButtonColor.rougePlein,
        ),
      );
    }

    // L'utilisateur est en train de se connecter
    if (providerConnect.isUserConnecting) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextGeneral(
              color: ConstantesCouleurs.bleu,
              stringConnexionEnCours,
            ),
            SizedBox(height: ConstantesPaddingMargin.espaceEntreTitreEtSuite),
            CircularProgressIndicator(color: ConstantesCouleurs.bleu),
          ],
        ),
      );
    }

    // L'utilisateur est connecté
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getTitre(),

        _getContenuBoutique(
          providerPageBoutique: providerPageBoutique,
          context: context,
        ),

        const Spacer(),

        _getCarteUtilisateur(providerConnect),
      ],
    );
  }

  Widget _getTitre() {
    return MyTextGeneralTitre(nomPageBoutique);
  }

  // TODO -> gérer les différents statuts de la boutique
  Widget _getContenuBoutique({
    required ProviderPageBoutique providerPageBoutique,
    required BuildContext context,
  }) {
    List<Widget> toShow = [];

    if (kIsWeb) {
      toShow.add(
        Center(
          child: MyTextGeneral(
            textAlign: TextAlign.center,
            "La boutique n'est disponible que sur l'application Android pour le moment. Je travaille sur le développement de la boutique pour les autres plateformes.",
          ),
        ),
      );
    }
    
    // PayPal
    /*if (kIsWeb) {
      for (var produit in providerPageBoutique.productsPayPal) {
        toShow.add(
          ContainerAchat(
            name: produit.name,
            description: produit.description,
            price: produit.price,
            currency: _currencyEUR,
            dejaAchete: Data.isPremium,
            callBack:
                () =>
                    providerPageBoutique.handlePaymentPayPal(context: context),
          ),
        );
      }
    }*/
    // Android
    if (defaultTargetPlatform == TargetPlatform.android) {
      for (var produit in providerPageBoutique.productsGP) {
        toShow.add(
          ContainerAchat(
            name: produit.title,
            description: produit.description,
            price: produit.price,
            currency: produit.currencySymbol,
            dejaAchete: Data.isPremium,
            callBack: () => providerPageBoutique.buyProductGP(produit),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: toShow,
    );
  }

  Widget _getCarteUtilisateur(ProviderConnect providerConnect) {
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          top: BorderSide(color: ConstantesCouleurs.bleu, width: 3),
        ),
      ),
      child: Row(
        children: [
          // Info sur l'utilisateur
          Expanded(
            flex: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextGeneral(
                  providerConnect.currentUser != null
                      ? providerConnect.currentUser!.displayName ?? "Anonyme"
                      : "Utilisateur non connecté",
                ),
                MyTextGeneral(
                  providerConnect.currentUser != null
                      ? providerConnect.currentUser!.email ?? "Email inconnu"
                      : "Utilisateur non connecté",
                ),
                if (Data.isPremium) MyTextGeneral("Utilisateur premium"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProviderPageBoutique with ChangeNotifier {
  bool initialise = false;

  // Connexion à l'interface
  InAppPurchase iap = InAppPurchase.instance;

  // Disponible ?
  bool available = true;

  // Produits
  List<ProductDetails> productsGP = [];
  List<ProduitPayPal> productsPayPal = [];

  // Achats passés
  List<PurchaseDetails> purchasesGP = [];

  // Listener
  late StreamSubscription<List<PurchaseDetails>> subscription;

  /////////////////////////////////////////////////////////////////////////////
  /// Général
  /////////////////////////////////////////////////////////////////////////////

  void initialisation() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Fetches products
    if (kIsWeb) {
      _getProductsPayPal(); // TODO WEB
    } else {
      available = await iap.isAvailable();

      if (available) {
        subscription = iap.purchaseStream.listen((data) {
          purchasesGP.addAll(data);
          _verifyPurchases();
          notifyListeners();
        });
      }

      await _getProductsGP();
    }

    initialise = true;
    notifyListeners();
  }

  /////////////////////////////////////////////////////////////////////////////
  /// Spécifique à Google Play pour Android
  /////////////////////////////////////////////////////////////////////////////

  // Fetches available products from Google Play
  Future<void> _getProductsGP() async {
    Set<String> ids = {_idPremium};
    ProductDetailsResponse response = await iap.queryProductDetails(ids);

    productsGP = response.productDetails;

    notifyListeners();
  }

  // Vérifie si le produit donné a été acheté
  PurchaseDetails? _hasPurchased(String productID) {
    try {
      return purchasesGP.firstWhere(
        (purchase) => purchase.productID == productID,
      );
    } catch (e) {
      return null;
    }
  }

  // Vérifie que l'achat a bien été fait et terminé
  void _verifyPurchases() {
    // Il n'y a qu'un seul produit, donc pas besoin de faire des listes
    PurchaseDetails? purchase = _hasPurchased(_idPremium);

    if (purchase != null && (purchase.status == PurchaseStatus.purchased)) {
      Data.isPremium = true;
      iap.completePurchase(purchase);
      InitFirebase.setPrem(true);
    } else if (purchase != null) {
      Data.isPremium = false;
    }
  }

  // Ouvre la fenêtre
  void buyProductGP(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /////////////////////////////////////////////////////////////////////////////
  /// Spécifique à Paypal
  /////////////////////////////////////////////////////////////////////////////

  // Fetches from database
  Future<void> _getProductsPayPal() async {
    // On commence par vérifier que l'utilisateur est connecté et existe
    if (FirebaseAuth.instance.currentUser == null) {
      debugPrintStack(
        label: "[app] User is not connected or Google SignIn account is null",
      );
      return;
    }

    // S'il est connecté, on vérifie qu'il a un fichier
    await InitFirebase.doesUserExists();

    // Récupère les données sur les produits
    QuerySnapshot<Map<String, dynamic>> retrieved =
        await InitFirebase.dataBase.collection(DbConsts.idProducts).get();

    // Remplit la map des produits PayPal
    for (var element in retrieved.docs) {
      productsPayPal.add(
        ProduitPayPal(
          id: element.id,
          name: element[DbConsts.idName],
          description: element[DbConsts.idDescription],
          price: ((int.parse(element[DbConsts.idPrice]) / 100).toString()),
        ),
      );
    }

    notifyListeners();
  }

  Future<void> handlePaymentPayPal({required BuildContext context}) async {
    
    if (await confirm(
      context,
      content: MyTextGeneral(stringPaiementWeb),
      textOK: MyTextGeneralTitre(stringCompris),
      textCancel: MyTextGeneralTitre(stringAnnuler),
    )) {
      try {
        // Token
        final String? idToken =
            await FirebaseAuth.instance.currentUser!.getIdToken();

        if (idToken == null) {
          // TODO flushbar
          debugPrintStack(label: "[app] -> Retrieving user's idToken failed");
          return;
        }

        final String price = productsPayPal[0].price;
        final String itemId = productsPayPal[0].id;

        final Uri paymentUri = Uri.https('francaisfrancuz.com', 'un_jour_un_mot_paiement.html', {'idToken': idToken, 'price': price, 'itemId': itemId});

        debugPrintStack(label: "[app] -> Attempting to launch URL: $paymentUri");

        // Lancement de la page
        if (!await launchUrl(
          paymentUri,
          mode: LaunchMode.externalApplication
        )) {
          // TODO -> flushbar
          debugPrintStack(label: "[app] -> Launching URL failed");
        }

      }

    catch (e) {
      debugPrintStack(label: "[app] -> An error occured while retrieving user's idToken or launching URL $e");
    }
      
    }

    // Annulation
    return;

  }
}
