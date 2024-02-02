import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/Utilisateur.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:TrocWeb_BackOff/widgets/Etablissement/A_CGV.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class E_Etab extends StatefulWidget {
  @override
  E_EtabState createState() => E_EtabState();
}

class E_EtabState extends State<E_Etab> {
  final tecNom = TextEditingController();

  final tecNom_TK = TextEditingController();
  final tecInterlocuteur = TextEditingController();

  final tecKEYID = TextEditingController();

  final tecadresse1 = TextEditingController();
  final tecadresse2 = TextEditingController();
  final teccp = TextEditingController();
  final tecville = TextEditingController();
  final tectel = TextEditingController();
  final tecmail = TextEditingController();

  final tecPays = TextEditingController();
  final tecRC = TextEditingController();
  final tecAss_RC = TextEditingController();
  final tecRIB = TextEditingController();
  final tecRGLT = TextEditingController();

  final tecTxTVA = TextEditingController();
  final tecNo_TVA = TextEditingController();
  final tecMtDechM3 = TextEditingController();

  final tecindexDevis = TextEditingController();
  final tecindexFacture = TextEditingController();

  final tecUrl_Avis = TextEditingController();



  static bool isUpdate = false;

  static List<Utilisateur> lUtilisateur = [];
  late UtilisateurDataSource utilisateurDataSource;
  int CountTot = 0;
  int CountSel = 0;
  int SelCol = -1;
  int SelID = -1;

  double textSize = 14.0;
  bool onCellTap = false;
  bool isLoadUser = false;

  void Reload() async {
    isLoadUser = false;
    await DbTools.getUtilisateursEtab(DbTools.gEtablissement.keyid);

    Filtre();
    print("Reload lenght ${lUtilisateur.length}");
    CountTot = CountSel = lUtilisateur.length;
    isLoadUser = true;
    setState(() {});
  }

  void Filtre() {
    lUtilisateur.clear();
    lUtilisateur.addAll(DbTools.ListUtilisateur);

    CountSel = lUtilisateur.length;

    setState(() {});
  }

  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    super.initState();
    initLib();

    tecNom.text = DbTools.gEtablissement.Libelle;

    tecNom_TK.text = DbTools.gEtablissement.Nom_TK;
    tecInterlocuteur.text = DbTools.gEtablissement.Interlocuteur;

    tecadresse1.text = DbTools.gEtablissement.adresse1;
    tecadresse2.text = DbTools.gEtablissement.adresse2;
    teccp.text = DbTools.gEtablissement.cp;
    tecville.text = DbTools.gEtablissement.ville;
    tectel.text = DbTools.gEtablissement.tel;
    tecmail.text = DbTools.gEtablissement.mail;
    tecKEYID.text = DbTools.gEtablissement.keyid;

    tecPays.text = DbTools.gEtablissement.Pays;
    tecRC.text = DbTools.gEtablissement.RC;
    tecAss_RC.text = DbTools.gEtablissement.Ass_RC;


    tecRIB.text = DbTools.gEtablissement.RIB;
    tecRGLT.text = DbTools.gEtablissement.RGLT;

    tecTxTVA.text = DbTools.gEtablissement.TxTVA.toString();
    tecNo_TVA.text = DbTools.gEtablissement.No_TVA;
    tecMtDechM3.text = DbTools.gEtablissement.MtDechM3.toString();

    tecindexDevis.text = DbTools.gEtablissement.indexDevis.toString();
    tecindexFacture.text = DbTools.gEtablissement.indexFacture.toString();

    tecUrl_Avis.text = DbTools.gEtablissement.Url_Avis.toString();



    isUpdateAdr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: gColors.secondary,
          title: Container(
            color: gColors.secondary,
            child: Text("Trokeur débarras : Etablissement",
                style: TextStyle(
                  fontSize: 14,
                  color: gColors.white,
                )),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 520,
              child: Row(children: [
                Flexible(
                  flex: 5,
                  child: buildAdr(context),
                ),
              ]),
            ),
            Container(
              height: 20,
            ),

