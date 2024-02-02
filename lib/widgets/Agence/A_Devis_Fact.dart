import 'package:TrocWeb_BackOff/Tools/Cde_Ent.dart';
import 'package:flutter/material.dart';
import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:TrocWeb_BackOff/Tools/Devis_Fact.dart';

class Devis_Fact extends StatefulWidget {
  @override
  Devis_FactState createState() => Devis_FactState();
}

class Devis_FactState extends State<Devis_Fact> {
  static bool isUpdate = false;

  final tecRemarque = TextEditingController();

  int nbLig = 7;
  List<TextEditingController> tecLib =
      List.generate(7, (i) => TextEditingController());
  List<TextEditingController> tecMt =
      List.generate(7, (i) => TextEditingController());
  List<TextEditingController> tecQte =
      List.generate(7, (i) => TextEditingController());

  List<double> dPx = [0, 0, 0, 0, 0, 0, 0];
  List<double> dQte = [0, 0, 0, 0, 0, 0, 0];
  List<double> dMtBrut = [0, 0, 0, 0, 0, 0, 0];
  List<double> dMt = [0, 0, 0, 0, 0, 0, 0];

  double tot_HT = 0.0;
  double tot_TVA = 0.0;
  double tot_TTC = 0.0;

  double Mt_Dem_HT = 0;
  double Mt_Dem_TTC = 0;
  double Mt_TX = 0;
  double Mt_TKS_TTC = 0;
  double Mt_TKS_HT = 0;
  double Mt_Client_HT = 0;
  double Mt_Client_TTC = 0;

  double tot_Client = 0.0;

  String Cde_DF = "D";
  bool Cde_EDT = false;

  Future AddDevis() async {


    print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈   AddDevis");

    DbTools.gCde_Ent = Cde_Ent(
        0,
        0,
        "D",
        false,
        0.0,
        "",
        "",
        0.0,
        0.0,
        0.0,
        0.0,
        false,
        false,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        0,
        0);
    await DbTools.addCde_Ent(DbTools.gCde_Ent);
  }

  Future AddFact() async {
    Cde_Ent wCde_Ent = DbTools.gCde_Ent;
    wCde_Ent.Cde_Ent_DF = "F";

    await DbTools.addCde_Ent(wCde_Ent);
    await DbTools.getCde_Ent();
  }

