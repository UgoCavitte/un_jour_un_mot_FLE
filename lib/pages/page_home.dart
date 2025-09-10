import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/composants/my_texts.dart';
import 'package:un_jour_un_mot/constantes/constantes_couleurs.dart';
import 'package:un_jour_un_mot/constantes/constantes_icones.dart';
import 'package:un_jour_un_mot/constantes/constantes_textes.dart';
import 'package:un_jour_un_mot/pages/menu_parametres.dart';
import 'package:un_jour_un_mot/pages/page_boutique.dart';
import 'package:un_jour_un_mot/pages/page_mots.dart';

class PageHome extends StatefulWidget {
  final int index;

  const PageHome({super.key, required this.index});

  @override
  State<StatefulWidget> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.index);
    Provider.of<ProviderPageHome>(context, listen: false).index = widget.index;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changerPage({required int nouvelIndex}) {
    setState(() {
      _pageController.jumpToPage(nouvelIndex);
      Provider.of<ProviderPageHome>(context, listen: false).index = nouvelIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantesCouleurs.blanc,
      appBar: AppBar(
        title: MyTitreAppBar(titreAppli),
        centerTitle: true,
        foregroundColor: ConstantesCouleurs.blanc,
        backgroundColor: ConstantesCouleurs.bleu,
        actions: [
          IconButton(
            icon: ConstantesIcones.iconeParametres,
            tooltip: tooltipParametres,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => ChangeNotifierProvider(
                        create: (_) => ProviderMenuParametres(),
                        child: MenuParametres(),
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: [
          // Page mots
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ProviderPageMots()),
            ],
            child: PageMots(),
          ),

          // Page boutique
          ChangeNotifierProvider(
            create: (_) => ProviderPageBoutique(),
            child: PageBoutique(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: ConstantesCouleurs.blanc,
        showElevation: true,
        selectedIndex: Provider.of<ProviderPageHome>(context).index,
        onItemSelected: (index) => _changerPage(nouvelIndex: index),
        items: [
          BottomNavyBarItem(
            icon: ConstantesIcones.iconeHome,
            title: MyTextGeneral(nomPageHome),
          ),
          BottomNavyBarItem(
            icon: ConstantesIcones.iconeBoutique,
            title: MyTextGeneral(nomPageBoutique),
          ),
        ],
      ),
    );
  }
}

class ProviderPageHome with ChangeNotifier {
  int index = 0;
}
