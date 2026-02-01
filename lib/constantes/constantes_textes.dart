import 'package:flutter/widgets.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';

const double fontSizeStandard = 15;

TextStyle textStyleGeneralTitre = TextStyle(
  color: ConstantesCouleurs.bleu,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);
TextStyle textStyleTitreAppBar = TextStyle(
  color: ConstantesCouleurs.blanc,
  fontSize: 18,
);
TextStyle textStyleBoutons = TextStyle(
  color: ConstantesCouleurs.blanc,
  fontSize: 15,
  fontWeight: FontWeight.bold,
);
TextStyle textStyleLigneTableau = TextStyle(
  color: ConstantesCouleurs.bleu,
  fontSize: fontSizeStandard,
);
TextStyle textStyleLettrePenduVoyelle = TextStyle(
  color: ConstantesCouleurs.rouge,
  fontSize: fontSizeStandard * 2,
);
TextStyle textStyleLettrePenduConsonne = TextStyle(
  color: ConstantesCouleurs.bleu,
  fontSize: fontSizeStandard * 2,
);
TextStyle textStyleLettreFaussePendu = TextStyle(
  color: ConstantesCouleurs.bleu,
  fontSize: 20,
);
TextStyle textStyleItalique = TextStyle(
  color: ConstantesCouleurs.bleu,
  fontSize: fontSizeStandard,
  fontStyle: FontStyle.italic,
);
TextStyle textStyleGrosTitreMajuscules = TextStyle(
  color: ConstantesCouleurs.bleu,
  fontSize: fontSizeStandard * 3,
  fontWeight: FontWeight.bold,
);

const String stringMotPasFait = "***";

// Titres
const String titreAppli = "Un jour, un mot";
const String tooltipParametres = "Paramètres";
const String nomPageBoutique = "Boutique";
const String titreParametres = "Paramètres";
const String nomPageHome = "Mots";

// Écrans de chargement
const String stringChargementCheckingTutorial =
    "Lecture des données inscrites sur le téléphone...";
const String stringChargementFetchingWords = "Téléchargement des mots...";
const String stringChargementAutoConnect =
    "Connexion automatique de l'utilisateur...";
const String stringChargementRGPD =
    "Vérification du consentement en application du RGPD...";

// Reste
const String stringFinir = "Finir";
const String stringSeConnecter = "Se connecter";
const String stringConnexionEnCours = "Connexion en cours...";
const String stringFaireLeMotDuJour = "Faire le prochain mot disponible";
const String stringVeuillezVousConnecter =
    "Veuillez vous connecter pour avoir accès aux différents mots du jour";
const String stringOui = "Oui";
const String stringCompris = "Compris";
const String stringAnnuler = "Annuler";
const String stringNomInconnu = "Nom inconnu";
const String stringMailInconnu = "Mail inconnu";
const String stringPremium = "Premium";
const String stringNonPremium = "Non premium";
const String stringBack = "Sortir";
const String stringRevoirTuto = "Revoir le tutoriel de bienvenue";
const String stringConfirmationSortirIntroduction =
    "Êtes-vous sûr de vouloir sortir ? Vous n'êtes qu'à l'introduction, le mot ne sera pas marqué comme fait. Vous pourrez relancer ce mot plus tard dans la journée si vous le voulez.";
const String stringConfirmationSortirPendu =
    "Êtes-vous sûr de vouloir sortir ? Vous êtes à l'étape du pendu, le mot sera marqué comme fait et raté. Vous ne pourrez pas le relancer si vous n'êtes pas un utilisateur premium.";
const String stringConfirmationSortirAutre =
    "Êtes-vous sûr de vouloir sortir ? Le résultat du pendu sera sauvegardé et vous ne pourrez pas relancer ce mot si vous n'êtes pas un utilisateur premium.";
const String stringObligationConnexion =
    "Veuillez d'abord vous connecter en cliquant sur le gros bouton rouge";
const String stringPaiementWeb =
    "Pour cette version de l;application, les paiements se font directement sur le site. En cliquant sur \"Compris\", vous serez redirigé sur la page de paiement avec vos données d'utilisateur.\nVous pouvez annuler en cliquant sur \"Annuler\".";
const String stringLimiteQuotidienne = "Vous avez déjà fait un mot aujourd'hui. Vous pouvez acheter le statut premium à vie ou bien revenir demain ;)";

RichText textParametresContacts = RichText(
  textAlign: TextAlign.center,
  text: TextSpan(
    children: [
      TextSpan(
        style: TextStyle(color: ConstantesCouleurs.bleu),
        text: "Telegram : @ucavitte / @francaisugo\n",
      ),
      TextSpan(
        style: TextStyle(color: ConstantesCouleurs.bleu),
        text: "Mail : contact@ugocavitte.com\n",
      ),
      TextSpan(
        style: TextStyle(color: ConstantesCouleurs.bleu),
        text: "Site de développeur : ugocavitte.com\n",
      ),
      TextSpan(
        style: TextStyle(color: ConstantesCouleurs.bleu),
        text: "Site de professeur : francaisfrancuz.com",
      ),
    ],
  ),
);
