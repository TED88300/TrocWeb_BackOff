import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:TrocWeb_BackOff/widgets/1-splashScreen.dart';
import 'package:flutter/material.dart';

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
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: false,
            fontFamily: 'Quicksand',
            appBarTheme: AppBarTheme(
              color: gColors.primary,
            ),
            primaryTextTheme: TextTheme(
              titleMedium: TextStyle(
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






  }
}
