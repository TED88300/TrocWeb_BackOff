import 'dart:async';

import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/Excel.dart';
import 'package:TrocWeb_BackOff/Tools/shared_Cookies.dart';
import 'package:TrocWeb_BackOff/widgets/2-login.dart';
import 'package:TrocWeb_BackOff/widgets/3-dashboard.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  var IsRememberLogin = false;
  var milliseconds = 2000;

  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    var _duration =
        new Duration(milliseconds: milliseconds); //SetUp duration here
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    print("splash navigationPage IsRememberLogin  $IsRememberLogin");

     //Excel.CrtExcelPat("TK_Debarras_${DbTools.gInventaire.nom}.xlsx");


    if (IsRememberLogin)
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashboardWidget()));
    else
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }

  void initLib() async {

    print("SplashScreen initLib");
    await DbTools.getEtablissementsAll();
    await DbTools.getActions();


    CookieManager cm = CookieManager.getInstance();
    String IsRememberLogins = cm.getCookie("IsRememberLogin");
    IsRememberLogin = (IsRememberLogins == "X");

   if (IsRememberLogin)
      {
        print("SplashScreen initLib IsRememberLogin");
        String emailLogin = cm.getCookie("emailLogin");
        String passwordLogin = cm.getCookie("passwordLogin");
        if (!await DbTools.getUtilisateur(emailLogin, passwordLogin))
          {
            IsRememberLogin =false;
          }
      }

    print("SplashScreen initLib startTime");
  await startTime();

  }



  @override
  void initState() {
    initLib();

    if (DbTools.gTED) milliseconds = 10;

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });

    super.initState();
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/Logo.png',
                width: animation.value * 500,
                height: animation.value * 500,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