  Future AlimCDE() async {

    print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈   AlimCDE");

    if (Cde_DF == "D")
      DbTools.gCde_Ent = DbTools.ListCde_Ent[0];
    else {
      DbTools.gCde_Ent = DbTools.ListCde_Ent[1];
    }

    Cde_EDT = DbTools.gCde_Ent.Cde_Ent_EDT;

    DbTools.gCde_Ent.Cde_Ent_Tx_Tks = DbTools.gInventaire.Tx;

    tecRemarque.text = DbTools.gCde_Ent.Cde_Ent_Remarque;

    dMt[0] = DbTools.gCde_Ent.Cde_Ent_Rep_Net;
    if (dMt[0] == 0) dMt[0] = DbTools.gInventaireDet_Px_Achat;
    if (DbTools.gCde_Ent.Cde_Ent_Rep_Lib.isEmpty) {
      DbTools.gCde_Ent.Cde_Ent_Rep_Lib = "Reprise Net";
    }
    tecLib[0].text = DbTools.gCde_Ent.Cde_Ent_Rep_Lib;
    tecMt[0].text = dMt[0].toStringAsFixed(2);
    tecQte[0].text = "1.0";


    dMt[6] = DbTools.gCde_Ent.Cde_Ent_Rem_Net;
    if (dMt[6] == 0) dMt[6] = DbTools.gCde_Ent.Cde_Ent_Rem_Net;
    if (DbTools.gCde_Ent.Cde_Ent_Rem_Lib.isEmpty) {
      DbTools.gCde_Ent.Cde_Ent_Rem_Lib = "Remise Net";
    }
    tecLib[6].text = DbTools.gCde_Ent.Cde_Ent_Rem_Lib;
    tecMt[6].text = dMt[6].toStringAsFixed(2);
    tecQte[6].text = "1.0";


    if (DbTools.gCde_Ent.Cde_Ent_Lib_1.isEmpty) {
      DbTools.gCde_Ent.Cde_Ent_Lib_1 = "Décheterie";
      DbTools.gCde_Ent.Cde_Ent_Px_1 =
          DbTools.gEtablissement.MtDechM3 * DbTools.gInventaireDet_M3;
      DbTools.gCde_Ent.Cde_Ent_Qte_1 = 1;
    }

    tecLib[1].text = DbTools.gCde_Ent.Cde_Ent_Lib_1;
    dMt[1] = DbTools.gCde_Ent.Cde_Ent_Px_1;
    tecQte[1].text = DbTools.gCde_Ent.Cde_Ent_Qte_1.toStringAsFixed(2);
    tecMt[1].text = dMt[1].toStringAsFixed(2);

    tecLib[2].text = DbTools.gCde_Ent.Cde_Ent_Lib_2;
    dMt[2] = DbTools.gCde_Ent.Cde_Ent_Px_2;
    tecQte[2].text = DbTools.gCde_Ent.Cde_Ent_Qte_2.toStringAsFixed(2);
    tecMt[2].text = dMt[2].toStringAsFixed(2);

    tecLib[3].text = DbTools.gCde_Ent.Cde_Ent_Lib_3;
    dMt[3] = DbTools.gCde_Ent.Cde_Ent_Px_3;
    tecQte[3].text = DbTools.gCde_Ent.Cde_Ent_Qte_3.toStringAsFixed(2);
    tecMt[3].text = dMt[3].toStringAsFixed(2);

    tecLib[4].text = DbTools.gCde_Ent.Cde_Ent_Lib_4;
    dMt[4] = DbTools.gCde_Ent.Cde_Ent_Px_4;
    tecQte[4].text = DbTools.gCde_Ent.Cde_Ent_Qte_4.toStringAsFixed(2);
    tecMt[4].text = dMt[4].toStringAsFixed(2);
    tecLib[5].text = DbTools.gCde_Ent.Cde_Ent_Lib_5;
    dMt[5] = DbTools.gCde_Ent.Cde_Ent_Px_5;
    tecQte[5].text = DbTools.gCde_Ent.Cde_Ent_Qte_5.toStringAsFixed(2);
    tecMt[5].text = dMt[5].toStringAsFixed(2);

    Calcul();
  }

  Future initLib() async {
    print ("initLib A");
    await DbTools.getCde_Ent();
    await DbTools.getInventaireDets_Tot();

    if (DbTools.ListCde_Ent.length == 0) {
      await AddDevis();
      await DbTools.getCde_Ent();
    }

    print ("initLib B");

    if (DbTools.ListCde_Ent.length > 0) {
      if (DbTools.ListCde_Ent.length == 1)
        Cde_DF = "D";
      else
        Cde_DF = "F";

      await AlimCDE();
      Calcul();
    }

    print ("initLib C");


  }

  @override
  void initState() {
    print ("initState A");
    DbTools.gCde_Ent = Cde_Ent(
        0,
        0,
        "D",
        false,
        0.0,
        "",
        "",
        0.0,
        0.0,
        0.0,
        0.0,
        false,
        false,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        0,
        0);
    initLib();

    print ("initState B");
    tecRemarque.text = "";
    print ("initState C");


    for (int j = 0; j < nbLig; j++) {
      tecLib[j].text = "";
      tecMt[j].text = "0.0";
      tecQte[j].text = "0.0";
      dMt[j] = 0.0;
    }

    print ("initState D");


    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (DbTools.gCde_Ent.Cde_Entid == 0) return Container();


    return buildDevisFact(context);

  }

