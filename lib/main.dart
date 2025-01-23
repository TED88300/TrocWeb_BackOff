
import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/widgets/0_HomeAdmin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'dart:html';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) print("main debug");

  DbTools.gTED = kDebugMode;

  DbTools.curUrl = window.location.href;

  print("DbTools.curUrl ${DbTools.curUrl}");


  runApp(MaterialApp(

      theme: ThemeData(
        useMaterial3: false,
        cardTheme: CardTheme(
          surfaceTintColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFf6f6f6),
        primarySwatch: MaterialColor(
          gColors.primary.value,
          gColors.getSwatch(gColors.primary),
        ),

      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,          ],
      supportedLocales: [
        const Locale('fr', '')
      ],

      home: HomeAdmin()));

//  runApp(HomeAdmin());
}
