import 'package:firebase_core/firebase_core.dart';
import 'package:flashy_flushbar/flashy_flushbar_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/ads/consentement/initialize_screen.dart';
import 'package:un_jour_un_mot/data/data.dart';
import 'package:un_jour_un_mot/firebase_options.dart';
import 'package:un_jour_un_mot/global_providers/provider_connect.dart';
import 'package:un_jour_un_mot/global_providers/provider_loaded_banner.dart';
import 'package:un_jour_un_mot/pages/loading_screens.dart';
import 'package:un_jour_un_mot/pages/on_boarding.dart';
import 'package:un_jour_un_mot/pages/page_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Le reste de l'initialisation se fait après le runApp pour permettre l'affichage d'écrans de chargement

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderConnect()),
        ChangeNotifierProvider(create: (_) => ProviderLoading()),
        ChangeNotifierProvider(create: (_) => ProviderAdBanner()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .watch<
          ProviderAdBanner
        >(); // Nécessaire pour rebuild en cas de chargement d'une bannière de pub

    if (!context.watch<ProviderLoading>().initialise) {
      context.read<ProviderLoading>().initialisation(
        context.read<ProviderLoading>(),
      );
    }

    return MaterialApp(
      builder: FlashyFlushbarProvider.init(),
      title: 'Un jour, un mot',
      debugShowCheckedModeBanner: false,
      home: _getPageToShow(),
    );
  }

  Widget _getPageToShow() {
    // Initialisation en cours
    switch (Data.loadingStatus) {
      case LoadingStatus.initialisation:
        return SafeArea(child: LoadingScreens());
      case LoadingStatus.tutoriel:
        return SafeArea(child: OnBoarding());
      case LoadingStatus.rgpd:
        Data.etapeInitialisation = EtapeInitialisation.rgpd;
        return SafeArea(child: InitializeScreen());
      case LoadingStatus.charge:
        return ChangeNotifierProvider(
          create: (_) => ProviderPageHome(),
          child: SafeArea(child: PageHome(index: 0)),
        );
    }
  }
}

class ProviderLoading with ChangeNotifier {
  bool initialise = false;

  void initialisation(ProviderLoading provider) {
    Data.initialiserData(provider);
    initialise = true;
  }

  void nextStep() {
    // Si le chargement est terminé et que le tutoriel n'est pas déjà fait, alors on l'affiche
    if (Data.etapeInitialisation == EtapeInitialisation.fini) {
      // Web -> pas de RGPD
      if (kIsWeb) {
        Data.loadingStatus =
            Data.tutorielDebut ? LoadingStatus.tutoriel : LoadingStatus.charge;
      }
      // Android -> RGPD
      else {
        Data.loadingStatus =
            Data.tutorielDebut ? LoadingStatus.tutoriel : LoadingStatus.rgpd;
      }
    }

    notifyListeners();
  }
}