            Container(
              height: 20,
            ),
          ],
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add),
            backgroundColor: gColors.primary,
            onPressed: () async {
              DbTools.gUtilisateur =
                  Utilisateur(-1, DbTools.gEtablissement.id, "", "", "User", 1);
              print("add ${DbTools.gUtilisateur.id}");
              await showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(),
              );
              Reload();

              //          Reload();
            }));
  }

  void isUpdateAdr() {
    isUpdate = tecNom.text != DbTools.gEtablissement.Libelle ||
        tecNom_TK.text != DbTools.gEtablissement.Nom_TK ||
        tecInterlocuteur.text != DbTools.gEtablissement.Interlocuteur ||
        tecadresse1.text != DbTools.gEtablissement.adresse1 ||
        tecadresse2.text != DbTools.gEtablissement.adresse2 ||
        teccp.text != DbTools.gEtablissement.cp ||
        tecville.text != DbTools.gEtablissement.ville ||
        tectel.text != DbTools.gEtablissement.tel ||
        tecmail.text != DbTools.gEtablissement.mail ||
        tecKEYID.text != DbTools.gEtablissement.keyid ||
        tecPays.text != DbTools.gEtablissement.Pays ||
        tecRC.text != DbTools.gEtablissement.RC ||
        tecAss_RC.text != DbTools.gEtablissement.Ass_RC ||
        tecRIB.text != DbTools.gEtablissement.RIB ||
        tecRGLT.text != DbTools.gEtablissement.RGLT ||
        tecTxTVA.text != DbTools.gEtablissement.TxTVA ||
        tecNo_TVA.text != DbTools.gEtablissement.No_TVA ||
        tecMtDechM3.text != DbTools.gEtablissement.MtDechM3 ||
        tecindexDevis.text != DbTools.gEtablissement.indexDevis.toString() ||
        tecindexFacture.text != DbTools.gEtablissement.indexFacture.toString();

        tecUrl_Avis.text != DbTools.gEtablissement.Url_Avis.toString();




    print("isUpdateAdr ${isUpdate}");
    setState(() {});
  }

  Widget buildAdr(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 0),
        child: Form(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10, bottom: 0),
                    child: Row(children: [
                      Flexible(
                        flex: 6,
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tecNom,
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
                            labelText: "Nom",
                          ),
                        ),
                      ),
                      Container(
                        width: 20,
                      ),
                      Flexible(
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tecKEYID,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            labelText: "KEYID",
                          ),
                        ),
                      ),
                      Container(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {

                          await showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                A_CGV(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                           gColors.push,
                          padding: const EdgeInsets.all(12.0),),
                        child: Text('CGV',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          DbTools.gEtablissement.Libelle = tecNom.text;

                          DbTools.gEtablissement.Nom_TK = tecNom_TK.text;
                          DbTools.gEtablissement.Interlocuteur =
                              tecInterlocuteur.text;

                          DbTools.gEtablissement.adresse1 = tecadresse1.text;
                          DbTools.gEtablissement.adresse2 = tecadresse2.text;
                          DbTools.gEtablissement.adresse1 = tecadresse1.text;
                          DbTools.gEtablissement.adresse2 = tecadresse2.text;
                          DbTools.gEtablissement.cp = teccp.text;
                          DbTools.gEtablissement.ville = tecville.text;
                          DbTools.gEtablissement.tel = tectel.text;
                          DbTools.gEtablissement.mail = tecmail.text;
                          DbTools.gEtablissement.keyid = tecKEYID.text;

                          DbTools.gEtablissement.Pays = tecPays.text;
                          DbTools.gEtablissement.RC = tecRC.text;
                          DbTools.gEtablissement.Ass_RC = tecAss_RC.text;


                          DbTools.gEtablissement.RIB = tecRIB.text;
                          DbTools.gEtablissement.RGLT = tecRGLT.text;
                          DbTools.gEtablissement.TxTVA =
                              double.parse(tecTxTVA.text);
                          DbTools.gEtablissement.No_TVA = tecNo_TVA.text;
                          DbTools.gEtablissement.MtDechM3 =
                              double.parse(tecMtDechM3.text);

                          DbTools.gEtablissement.indexFacture =
                              int.parse(tecindexDevis.text);
                          DbTools.gEtablissement.indexDevis =
                              int.parse(tecindexFacture.text);

                          DbTools.gEtablissement.Url_Avis = tecUrl_Avis.text;




                          if (DbTools.gEtablissement.id == -1)
                            await DbTools.addEtablissement();
                          else
                            await DbTools.setEtablissement();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          isUpdate ? gColors.primary : gColors.LinearGradient1,
                          padding: const EdgeInsets.all(12.0),),
                        child: Text('Save',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ])),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10, bottom: 0),
                    child: Row(children: [
                      Flexible(
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tecNom_TK,
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
                            labelText: "Nom",
                          ),
                        ),
                      ),
                      Container(
                        width: 20,
                      ),
                      Flexible(
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tecInterlocuteur,
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
                            labelText: "Interlocuteur",
                          ),
                        ),
                      ),
                    ])),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10, bottom: 0),
                    child: Row(children: [
                      Flexible(
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tecadresse1,
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
                            labelText: "Adresse",
                          ),
                        ),
                      ),
                      Container(
                        width: 20,
                      ),
                      Flexible(
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tecadresse2,
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
                            labelText: "Adresse",
                          ),
                        ),
                      ),
                    ])),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10, bottom: 0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: TextFormField(
                            onChanged: (text) {
                              isUpdateAdr();
                            },
                            controller: teccp,
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
                              labelText: "Code postal",
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                        ),
                        Flexible(
                          flex: 7,
                          child: TextFormField(
                            onChanged: (text) {
                              isUpdateAdr();
                            },
                            controller: tecville,
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
                              labelText: "Ville",
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (teccp.text.length > 0)
                              await DbTools.ReadServer_CpVilles(teccp.text);
                            else
                              await DbTools.ReadServer_CpVilles(tecville.text);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CpV_dialog(context),
                            );
                          },
