

import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/widgets/0_HomeAdmin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) print("main debug");

  DbTools.gTED = kDebugMode;

  runApp(MaterialApp(localizationsDelegates: [
    GlobalMaterialLocalizations.delegate
  ], supportedLocales: [
    const Locale('fr'),
  ], home: HomeAdmin()));

//  runApp(HomeAdmin());
}

