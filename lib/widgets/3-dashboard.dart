import 'dart:html';
import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/Devis_Fact.dart';
import 'package:TrocWeb_BackOff/widgets/2-login.dart';
import 'package:TrocWeb_BackOff/widgets/Agence/A_Calendrier.dart';
import 'package:TrocWeb_BackOff/widgets/Agence/A_Liste_Affaires.dart';
import 'package:TrocWeb_BackOff/widgets/Agence/A_Liste_Affaires_50_100.dart';
import 'package:TrocWeb_BackOff/widgets/Agence/A_Liste_Affaires_PT.dart';
import 'package:TrocWeb_BackOff/widgets/Agence/A_Liste_Affaires_PT_50_100.dart';
import 'package:TrocWeb_BackOff/widgets/Agence/A_Liste_Affaires_PT_ALL.dart';
import 'package:TrocWeb_BackOff/widgets/DASHBOARD_A.dart';

import 'package:TrocWeb_BackOff/widgets/NOTIFICATIONS.dart';
import 'package:flutter/cupertino.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:flutter/material.dart';
import 'package:TrocWeb_BackOff/Tools/shared_Cookies.dart';
import 'package:flutter/services.dart';

import '4-Necro.dart';
import 'ADMIN.dart';

class DashboardWidget extends StatefulWidget {
  @override
  DashboardWidgetState createState() => DashboardWidgetState();
}

class DashboardWidgetState extends State<DashboardWidget> {
  int currentPage = 2;
  String? emailLogin = "";

  String Title = "Trokeur débarras : Liste des Affaires";

  void initLib() async {
    rootBundle
        .load('assets/images/Logo.png')
        .then((data) => DbTools.LogoimageData = data);

    emailLogin = await window.localStorage['emailLogin'];
    setState(() {
      emailLogin = emailLogin;
    });
  }

  @override
  void initState() {
    print(
        "initState ${DbTools.gUtilisateurLogin.User} ${DbTools.gUtilisateurLogin.Role}");

    initLib();
    super.initState();



  }


  final List<Widget> _pages = [
    ADMIN(),
//    DASHBOARD_A(),
    NOTIFICATIONS(),
    DbTools.gUtilisateurLogin.Role == "Plateforme"
        ? Liste_Inventaire_PT()
        : Liste_Inventaire(),
    DbTools.gUtilisateurLogin.Role == "Plateforme"
        ? A_Liste_Affaires_PT_ALL()
        : Container(),
    DbTools.gUtilisateurLogin.Role == "Plateforme"
        ? A_Liste_Affaires_PT_50_100()
        : (DbTools.gEtablissement.IsNewCT == 0) ?
    Container() : A_Liste_Affaires_50_100(),

    A_Calendrier(),
    Necro(),
    NOTIFICATIONS(),
    NOTIFICATIONS(),
  ];