style: ElevatedButton.styleFrom( backgroundColor: Colors.black12,),                          child: Text('??',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          width: 20,
                        ),
                        Flexible(
                          flex: 3,
                          child: TextFormField(
                            onChanged: (text) {
                              isUpdateAdr();
                            },
                            controller: tecPays,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
                              labelText: "Pays",
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                        ),
                        Flexible(
                          flex: 9,
                          child: TextFormField(
                            onChanged: (text) {
                              isUpdateAdr();
                            },
                            controller: tecRC,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
                              labelText: "N° RC",
                            ),
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10, bottom: 0),
                    child: Row(children: [
                      Container(
                        width: 200,
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tectel,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            labelText: "Téléphone",
                          ),
                        ),
                      ),
                      Container(
                        width: 20,
                      ),
                      Container(
                        width: 600,
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tecmail,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            labelText: "Mail",
                          ),
                        ),
                      ),


                      Container(
                        width: 20,
                      ),
                      Container(
                        width: 600,
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tecAss_RC,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            labelText: "Assurance RC",
                          ),
                        ),
                      ),


                    ])),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10, bottom: 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 200,
                                        child: TextFormField(
                                          onChanged: (text) {
                                            isUpdateAdr();
                                          },
                                          controller: tecTxTVA,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16.0)),
                                            contentPadding:
                                                new EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                    horizontal: 10.0),
                                            labelText:
                                                "Taux de TVA (%) 0 = Pas de TVA",
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 20,
                                      ),
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          onChanged: (text) {
                                            isUpdateAdr();
                                          },
                                          controller: tecMtDechM3,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16.0)),
                                            contentPadding:
                                                new EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                    horizontal: 10.0),
                                            labelText:
                                                "Coût Décheterie HT / m3",
                                          ),
                                        ),
                                      ),
                                    ]),
                                Container(
                                  height: 20,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 200,
                                        child: TextFormField(
                                          onChanged: (text) {
                                            isUpdateAdr();
                                          },
                                          controller: tecindexDevis,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16.0)),
                                            contentPadding:
                                                new EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                    horizontal: 10.0),
                                            labelText: "Index devis",
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 20,
                                      ),
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          onChanged: (text) {
                                            isUpdateAdr();
                                          },
                                          controller: tecindexFacture,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16.0)),
                                            contentPadding:
                                                new EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                    horizontal: 10.0),
                                            labelText: "Index Facture",
                                          ),
                                        ),
                                      ),
                                    ]),
                              ]),
                          Container(
                            height: 20,
                          ),
                          Container(
                            width: 20,
                          ),


                          Container(
                            width: 500,
                            height: 100,
                            child: TextFormField(
                              onChanged: (text) {
                                isUpdateAdr();
                              },
                              minLines: 5,
                              maxLines: 5,
                              controller: tecRGLT,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                labelText: "Modalités / Réglements",
                              ),
                            ),
                          ),
                          Container(
                            width: 20,
                          ),

                          Container(
                            width: 500,
                            height: 100,
                            child: TextFormField(
                              onChanged: (text) {
                                isUpdateAdr();
                              },
                              minLines: 5,
                              maxLines: 5,
                              controller: tecRIB,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                labelText: "RIB",
                              ),
                            ),
                          ),






                        ])),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10, bottom: 0),
                  child: Row(children: [
                    Container(
                      width: 800,
                      height: 100,
                      child: TextFormField(
                        onChanged: (text) {
                          isUpdateAdr();
                        },
                        minLines: 5,
                        maxLines: 5,
                        controller: tecNo_TVA,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          labelText: "Pied de document",
                        ),
                      ),
                    ),



                    Container(
                      width: 800,
                      height: 100,
                      child: TextFormField(
                        onChanged: (text) {
                          isUpdateAdr();
                        },
                        minLines: 5,
                        maxLines: 5,
                        controller: tecUrl_Avis,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          labelText: "URL Avis Google",
                        ),
                      ),
                    ),

                  ]),
                ),
              ]),
        ));
  }

  Widget ListViewCpVille(data) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              color: (index.isOdd ? Colors.black12 : Colors.white),
              child: ListTile(
                onTap: () async {
                  setState(() {
                    teccp.text = DbTools.tCp[index];
                    tecville.text = DbTools.tVille[index];
                  });
                  Navigator.of(context).pop();
                },
                title: Text("${DbTools.tCp[index]} - ${DbTools.tVille[index]}"),
              ));
        },
      ),
    );
  }

  Widget CpV_dialog(BuildContext context) {
    return AlertDialog(
      title: Container(
        color: gColors.secondary,
        child: Text("Code postal - Ville",
            style: TextStyle(
              color: gColors.white,
            )),
      ),
      content: Container(
        height: 280,
        child: ListViewCpVille(DbTools.tCp),
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
style: ElevatedButton.styleFrom(             foregroundColor: gColors.primary,           ),          child: const Text('Annuler',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

//**********************************
//**********************************
//**********************************

  Widget UtilisateurGridWidget() {
    utilisateurDataSource = UtilisateurDataSource(lUtilisateur);
    print("lUtilisateur lenght ${lUtilisateur.length}");

    return (lUtilisateur.length == 0 && !isLoadUser)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                SpinKitThreeBounce(
                  color: gColors.primary,
                  size: 100.0,
                ),
                Container(
                  height: 10,
                ),
                Text(
                  "Liste vide ...",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ])
        : SfDataGridTheme(
            data: SfDataGridThemeData(
              headerColor: gColors.primary,
            ),
            child: Center(
              child: Container(
//            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: SfDataGrid(
                  isScrollbarAlwaysShown: true,
                  source: utilisateurDataSource,
                  frozenColumnsCount: 1,
//              frozenRowsCount: 1,
                  onQueryRowHeight: (details) {
                    return details.rowIndex == 0 ? 40.0 : 40.0;
                  },
                  allowSorting: true,
                  allowMultiColumnSorting: true,
                  allowTriStateSorting: true,
                  showSortNumbers: true,
                  columnWidthMode: ColumnWidthMode.auto,
                  columns: <GridColumn>[
                    GridColumn(
                      columnName: 'CID',
                      visible: false,
                      label: Container(),
                    ),
                    GridColumn(
                        columnName: 'ID',
                        columnWidthMode: ColumnWidthMode.fill,
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Id',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'USER',
                        columnWidthMode: ColumnWidthMode.fill,
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  User',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'PW',
                        columnWidthMode: ColumnWidthMode.fill,
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Mot de Passe',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'ROLE',
                        columnWidthMode: ColumnWidthMode.fill,
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Rôle',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'ACTIF',
                        columnWidthMode: ColumnWidthMode.fill,
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Actif',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                  ],
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  selectionMode: SelectionMode.single,
                  navigationMode: GridNavigationMode.cell,

                  onSelectionChanged:
                      (List<Object> addedRows, List<Object> removedRows) async {
                    DataGridRow selDataGridRow =
                        (addedRows.last as DataGridRow);

                    SelCol = -1;
                    onCellTap = false;

                    DbTools.gUtilisateur =
                        lUtilisateur[selDataGridRow.getCells()[0].value];
                    print("onSelectionChanged ${DbTools.gUtilisateur.id}");
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(),
                    );
                    Reload();
                  },
                  onCurrentCellActivated: (RowColumnIndex currentRowColumnIndex,
                      RowColumnIndex previousRowColumnIndex) async {
                    print("onCurrentCellActivated ${SelCol}");
                    SelCol = currentRowColumnIndex.columnIndex;
                    if (!onCellTap &&
                        currentRowColumnIndex.rowIndex ==
                            previousRowColumnIndex.rowIndex) {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialog(),
                      );

                      Reload();
                    }
                    onCellTap = false;
                  },

                  onCellTap: (DataGridCellTapDetails details) async {
                    print(
                        "onCellTap ${SelCol} ${SelID} ${DbTools.gUtilisateur.id} $details");
                    if (SelCol != -1 && SelID == DbTools.gUtilisateur.id) {
                      onCellTap = true;
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialog(),
                      );
                      Reload();
                    }
                  },
                ),
              ),
            ),
          );
  }
}

