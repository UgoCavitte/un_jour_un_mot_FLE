import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:un_jour_un_mot/data/data.dart';
import 'package:un_jour_un_mot/main.dart';
import 'package:un_jour_un_mot/pages/loading_screens.dart';

import 'initialization_helper.dart';

class InitializeScreen extends StatefulWidget {
  final bool thenPop;
  const InitializeScreen({super.key, this.thenPop = false});

  @override
  State<InitializeScreen> createState() => _InitializeScreenState();
}

class _InitializeScreenState extends State<InitializeScreen> {
  final _initializationHelper = InitializationHelper();

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    Data.etapeInitialisation = EtapeInitialisation.rgpd;
    Data.loadingStatus = LoadingStatus.rgpd;
    return LoadingScreens();
  }

  Future<void> _initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializationHelper.initialize();
      Data.loadingStatus = LoadingStatus.charge;
      context.read<ProviderLoading>().nextStep();

      if (widget.thenPop) {
        Navigator.of(context).pop();
      }

      return;
    });
  }
}