  @override
  Widget build(BuildContext context) {

    return Row(
      children: <Widget>[
        Container(
          color: gColors.white,
          width: 180,
          child: Drawer(
            child: Container(
              color: gColors.primary,
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                          child: InkWell(
                            child: new Image.asset(
                              DbTools.gUtilisateurLogin.Role == "Plateforme"
                                  ? 'assets/images/LogoTKSPlus.png'
                                  : DbTools.gVersion.contains("PP")
                                      ? 'assets/images/LogoPP.png'
                                      : 'assets/images/Logo.png',
                              height: 60,
                              width: 150,
                            ),
                            onTap: () {
                              if (DbTools.gUtilisateurLogin.Role
                                  .contains("Admin")) {
                                setState(() {
                                  Title = "Trokeur débarras : Adminstrateur";
                                  currentPage = 0;
                                });
                              }
                            },
                          ),
                        ),
                        Text(
                          'BACK OFFICE',
                          style: TextStyle(
                              color: gColors.TextColor1,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text("${DbTools.gVersion} ${DbTools.gUtilisateur.Role}",
                            style: TextStyle(
                              fontSize: 10,
                            )),
                        Container(height: 10),
                        Text(
                          "${DbTools.gEtablissement.Libelle} (${DbTools.gEtablissement.id})",
                          style: TextStyle(
                              color: gColors.TextColor1,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(height: 5),
                        Text(
                          "${DbTools.gEtablissement.cp} ${DbTools.gEtablissement.ville}",
                          style: TextStyle(
                            color: gColors.TextColor1,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: gColors.primary,
                    ),
                  ),
                  Container(
                    height: 1,
                    color: gColors.TextColor1,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: gColors.TextColor1,
                    ),
                    title: Text(
                      'DASHBOARD',
                      style: TextStyle(
                        color: (currentPage == 1)
                            ? gColors.TextColor3
                            : gColors.TextColor2,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        Title = "Trokeur débarras : Dashboard";
                        currentPage = 1;
                      });
                    },
                  ),
                  Container(
                    height: 1,
                    color: gColors.TextColor1,
                  ),
                  Container(height: 10),
                  ListTile(
                    leading: const Icon(
                      Icons.person_outline,
                      color: gColors.TextColor1,
                    ),
                    title: Text('AFFAIRES',
                        style: TextStyle(
                          color: (currentPage == 2)
                              ? gColors.TextColor3
                              : gColors.TextColor2,
                          fontSize: 14,
                        )),
                    onTap: () {
                      setState(() {
                        Title = "Trokeur débarras : Liste des Affaires";
                        currentPage = 2;
                      });
                    },
                  ),
                  DbTools.gUtilisateurLogin.Role != "Plateforme"
                      ? Container()
                      : Container(height: 10),
                  DbTools.gUtilisateurLogin.Role != "Plateforme"
                      ? Container()
                      : ListTile(
                          leading: const Icon(
                            Icons.person_outline,
                            color: gColors.TextColor1,
                          ),
                          title: Text('AFFAIRES ALL',
                              style: TextStyle(
                                color: (currentPage == 3)
                                    ? gColors.TextColor3
                                    : gColors.TextColor2,
                                fontSize: 14,
                              )),
                          onTap: () {
                            setState(() {
                              Title = "Trokeur débarras : Toutes les Affaires";
                              currentPage = 3;
                            });
                          },
                        ),
                  Container(height: 10),
                  DbTools.gUtilisateurLogin.Role != "Plateforme"
                      ? (DbTools.gEtablissement.IsNewCT == 0)
                          ? Container()
                          : ListTile(
                              leading: const Icon(
                                Icons.person_outline,
                                color: gColors.TextColor1,
                              ),
                              title: Text('Aff. 50€/100€',
                                  style: TextStyle(
                                    color: (currentPage == 4)
                                        ? gColors.TextColor3
                                        : gColors.TextColor2,
                                    fontSize: 14,
                                  )),
                              onTap: () {
                                setState(() {
                                  Title =
                                      "Trokeur débarras : Affaires 50€/100€";
                                  currentPage = 4;
                                });
                              },
                            )
                      : ListTile(
                          leading: const Icon(
                            Icons.person_outline,
                            color: gColors.TextColor1,
                          ),
                          title: Text('AFF. 50€/100€',
                              style: TextStyle(
                                color: (currentPage == 4)
                                    ? gColors.TextColor3
                                    : gColors.TextColor2,
                                fontSize: 14,
                              )),
                          onTap: () {
                            setState(() {
                              Title = "Trokeur débarras PF : Affaires 50€/100€";
                              currentPage = 4;
                            });
                          },
                        ),
                  Container(height: 10),
                  ListTile(
                    leading: const Icon(
                      Icons.person_outline,
                      color: gColors.TextColor1,
                    ),
                    title: Text('CALENDRIER',
                        style: TextStyle(
                          color: (currentPage == 5)
                              ? gColors.TextColor3
                              : gColors.TextColor2,
                          fontSize: 14,
                        )),
                    onTap: () async {
                      await DbTools.getInventaires_Calendar(DbTools.gEtablissement.id);

                      setState(() {
                        Title = "Trokeur débarras : Calendrier";
                        currentPage = 5;
                      });
                    },
                  ),
                  Container(height: 10),
                  (DbTools.gEtablissement.id > 3)
                      ? Container()
                      : ListTile(
                          leading: const Icon(
                            Icons.person_outline,
                            color: gColors.TextColor1,
                          ),
                          title: Text('Adresses Journaux',
                              style: TextStyle(
                                color: (currentPage == 6)
                                    ? gColors.TextColor3
                                    : gColors.TextColor2,
                                fontSize: 14,
                              )),
                          onTap: () async {
                            setState(() {
                              Title = "Trokeur débarras : Adresses Journaux";
                              currentPage = 6;
                            });
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: gColors.secondary,
              title: Container(
                color: gColors.secondary,
                child: Text(Title,
                    style: TextStyle(
                      color: gColors.white,
                      fontSize: 14,
                    )),
              ),
              leading: Container(),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: gColors.TextColor3,
                  ),
                  tooltip: 'Logout',
                  onPressed: () async {
                    CookieManager cm = CookieManager.getInstance();
                    cm.addToCookie("IsRememberLogin", "");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                ),
              ],
            ),
            body: Pages(),
          ),
        ),
      ],
    );
  }

  @override
  Widget Pages() {
    return Padding(
        padding:
            const EdgeInsets.only(left: 0.0, right: 0.0, top: 0, bottom: 0),
        child: _pages[currentPage]);
  }
}