//******************************
//****************************************

class UtilisateurDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  int i = 0;

  UtilisateurDataSource(List<Utilisateur> Utilisateurs) {
    dataGridRows =
        Utilisateurs.map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'CID', value: i++),
              DataGridCell<int>(columnName: 'ID', value: dataGridRow.id),
              DataGridCell<String>(columnName: 'USER', value: dataGridRow.User),
              DataGridCell<String>(
                  columnName: 'PW', value: dataGridRow.Motdepasse),
              DataGridCell<String>(columnName: 'ROLE', value: dataGridRow.Role),
              DataGridCell<String>(
                  columnName: 'ACTIF',
                  value: dataGridRow.Actif == 1 ? "X" : ""),
            ])).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    var P = 0.0;

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          ));
    }).toList());
  }
}

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  var tecUser = TextEditingController();
  var tecPw = TextEditingController();

  @override
  Widget build(BuildContext context) {
    tecUser.text = DbTools.gUtilisateur.User;
    tecPw.text = DbTools.gUtilisateur.Motdepasse;
    DbTools.sRole = DbTools.gUtilisateur.Role;
    DbTools.isChecked =
        false; // DbTools.gUtilisateur.Actif == 1 ? true : false;

    return AlertDialog(
      title: Container(
        color: gColors.secondary,
        child: Text("Utilisateur",
            style: TextStyle(
              color: gColors.white,
            )),
      ),
      content: Container(
          height: 280,
          child: Column(children: [
            TextFormField(
              onChanged: (text) {},
              controller: tecUser,
              style: TextStyle(
                fontSize: 14,
              ),
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                labelText: "User :",
              ),
            ),
            Container(
              height: 10,
            ),
            TextFormField(
              onChanged: (text) {},
              controller: tecPw,
              style: TextStyle(
                fontSize: 14,
              ),
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                labelText: "Mot de Passe :",
              ),
            ),
            DD_Roles(),
            Row(
              children: <Widget>[
                Checkbox(
                  value: DbTools.gUtilisateur.Actif.isOdd,
                  onChanged: (value) {
                    setState(() {
                      DbTools.gUtilisateur.Actif = value! ? 1 : 0;
                      print("value $value ${DbTools.gUtilisateur.Actif}");
                    });
                  },
                ),
                Text("Actif"),
              ],
            ),
          ])),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () async {
            DbTools.gUtilisateur.User = tecUser.text;
            DbTools.gUtilisateur.Motdepasse = tecPw.text;

            print(
                "addUtilisateur ${DbTools.gUtilisateur.User} ${DbTools.gUtilisateur.Motdepasse}");
            if (DbTools.gUtilisateur.id == -1)
              await DbTools.addUtilisateur();
            else
              await DbTools.setUtilisateur();
            Navigator.of(context).pop();
          },
style: ElevatedButton.styleFrom(             foregroundColor: gColors.primary,           ),          child: const Text('Save',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        ),
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
style: ElevatedButton.styleFrom(             foregroundColor: gColors.secondary,           ),          child: const Text('Annuler',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  @override
  Widget DD_Roles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Role :",
          style: TextStyle(fontSize: 14),
        ),
        DropdownButton<String>(
          value: DbTools.gUtilisateur.Role,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.blueAccent),
          underline: Container(
            height: 2,
            color: Colors.blueAccent,
          ),
          onChanged: (newValue) {
            setState(() {
              DbTools.gUtilisateur.User = tecUser.text;
              DbTools.gUtilisateur.Motdepasse = tecPw.text;
              DbTools.gUtilisateur.Role = newValue!;
              print("value $newValue ${DbTools.gUtilisateur.Role}");
            });
          },
          items: <String>[
            DbTools.LibRoles(0),
            DbTools.LibRoles(1),
            DbTools.LibRoles(2),
            DbTools.LibRoles(3),
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 14)),
            );
          }).toList(),
        ),
      ],
    );
  }
}
