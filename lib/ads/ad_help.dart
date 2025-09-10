import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return '<YOUR_ANDROID_BANNER_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'ca-app-pub-2601867806541576/8617664453';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