  Widget buildDevisFact(BuildContext context) {
    return Expanded(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          buildEntAff(context),
          Container(width: 20),
          buildDetAff(context),
          Container(width: 20),
        ]));
  }

  Widget buildEntAff(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 10, bottom: 0),
                child: Row(children: [
                  Text(
                      "Date de création : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(DbTools.gInventaire.DateCrt))}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Container(
                    width: 20,
                  ),
                  Text("Origine : ${DbTools.gInventaire.Origine}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 10, bottom: 0),
                child: Row(children: [
                  (!DbTools.isEtablissementsComm())
                      ? Text(
                          "",
                        )
                      :
                      //getEtablissementsbyID(int iID)
                      Text(
                          "Plateforme : ${DbTools.getEtablissementsbyID(DbTools.gInventaire.etabidOrigine).Libelle}",
                          style: TextStyle(
                              color: gColors.tks,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                  (!DbTools.isEtablissementsComm())
                      ? Text("",
                          style: TextStyle(
                              color: gColors.tks,
                              fontSize: 16,
                              fontWeight: FontWeight.bold))
                      :
                      //getEtablissementsbyID(int iID)
                      Spacer(),
                  (!DbTools.isEtablissementsComm())
                      ? Text(
                          "",
                        )
                      : Text("Montant Base : ${Mt_Dem_HT.toStringAsFixed(2)}",
                          style: TextStyle(
                              color: gColors.tks,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                  Spacer(),
                  (!DbTools.isEtablissementsComm())
                      ? Text(
                          "",
                        )
                      : Text("Taux : ${Mt_TX.toStringAsFixed(2)}%",
                          style: TextStyle(
                              color: gColors.tks,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                ]),
              ),
              Container(
                height: 5,
              ),
              Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              (DbTools.ListCde_Ent.length > 0)
                  ? buildEntDevis(context)
                  : Container(),
            ]));
  }

  Widget buildEntDevis(BuildContext context) {
    return Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Container(height: 10),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10, bottom: 0),
            child: Row(children: [
              Text(
                  "Date édition : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(DbTools.gCde_Ent.Cde_Ent_Date))}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10, bottom: 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 12, bottom: 0),
                    child: Text("Remarques : ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Flexible(
                    child: TextFormField(
                      onChanged: (text) {
                        isUpdateEcr();
                      },
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      controller: tecRemarque,
                      minLines: 12,
                      maxLines: 12,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
//                        contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      ),
                    ),
                  ),
                ]),
          ),
          buildTotal(context),
        ]));
  }

  Widget buildTotal(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Container(
              width: 50,
            )),
        Expanded(
          flex: 2,
          child: Column(children: [
            Container(
              height: 10,
            ),
            Column(
              children: [
                Container(
                    color: Colors.black,
                    padding: EdgeInsets.all(2),
                    child: Container(
                        color: Colors.white,
                        child: Table(
                            columnWidths: {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(1),
                            },
                            border: TableBorder.all(),
                            children: [
                              TableRow(children: [
                                DrawTableCell("Total HT   ",
                                    aTextAlign: TextAlign.left),
                                DrawTableCell(
                                    "${tot_HT.toStringAsFixed(2).toString()}",
                                    aTextAlign: TextAlign.right),
                              ]),
                              TableRow(children: [
                                DrawTableCell("Total TVA   ",
                                    aTextAlign: TextAlign.left),
                                DrawTableCell(
                                    "${tot_TVA.toStringAsFixed(2).toString()}",
                                    aTextAlign: TextAlign.right),
                              ]),
                              TableRow(children: [
                                DrawTableCell("Total TTC   ",
                                    aTextAlign: TextAlign.left),
                                DrawTableCell(
                                    "${tot_TTC.toStringAsFixed(2).toString()}",
                                    aTextAlign: TextAlign.right),
                              ]),
                            ]))),
                Container(
                  height: 10,
                ),
                Container(
                    color: Colors.black,
                    padding: EdgeInsets.all(2),
                    child: Container(
                        color: Colors.white,
                        child: Table(
                            columnWidths: {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(1),
                            },
                            border: TableBorder.all(),
                            children: [
                              TableRow(children: [
                                DrawTableCell("Total Client   ",
                                    aTextAlign: TextAlign.left),
                                DrawTableCell(
                                    "${tot_Client.toStringAsFixed(2).toString()}",
                                    aTextAlign: TextAlign.right),
                              ]),
                            ]))),
              ],
            ),
          ]),
        ),
      ],
    );
  }

  Widget buildDetAff(BuildContext context) {
    return Expanded(
        flex: 3,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 10, bottom: 0),
                child: Row(children: [
                  Radio(
                    value: "D",
                    groupValue: Cde_DF,
                    onChanged: (val) {
                      Cde_DF = "D";
                      AlimCDE();
                      Calcul();
                      setState(() {});
                    },
                  ),
                  Text("DEVIS",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  Spacer(),
                  (DbTools.ListCde_Ent.length != 2)
                      ? Container()
                      : Radio(
                          value: "F",
                          groupValue: Cde_DF,
                          onChanged: (val) {
                            Cde_DF = "F";
                            AlimCDE();
                            Calcul();
                            setState(() {});
                          },
                        ),
                  (DbTools.ListCde_Ent.length != 2)
                      ? Container()
                      : Text(Cde_EDT ? "FACTURE EDITEE" : "FACTURE A EDITER",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold)),
                ]),
              ),
              Container(
                height: 10,
              ),
              Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              Container(
                height: 10,
              ),
              buildMenuSave(context),
              Container(
                height: 10,
              ),
              Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              Container(
                height: 10,
              ),
              (DbTools.ListCde_Ent.length > 0)
                  ? buildDetAffSaisie(context)
                  : Container(),
            ]));
  }

  late BuildContext dialogContext;

  Widget buildDetAffSaisie(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 00, bottom: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Table(
                      columnWidths: {
                        0: FlexColumnWidth(8),
                        1: FlexColumnWidth(1),
                      },
                      border: TableBorder.all(),
                      children: [
                        drawTableRowRep(0),
                        drawTableRowRep(6),
                      ]),
                  Container(
                    height: 10,
                  ),
                  Table(
                      columnWidths: {
                        0: FlexColumnWidth(5),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                      },
                      border: TableBorder.all(),
                      children: [
                        drawTableHeader(),
                        drawTableRow(1),
                        drawTableRow(2),
                        drawTableRow(3),
                        drawTableRow(4),
                        drawTableRow(5),
                      ]),
                ])));
  }

  Widget buildMenuSave(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () async {
              await Save();
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
          (DbTools.gCde_Ent.Cde_Ent_DF == "D" && !DbTools.gCde_Ent.Cde_Ent_Fact)
              ? ElevatedButton(
                  onPressed: () async {
                    DbTools.gCde_Ent.Cde_Ent_Fact = true;
                    await Save();
                    await AddFact();
                    Cde_DF = "F";
                    AlimCDE();

                    setState(() {});
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor:gColors.tks,
              padding: const EdgeInsets.all(12.0),),


                  child: Text('Création de la Facture',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                )
              : Container(),
          ElevatedButton(
            onPressed: () async {
              Save();
              if (!DbTools.gCde_Ent.Cde_Ent_EDT &&
                  DbTools.gCde_Ent.Cde_Ent_DF == "F") {
                AlertDialog alert = AlertDialog(
                  title: Text("Impression de la facture"),
                  content: Text("Confirmer l'impression ?"),
                  actions: [
                    ElevatedButton(
                      child: Text("Annuler",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                    ),
                    ElevatedButton(
                      child: Text("Confirmer",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        DbTools.gCde_Ent.Cde_Ent_Date =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());

                        await Devis_FactImp.GenDevis();
                        DbTools.gCde_Ent.Cde_Ent_EDT = true;
                        await Save();
                        Navigator.pop(dialogContext);
                      },
                    ),
                  ],
                );
                // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    dialogContext = context;

                    return alert;
                  },
                );
              } else
                {
                  await Devis_FactImp.GenDevis();
                }

              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              padding: const EdgeInsets.all(12.0),),
            child: Text(Cde_EDT ? 'Réimpression' : 'Impression',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
        ]);
  }

  TableRow drawTableRowRep(int aIndex) {
    return TableRow(children: [
      DrawTableCellEdtTxt(tecLib[aIndex], aTextAlign: TextAlign.left),
      DrawTableCellEdt(tecMt[aIndex]),
    ]);
  }

  TableRow drawTableRow(int aIndex) {
    if (!DbTools.isEtablissementsComm()) {
      return TableRow(children: [
        DrawTableCellEdtTxt(tecLib[aIndex], aTextAlign: TextAlign.left),
        DrawTableCellEdt(tecMt[aIndex]),
        DrawTableCellEdt(tecQte[aIndex]),
        DrawTableCell("${dMt[aIndex].toStringAsFixed(2).toString()}",
            aTextAlign: TextAlign.right, aTop: 20)
      ]);
    } else {
      return TableRow(children: [
        DrawTableCellEdtTxt(tecLib[aIndex], aTextAlign: TextAlign.left),
        DrawTableCellEdt(tecMt[aIndex]),
        DrawTableCellEdt(tecQte[aIndex]),
        DrawTableCellTx("${dMtBrut[aIndex].toStringAsFixed(2).toString()}",
            "${dMt[aIndex].toStringAsFixed(2).toString()}")
      ]);
    }
  }

  TableRow drawTableHeader() {
    return TableRow(children: [
      DrawTableCell("Libellé", aTextAlign: TextAlign.left, aTop: 5),
      DrawTableCell("Prix HT", aTextAlign: TextAlign.right, aTop: 5),
      DrawTableCell("Qte", aTextAlign: TextAlign.right, aTop: 5),
      DrawTableCell("Montant HT", aTextAlign: TextAlign.right, aTop: 5),
    ]);
  }

  Widget DrawTableCellH(String aTxt,
      {TextAlign aTextAlign = TextAlign.left, double aTop = 5.0}) {
    return Padding(
        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: aTop, bottom: 0.0),
        child: Text(aTxt,
            textAlign: aTextAlign,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
  }

  Widget DrawTableCell(String aTxt,
      {TextAlign aTextAlign = TextAlign.left, double aTop = 5.0}) {
    return Padding(
        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: aTop, bottom: 5.0),
        child: Text(aTxt,
            textAlign: aTextAlign,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
  }

  Widget DrawTableCellTx(String aTxt, String aTxt2) {
    return Padding(
        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 0.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("$aTxt",
                  textAlign: TextAlign.left,
                  style:
                      TextStyle(color: gColors.LinearGradient1, fontSize: 16)),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text("$aTxt2",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ));
  }

  Widget DrawTableCellEdt(TextEditingController aTextEditingController,
      {TextAlign aTextAlign = TextAlign.right}) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: TextFormField(
        enabled: !Cde_EDT,
        onChanged: (text) {
          print("onChanged");
          Calcul();
          setState(() {});
        },
        textAlign: aTextAlign,
        textAlignVertical: TextAlignVertical.top,
        controller: aTextEditingController,
        maxLines: 1,
        style: TextStyle(
          fontSize: 16,
        ),
        keyboardType:
            TextInputType.numberWithOptions(decimal: true, signed: false),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
          TextInputFormatter.withFunction((oldValue, newValue) {
            try {
              final text = newValue.text;
              if (text.isNotEmpty) double.parse(text);
              return newValue;
            } catch (e) {}
            return oldValue;
          }),
        ],
      ),
    );
  }

  Widget DrawTableCellEdtTxt(TextEditingController aTextEditingController,
      {TextAlign aTextAlign = TextAlign.right}) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: TextFormField(
          enabled: !Cde_EDT,
          onChanged: (text) {
            isUpdateEcr();
          },
          textAlign: aTextAlign,
          textAlignVertical: TextAlignVertical.top,
          controller: aTextEditingController,
          maxLines: 1,
          style: TextStyle(
            fontSize: 16,
          ),
          keyboardType: TextInputType.name),
    );
  }

  void Calcul() {
    Mt_Dem_HT = 0;
    Mt_Dem_TTC = 0;
    Mt_TX = 0;
    Mt_TKS_TTC = 0;
    Mt_TKS_HT = 0;
    Mt_Client_HT = 0;
    Mt_Client_TTC = 0;

    print("≈~~~~~~~~~~~~~~~~~~~~~~~~ Calcul A");

    double MtRep = double.parse(tecMt[0].text);
    double QteRep = double.parse(tecQte[0].text);
    dMt[0] = DbTools.dp(MtRep * QteRep, 2);

    double MtRem = double.parse(tecMt[6].text);
    double QteRem = double.parse(tecQte[6].text);
    dMt[6] = DbTools.dp(MtRem * QteRem, 2);


    double wTx_tks = 1;
    if (DbTools.isEtablissementsComm()) {
      for (int j = 1; j < nbLig-1; j++) {
        double MtLig = 0;
        double QteLig = 0;

        try {
          MtLig = double.parse(tecMt[j].text);

          QteLig = double.parse(tecQte[j].text);

          if (QteLig == 0 && MtLig > 0) {
            QteLig = 1;
            tecQte[j].text = "1.00";
          }
        } catch (e) {}

        dPx[j] = MtLig;
        dQte[j] = QteLig;
        dMtBrut[j] = DbTools.dp(MtLig * QteLig, 2);
        Mt_Dem_HT += dMtBrut[j];
      }

      if ( DbTools.gInventaire.TxForce != 0)
        {
        if ( DbTools.gInventaire.TxForce == 999)
            Mt_TX = 0;
          else
            Mt_TX = DbTools.gInventaire.TxForce;
        }
      else if (Mt_Dem_HT < 1000)
        Mt_TX = 30;
      else if (Mt_Dem_HT < 2000)
        Mt_TX = 25;
      else
        Mt_TX = 20;


      if (DbTools.gInventaire.Origine == "HEXA")
        Mt_TX = 5;


      double txTVA = DbTools.gEtablissement.TxTVA;
      Mt_Dem_TTC = Mt_Dem_HT * (1 + txTVA / 100);
      Mt_TKS_HT = Mt_Dem_HT * Mt_TX / 100;
      Mt_TKS_TTC = Mt_TKS_HT * (1 + txTVA / 100);
      Mt_Client_HT = Mt_Dem_HT + Mt_TKS_HT;
      Mt_Client_TTC = Mt_Client_HT * (1 + txTVA / 100);

      DbTools.gInventaire.Mt_Dem_HT = Mt_Dem_HT;
      DbTools.gInventaire.Mt_TKS_HT = Mt_TKS_HT;
      DbTools.gInventaire.Tx = Mt_TX;

      wTx_tks = 1 + (DbTools.gInventaire.Tx / 100);
    }

    tot_HT = 0.0;
    tot_TVA = 0.0;
    tot_TTC = 0.0;

    for (int j = 1; j < nbLig-1; j++) {
      double MtLig = 0;
      double QteLig = 0;

      try {
        MtLig = double.parse(tecMt[j].text);
        QteLig = double.parse(tecQte[j].text);
      } catch (e) {}

      dPx[j] = MtLig;
      dQte[j] = QteLig;

      dMtBrut[j] = DbTools.dp(MtLig * QteLig, 2);

      dMt[j] = DbTools.dp(MtLig * QteLig * wTx_tks, 2);
      tot_HT += dMt[j];
    }

    double txTVA = DbTools.gEtablissement.TxTVA;
    tot_TVA = DbTools.dp(tot_HT * txTVA / 100, 2);
    tot_TTC = tot_HT + tot_TVA;

    tot_Client = tot_TTC - dMt[0]- dMt[6];
    isUpdateEcr();
  }

  void isUpdateEcr() {
    print("isUpdateEcr ${tecLib[0].text} ${DbTools.gCde_Ent.Cde_Ent_Rep_Lib}");

    isUpdate = dMt[0] != DbTools.gCde_Ent.Cde_Ent_Rep_Net ||
        tecLib[0].text != DbTools.gCde_Ent.Cde_Ent_Rep_Lib ||

        dMt[6] != DbTools.gCde_Ent.Cde_Ent_Rem_Net ||
        tecLib[6].text != DbTools.gCde_Ent.Cde_Ent_Rem_Lib ||

        dPx[1] != DbTools.gCde_Ent.Cde_Ent_Px_1 ||
        dQte[1] != DbTools.gCde_Ent.Cde_Ent_Qte_1 ||
        tecLib[1].text != DbTools.gCde_Ent.Cde_Ent_Lib_1 ||
        dPx[2] != DbTools.gCde_Ent.Cde_Ent_Px_2 ||
        dQte[2] != DbTools.gCde_Ent.Cde_Ent_Qte_2 ||
        tecLib[2].text != DbTools.gCde_Ent.Cde_Ent_Lib_2 ||
        dPx[3] != DbTools.gCde_Ent.Cde_Ent_Px_3 ||
        dQte[3] != DbTools.gCde_Ent.Cde_Ent_Qte_3 ||
        tecLib[3].text != DbTools.gCde_Ent.Cde_Ent_Lib_3 ||
        dPx[4] != DbTools.gCde_Ent.Cde_Ent_Px_4 ||
        dQte[4] != DbTools.gCde_Ent.Cde_Ent_Qte_4 ||
        tecLib[4].text != DbTools.gCde_Ent.Cde_Ent_Lib_4 ||
        dPx[5] != DbTools.gCde_Ent.Cde_Ent_Px_5 ||
        dQte[5] != DbTools.gCde_Ent.Cde_Ent_Qte_5 ||
        tecLib[5].text != DbTools.gCde_Ent.Cde_Ent_Lib_5 ||
        tecRemarque.text != DbTools.gCde_Ent.Cde_Ent_Remarque;
    setState(() {});
  }

  Future<void> Save() async {
    DbTools.gCde_Ent.Cde_Ent_Rep_Net = dMt[0];
    DbTools.gCde_Ent.Cde_Ent_Rep_Lib = tecLib[0].text.replaceAll("'", "\'");

    DbTools.gCde_Ent.Cde_Ent_Rem_Net = dMt[6];
    DbTools.gCde_Ent.Cde_Ent_Rem_Lib = tecLib[6].text.replaceAll("'", "\'");



    double MtLig = double.parse(tecMt[1].text);
    DbTools.gCde_Ent.Cde_Ent_Px_1 = MtLig;
    double QteLig = double.parse(tecQte[1].text);
    DbTools.gCde_Ent.Cde_Ent_Qte_1 = QteLig;
    DbTools.gCde_Ent.Cde_Ent_Mt_1 = dMtBrut[1];
    DbTools.gCde_Ent.Cde_Ent_Net_1 = dMt[1];
    DbTools.gCde_Ent.Cde_Ent_Lib_1 = tecLib[1].text.replaceAll("'", "\'");

    MtLig = double.parse(tecMt[2].text);
    DbTools.gCde_Ent.Cde_Ent_Px_2 = MtLig;
    QteLig = double.parse(tecQte[2].text);
    DbTools.gCde_Ent.Cde_Ent_Qte_2 = QteLig;
    DbTools.gCde_Ent.Cde_Ent_Mt_2 = dMtBrut[2];
    DbTools.gCde_Ent.Cde_Ent_Net_2 = dMt[2];
    DbTools.gCde_Ent.Cde_Ent_Lib_2 = tecLib[2].text.replaceAll("'", "\'");

    MtLig = double.parse(tecMt[3].text);
    DbTools.gCde_Ent.Cde_Ent_Px_3 = MtLig;
    QteLig = double.parse(tecQte[3].text);
    DbTools.gCde_Ent.Cde_Ent_Qte_3 = QteLig;
    DbTools.gCde_Ent.Cde_Ent_Mt_3 = dMtBrut[3];
    DbTools.gCde_Ent.Cde_Ent_Net_3 = dMt[3];
    DbTools.gCde_Ent.Cde_Ent_Lib_3 = tecLib[3].text.replaceAll("'", "\'");

    MtLig = double.parse(tecMt[4].text);
    DbTools.gCde_Ent.Cde_Ent_Px_4 = MtLig;
    QteLig = double.parse(tecQte[4].text);
    DbTools.gCde_Ent.Cde_Ent_Qte_4 = QteLig;
    DbTools.gCde_Ent.Cde_Ent_Mt_4 = dMtBrut[4];
    DbTools.gCde_Ent.Cde_Ent_Net_4 = dMt[4];
    DbTools.gCde_Ent.Cde_Ent_Lib_4 = tecLib[4].text.replaceAll("'", "\'");

    MtLig = double.parse(tecMt[5].text);
    DbTools.gCde_Ent.Cde_Ent_Px_5 = MtLig;
    QteLig = double.parse(tecQte[5].text);
    DbTools.gCde_Ent.Cde_Ent_Qte_5 = QteLig;
    DbTools.gCde_Ent.Cde_Ent_Mt_5 = dMtBrut[5];
    DbTools.gCde_Ent.Cde_Ent_Net_5 = dMt[5];
    DbTools.gCde_Ent.Cde_Ent_Lib_5 = tecLib[5].text.replaceAll("'", "\'");

    DbTools.gCde_Ent.Cde_Ent_Remarque = tecRemarque.text..replaceAll("'", "\'");

    DbTools.gCde_Ent.Cde_Ent_Tot_HT = tot_HT;
    DbTools.gCde_Ent.Cde_Ent_Tot_TVA = tot_TVA;
    DbTools.gCde_Ent.Cde_Ent_Tot_TTC = tot_TTC;
    DbTools.gCde_Ent.Cde_Ent_Tot_CLIENT = tot_Client;

    await DbTools.setCde_Ent();
    await DbTools.setInventaire();

    await initLib();
  }
}
