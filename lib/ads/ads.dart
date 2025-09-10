import 'dart:async';
// import 'dart:html' as html;
// import 'dart:ui_web' as ui; // TODO -> web

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/data/data.dart';
import 'package:un_jour_un_mot/global_providers/provider_loaded_banner.dart';
import 'package:universal_html/html.dart' as html;

// Data from AdMob
abstract class _AM {
  static final String adUnitIdInterstitial =
      "ca-app-pub-2601867806541576/8617664453";
  static final String adUnitIdBanner = "ca-app-pub-2601867806541576/8716385738";
}

// Data from AdSense
abstract class _AS {
  static final String idClient = "ca-pub-9716107009851380";
  static final String adUnitIdBanner = "5382473249";
}

enum StatutPub { mustBeLoaded, loaded }

class _MyInterstitialAd {
  StatutPub statut = StatutPub.mustBeLoaded;
  late InterstitialAd ad;
}

abstract class Ads {
  static void initialisation() {
    if (kIsWeb) {
      return;
    }
    // Android
    else if (defaultTargetPlatform == TargetPlatform.android) {
      MobileAds.instance.initialize();
    }

    // TODO -> throw
  }
}

abstract class AdInterstital {
  static final _MyInterstitialAd _interstitialAd = _MyInterstitialAd();

  static void load() {
    // Check le statut de l'utilisateur
    if (Data.isPremium) {
      return;
    }

    // Check si une pub n'a pas déjà été chargée
    if (_interstitialAd.statut == StatutPub.mustBeLoaded) {
      // Si on est sur le web
      if (kIsWeb) {
        return;
      }
      // Si on est sur Android
      else if (defaultTargetPlatform == TargetPlatform.android) {
        InterstitialAd.load(
          adUnitId: _AM.adUnitIdInterstitial,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdFailedToShowFullScreenContent: (ad, err) => ad.dispose(),
                onAdDismissedFullScreenContent: (ad) => ad.dispose(),
              );
              debugPrintStack(label: "[app] -> InterstitialAd loaded");
              _interstitialAd.statut = StatutPub.loaded;
              _interstitialAd.ad = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {
              _interstitialAd.statut = StatutPub.mustBeLoaded;
              debugPrintStack(
                label: "[app] -> InterstitialAd failed to load: $error",
              );
            },
          ),
        );
      }
      // Autre plateforme
      else {
        debugPrintStack(
          label:
              "[app] Unsupported platform when the program tried to load an interstitial ad.",
        );
      }
    }
    // Une pub a déjà été chargée
    else {
      debugPrintStack(
        label:
            "[app] -> InterstitialAd loading aborted since an one has already been loaded and now shown",
      );
    }
  }

  static Future<void> show() {
    // Check le statut de l'utilisateur

    if (Data.isPremium) {
      return Future.value();
    }

    // Check si la pub est chargée
    if (_interstitialAd.statut == StatutPub.loaded) {
      // Web
      if (kIsWeb) {
        return Future.value();
      }
      // Android
      else if (defaultTargetPlatform == TargetPlatform.android) {
        _interstitialAd.statut = StatutPub.mustBeLoaded;
        return _interstitialAd.ad.show();
      }
      // Autre plateforme
      else {
        debugPrintStack(
          label:
              "[app] Unsupported platform when the program tried to show an interstitial ad.",
        );
      }
    }
    // Pub non chargée
    else {
      debugPrintStack(
        label: "[app] -> No InterstitialAd has been loaded and can be shown",
      );
    }

    return Future.value();
  }
}

class _MyBannerAd {
  final AdSize size = AdSize.banner;
  StatutPub statut = StatutPub.mustBeLoaded;
  late BannerAd adAM;
  late html.Element adAS;
}

abstract class AdBanner {
  static final _MyBannerAd _bannerAd = _MyBannerAd();

  static StatutPub get statutPub => _bannerAd.statut;

  static Future<void> load(BuildContext context) async {
    // Check le statut de l'utilisateur
    if (Data.isPremium) {
      return;
    }

    // Check si une pub n'a pas déjà été chargée
    if (_bannerAd.statut == StatutPub.mustBeLoaded) {
      // Web
      if (kIsWeb) {
        // TODO WEB -> this must not appear in the Android code, otherwise it does not compile!
        /*ui.platformViewRegistry.registerViewFactory('adsense_ad', (int viewId) {
          final divElement =
              html.DivElement()
                ..style.width = '100%'
                ..style.height = '250px'
                ..setInnerHtml(
                  treeSanitizer: html.NodeTreeSanitizer.trusted,
                  '''
      <ins class="adsbygoogle"
           style="display:block"
           data-ad-client="${_AS.idClient}"
           data-ad-slot="${_AS.adUnitIdBanner}"
           data-ad-format="auto"></ins>
      <script>
          (adsbygoogle = window.adsbygoogle || []).push({});
      </script>
    ''',
                );
          return divElement;
        });

        _bannerAd.statut = StatutPub.loaded;
        debugPrintStack(label: "[app] -> BannerAd loaded");
        await Future.delayed(Duration(seconds: 1)); // TODO -> faire autrement
        if (context.mounted) context.read<ProviderAdBanner>().adLoaded();*/
        return;
      }
      // Android
      else if (defaultTargetPlatform == TargetPlatform.android) {
        _bannerAd.adAM = BannerAd(
          size: _bannerAd.size,
          adUnitId: _AM.adUnitIdBanner,
          request: const AdRequest(),
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              debugPrintStack(label: "[app] -> BannerAd loaded");
              _bannerAd.statut = StatutPub.loaded;
              context.read<ProviderAdBanner>().adLoaded();
            },
            onAdFailedToLoad: (ad, error) {
              debugPrintStack(
                label: "[app] -> BannerAd failed to load: $error",
              );
              _bannerAd.statut = StatutPub.mustBeLoaded;
              ad.dispose();
            },
          ),
        );

        _bannerAd.adAM.load();
      }
      // Autre plateforme
      else {
        debugPrintStack(
          label:
              "[app] Unsupported platform when the program tried to load a banner ad.",
        );
      }
    }
    // Une pub a déjà été chargée
    else {
      debugPrintStack(
        label:
            "[app] -> InterstitialAd loading aborted since an one has already been loaded and not shown",
      );
    }
  }

  static Widget show() {
    if (Data.isPremium) {
      return SizedBox();
    }

    _bannerAd.statut = StatutPub.mustBeLoaded;
    if (kIsWeb) {
      return Container(
        height: 250,
        alignment: Alignment.center,
        child: HtmlElementView(viewType: 'adsense_ad'),
      );
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AdWidget(ad: _bannerAd.adAM);
    }

    throw UnsupportedError(
      "[app] -> Unsupported platform when the program tried to show a banner ad",
    );
  }

  static Widget showWhenNotLoaded() {
    return SizedBox(
      height: AdSize.banner.height.toDouble(),
      width: AdSize.banner.width.toDouble(),
    );
  }
}
