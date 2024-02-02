import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/widgets/Etablissement/E_Etab.dart';
import 'package:TrocWeb_BackOff/widgets/Etablissement/E_Liste_NotifParam.dart';
import 'package:flutter/material.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';

import 'Etablissement/E_Liste_Etab.dart';

class ADMIN extends StatefulWidget {
  @override
  _ADMINState createState() => _ADMINState();
}

class _ADMINState extends State<ADMIN> {
  bool isSuperAdmin = false;

  @override
  void initState() {
    print("initState");

    isSuperAdmin = DbTools.gUtilisateurLogin.Role.contains("Super");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.fromLTRB(50, 50, 0, 0),
                  elevation: 50.0,
                  child: Container(
                    color: gColors.secondary,
                    child: isSuperAdmin
                        ? ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => E_Liste_Etab()));
                            },
                      style: ElevatedButton.styleFrom( backgroundColor: gColors.secondary, padding: const EdgeInsets.all(12.0),),


                            child: Text('Etablissements',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => E_Etab()));
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gColors.secondary,
                        padding: const EdgeInsets.all(25.0),),
                            child: Text('Etablissement',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.fromLTRB(50, 50, 0, 0),
                  elevation: 50.0,
                  child: Container(
                    color: gColors.secondary,
                    child: isSuperAdmin
                        ? ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => E_Liste_NotifParam()));
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gColors.secondary,
                        padding: const EdgeInsets.all(25.0),),
                      child: Text('Notifications',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          )
                        : Container(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
