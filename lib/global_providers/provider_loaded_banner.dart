import 'package:flutter/widgets.dart';

class ProviderAdBanner with ChangeNotifier {
  adLoaded() {
    notifyListeners();
  }
}
