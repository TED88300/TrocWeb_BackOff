import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/widgets/Etablissement/E_Etab.dart';
import 'package:TrocWeb_BackOff/widgets/Etablissement/E_Liste_NotifParam.dart';
import 'package:flutter/material.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  elevation: 5.0,
                  child: Container(
                    color: gColors.secondary,
                    child: isSuperAdmin
                        ? ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => E_Liste_Etab()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gColors.secondary,
                              padding: const EdgeInsets.all(12.0),
                            ),
                            child: Text('Etablissements', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => E_Etab()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gColors.secondary,
                              padding: const EdgeInsets.all(25.0),
                            ),
                            child: Text('Etablissement', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.fromLTRB(50, 50, 0, 0),
                  elevation: 8.0,
                  child: Container(
                    color: gColors.secondary,
                    child: isSuperAdmin
                        ? ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => E_Liste_NotifParam()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gColors.secondary,
                              padding: const EdgeInsets.all(12.0),
                            ),
                            child: Text('Notifications', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                          )
                        : Container(),
                  ),
                ),
              ],
            ),


Container(height: 50,),

            Row(children: [

            Card(
            margin: EdgeInsets.fromLTRB(50, 50, 0, 0),
            elevation: 5.0,
            child:

              ElevatedButton(
                onPressed: () async {
                  _launchUrl("${DbTools.SrvAppli}TKDebAlert.apk");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: gColors.primary,
                  padding: const EdgeInsets.all(12.0),
                ),
                child: Text('Application TK ALERT ANDROID', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),




            ],),

            Container(height: 50,),

            Row(children: [


              Card(
                margin: EdgeInsets.fromLTRB(50, 50, 0, 0),
                elevation: 5.0,
                child:

                ElevatedButton(
                  onPressed: () async {
                    _launchUrl("${DbTools.SrvAppli}TK_Deb.apk");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.primary,
                    padding: const EdgeInsets.all(12.0),
                  ),
                  child: Text('Application TK DEBARRAS ANDROID', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),





            ],)


          ],
        ),
      ),
    );
  }


  Future<void> _launchUrl(String url) async {
    final Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
