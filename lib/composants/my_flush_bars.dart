import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';

enum FlushBarMessage {
  penduLettreDejaProposeeEtFausse,
  penduLettreDejaProposeeEtBonne,
  penduMotDejaPropose,
  penduLettreBonne,
  penduLettreFausse,
  penduMotFaux,
  pasDeMotDuJour,
  erreurDeConnexion,
  failedToCreatePaymentIntent,
  erreurChargementMots
}

// Map des messages
const Map _messageToText = {
  FlushBarMessage.penduLettreDejaProposeeEtFausse:
      _stringPenduLettreDejaProposeeEtFausse,
  FlushBarMessage.penduLettreDejaProposeeEtBonne:
      _stringPenduLettreDejaProposeeEtBonne,
  FlushBarMessage.penduMotDejaPropose: _stringPenduMotDejaPropose,
  FlushBarMessage.penduLettreBonne: _stringPenduLettreBonne,
  FlushBarMessage.penduLettreFausse: _stringPenduLettreFausse,
  FlushBarMessage.penduMotFaux: _stringPenduMotFaux,
  FlushBarMessage.pasDeMotDuJour: _stringPasDeMotDuJour,
  FlushBarMessage.erreurDeConnexion: _stringErreurDeConnexion,
  FlushBarMessage.erreurChargementMots: _stringErreurChargementMots,
};

// Messages
const String _stringPenduLettreDejaProposeeEtFausse =
    "Vous avez déjà proposé cette lettre, elle n'est pas dans le mot";
const String _stringPenduLettreDejaProposeeEtBonne =
    "Vous avez déjà proposé cette lettre, elle est dans le mot";
const String _stringPenduMotDejaPropose = "Vous avez déjà proposé ce mot";
const String _stringPenduLettreBonne = "Lettre bonne !";
const String _stringPenduLettreFausse = "Lettre fausse";
const String _stringPenduMotFaux = "Mot faux";
const String _stringPasDeMotDuJour = "Aucun mot n'est disponible pour le moment. Vous avez tout fait, bravo !";
const String _stringErreurDeConnexion = "Connexion impossible.";
const String _stringErreurChargementMots = "Erreur lors du chargement des mots.";

// Permet de choisir la couleur et la durée
enum FlushBarTypeMessage { classique, rouge, vert }

Map _typeToCouleur = {
  FlushBarTypeMessage.classique: ConstantesCouleurs.grisClair,
  FlushBarTypeMessage.vert: _flushBarCouleurVert,
  FlushBarTypeMessage.rouge: _flushBarCouleurRouge,
};

const Map _typeToDuration = {
  FlushBarTypeMessage.classique: Duration(seconds: 3),
  FlushBarTypeMessage.vert: Duration(seconds: 1),
  FlushBarTypeMessage.rouge: Duration(seconds: 1),
};

// Couleurs
const Color _flushBarCouleurVert = Colors.lightGreenAccent;
const Color _flushBarCouleurRouge = Colors.redAccent;

class MyFlushBar extends FlashyFlushbar {
  MyFlushBar({
    required FlushBarMessage message,
    String? complement,
    FlushBarTypeMessage typeMessage = FlushBarTypeMessage.classique,
  }) : super(
         leadingWidget: Icon(
           Icons.error_outline,
           color: ConstantesCouleurs.noir,
           size: 24,
         ),
         message:
             complement == null
                 ? _messageToText[message]
                 : "${_messageToText[message]}\n$complement",
         duration: _typeToDuration[typeMessage],
         backgroundColor: _typeToCouleur[typeMessage],

         trailingWidget: IconButton(
           icon: const Icon(Icons.close, color: Colors.black, size: 24),
           onPressed: () {
             FlashyFlushbar.cancel();
           },
         ),
         isDismissible: false,
       );
}
