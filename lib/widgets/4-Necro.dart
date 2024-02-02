import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class Necro extends StatefulWidget {
  @override
  NecroState createState() => NecroState();
}

class NecroState extends State<Necro> {
  Size get screenSize => MediaQuery.of(context).size;

  final tecUrl1 = TextEditingController();
  final tecUrl2 = TextEditingController();
  final tecUrl3 = TextEditingController();

  final tecBrouillon = TextEditingController();
  final tecAcresse = TextEditingController();

  void initLib() async {
    tecUrl1.text = DbTools.gEtablissement.UrlNecro_1;
    tecUrl2.text = DbTools.gEtablissement.UrlNecro_2;
    tecUrl3.text = DbTools.gEtablissement.UrlNecro_3;
    tecBrouillon.text = DbTools.gEtablissement.Brouillon;
    tecAcresse.text = DbTools.gEtablissement.Adresse;
  }

  @override
  void initState() {
    initLib();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        padding:
            const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 30.0, 0.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      _launchUrl(tecUrl1.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gColors.primary,
                      padding: const EdgeInsets.all(12.0),
                    ),
                    child: Text('Recherche',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: TextFormField(
                    onChanged: (text) async {
                      DbTools.gEtablissement.UrlNecro_1 = tecUrl1.text;
                    },
                    controller: tecUrl1,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      labelText: "Url 1",
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 30.0, 0.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      _launchUrl(tecUrl2.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gColors.primary,
                      padding: const EdgeInsets.all(12.0),
                    ),
                    child: Text('Recherche',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: TextFormField(
                    onChanged: (text) async {
                      DbTools.gEtablissement.UrlNecro_2 = tecUrl2.text;
                    },
                    controller: tecUrl2,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      labelText: "Url 2",
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 30.0, 0.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      _launchUrl(tecUrl3.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gColors.primary,
                      padding: const EdgeInsets.all(12.0),
                    ),
                    child: Text('Recherche',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: TextFormField(
                    onChanged: (text) async {
                      DbTools.gEtablissement.UrlNecro_3 = tecUrl3.text;
                    },
                    controller: tecUrl3,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      labelText: "Url 3",
                    ),
                  ),
                ),
              ],
            ),
            Row(children: [
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                child: ElevatedButton(
                  onPressed: () async {
                    _launchUrl("https://www.pagesjaunes.fr/pagesblanches");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.primary,
                    padding: const EdgeInsets.all(12.0),
                  ),
                  child: Text('Pages Blanches',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                child: ElevatedButton(
                  onPressed: () async {
                    _launchUrl("https://www.google.com");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.primary,
                    padding: const EdgeInsets.all(12.0),
                  ),
                  child: Text('Google',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(120.0, 10.0, 0.0, 0.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await DbTools.setEtablissement();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.primary,
                    padding: const EdgeInsets.all(12.0),
                  ),
                  child: Text('Save',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
/*            Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: TextFormField(
                      onChanged: (text) async {
                        DbTools.gEtablissement.Brouillon = tecBrouillon.text;
                      },
                      controller: tecBrouillon,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      minLines: 10,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        labelText: "Brouillon",
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: TextFormField(
                      onChanged: (text) async {
                        DbTools.gEtablissement.Adresse = tecAcresse.text;
                      },
                      controller: tecAcresse,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      minLines: 30,
                      maxLines: 100,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        labelText: "Acresses",
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
