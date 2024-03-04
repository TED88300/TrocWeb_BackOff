import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:TrocWeb_BackOff/widgets/1-splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class HomeAdmin extends StatelessWidget {
  Widget loading() {
    return new Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {


    return Center(
      child: SizedBox(
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,          ],
          supportedLocales: [
            const Locale('fr', '')
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: false,

            fontFamily: 'Quicksand',
            appBarTheme: AppBarTheme(
              color: gColors.primary,
            ),
            primaryTextTheme: TextTheme(
              subtitle1: TextStyle(
                color: gColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            primarySwatch: MaterialColor(
                gColors.primary.value, gColors.getSwatch(gColors.primary)),
          ),
          home: SplashScreen(),
        ),
      ),
    );







   /* return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Quicksand',
          appBarTheme: AppBarTheme(
            color: gColors.primary,
          ),
          primaryTextTheme: TextTheme(
            subtitle1: TextStyle(
              color: gColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          primarySwatch: MaterialColor(
              gColors.primary.value, gColors.getSwatch(gColors.primary)),
        ),
        home: SplashScreen());*/
  }
}
