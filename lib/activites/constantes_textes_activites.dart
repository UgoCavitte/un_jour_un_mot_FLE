// Introduction
import 'package:flutter/widgets.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_padding_margin.dart';
import 'package:un_jour_un_mot/constantes/constantes_textes.dart';

const String texteIntroTitre =
    "Bienvenue dans ce module pour le mot numéro ";
const String texteIntroExplication =
    "Ce module comprend différentes activités. Vous devrez d'abord deviner le mot via un pendu, puis vous aurez des explications à son sujet, et enfin des activités permettant de le mémoriser.";
const String texteIntroAppuyez = "Appuyez sur le bouton pour commencer !";
const String texteIntroSuivant = "Suivant";

// Pendu
const String textePenduVerifier = "Vérifier";
const String textePenduSuite = "Suite";
const String textePenduBoutonAbandonner = "Abandonner";
const String textePenduBoutonPrincipes = "Principes";
const String textePenduConfirmContent =
    "Êtes-vous sûr de vouloir entrer un mot au lieu d'une lettre ?";
const String textePenduConfirmationAbandon =
    "Êtes-vous sûr de vouloir abandonner ?";

// Explication
const String texteExplicationSuite = "Suite";

// Jeu compléter
const String texteCompleterConsigne =
    "Complétez le mot avec les lettres proposées";
const String texteCompleterSuite = "Suite";

// Jeu trouve orthographe
const String texteTrouveOrthographeConsigne =
    "Retrouvez la bonne orthographe du mot";
const String texteTrouveOrthographeSuite = "Suite";

// Jeu réécrire
const String texteReecrireConsigne =
    "Réécrivez le mot avec les lettres proposées";

// Fin
const String texteFiniSortir = "Sortir";
const String texteFiniTitre = "Et c'est fini pour le mot numéro ";
const String texteFiniCorps1 = 'Bravo ! Vous avez appris un nouveau mot, "';
const String texteFiniCorps2 = '" !';

// Textes plus gros

// Principes du pendu
const String titrePrincipesPendu = "Principes du pendu";
RichText principesPendu = RichText(
  softWrap: true,
  textAlign: TextAlign.justify,
  text: TextSpan(
    style: TextStyle(
      fontSize: fontSizeStandard,
      color: ConstantesCouleurs.bleu,
    ),

    children: [
      TextSpan(
        text:
            "1. Ce jeu est un pendu : il faut deviner le mot en proposant des lettres ou des mots.\n",
      ),
      ConstantesPaddingMargin.espaceRichTextSpan,
      TextSpan(
        text:
            "2. Si vous proposez une lettre et qu'elle est dans le mot à deviner, alors elle s'affichera ; sinon, vous perdrez une vie (voir illustration) et la lettre fausse s'affichera dans la colonne de gauche.\n",
      ),
      ConstantesPaddingMargin.espaceRichTextSpan,
      TextSpan(
        text:
            "3. Si vous proposez un mot et que ce mot est le mot à deviner, alors la partie se terminera sur une victoire ; sinon, vous perdrez une vie (voir illustration) et le mot faux s'affichera dans la colonne de droite. Attention, le jeu ne vérifie pas les lettres communes entre un mot proposé faux et le mot : proposer des mots ne permet pas de deviner des lettres.\n",
      ),
      ConstantesPaddingMargin.espaceRichTextSpan,
      TextSpan(
        text:
            "4. Le jeu ne prend en compte ni les accents, ni les majuscules : É = e = è = Ê.\n",
      ),
      ConstantesPaddingMargin.espaceRichTextSpan,
      TextSpan(
        text:
            "5. Les voyelles sont marquées en rouge, les consonnes en bleu.\n",
      ),
      ConstantesPaddingMargin.espaceRichTextSpan,
      TextSpan(
        text:
            '6. Si vous n\'arrivez pas à trouver le mot, vous pouvez appuyer sur le bouton "$textePenduBoutonAbandonner" en bas à gauche.',
      ),
    ],
  ),
);
