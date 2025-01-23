import 'dart:async';
import 'dart:math';

import 'package:TrocWeb_BackOff/Tools/Etablissement.dart';
import 'package:TrocWeb_BackOff/Tools/InventaireAction.dart';
import 'package:TrocWeb_BackOff/Tools/InventaireDet.dart';
import 'package:TrocWeb_BackOff/Tools/Upload.dart';
import 'package:TrocWeb_BackOff/widgets/Agence/A_Devis_Fact.dart';
import 'package:TrocWeb_BackOff/widgets/Agence/A_DialogNotif.dart';
import 'package:TrocWeb_BackOff/widgets/Agence/A_Dialog_50_100.dart';
import 'package:TrocWeb_BackOff/widgets/Agence/A_Dialog_PT_50_100.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:flutter/services.dart';

import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'dart:js' as js;
import 'package:toggle_switch/toggle_switch.dart';



final StreamController ctrl = StreamController<bool>.broadcast();

DateTime DateTime_Action = DateTime.now();

class A_Inventaire extends StatefulWidget {
  @override
  A_InventaireState createState() => A_InventaireState();
}

class A_InventaireState extends State<A_Inventaire> {
  late ActionDataSource actionDataSource;

  DateTime DateTime_Action = DateTime.parse("2009-01-01");

  final tecNom          = TextEditingController();
  final tecPresc          = TextEditingController();
  final tecadresse1          = TextEditingController();
  final tecadresse2          = TextEditingController();
  final teccp          = TextEditingController();
  final tecville          = TextEditingController();
  final tectel          = TextEditingController();
  final tecmail          = TextEditingController();
  final tecCI          = TextEditingController();
  final tecPiece          = TextEditingController();
  final tecObjet          = TextEditingController();
  final tecPx_Vente     = TextEditingController();
  final tecPx_Achat     = TextEditingController();
  final tecTemps      = TextEditingController();
  final tecM3         = TextEditingController();
  final tecTri          = TextEditingController();
  final tecDem        = TextEditingController();
  final tecMan        = TextEditingController();
  final tecAutre         = TextEditingController();
  final tecMt_Dem_HT    = TextEditingController();
  final tecTxForce          = TextEditingController();
  final tecfNom          = TextEditingController();
  final tecfadresse1          = TextEditingController();
  final tecfadresse2          = TextEditingController();
  final tecfcp          = TextEditingController();
  final tecfville          = TextEditingController();
  final tecftel          = TextEditingController();
  final tecfmail          = TextEditingController();





  double dTx = 0;
  double dTxForce = 0;

  double txTVA = DbTools.gEtablissement.TxTVA;

  double Mt_Dem_HT = 0;
  double Mt_Dem_TTC = 0;
  double Mt_TX = 0;
  double Mt_TKS_TTC = 0;
  double Mt_TKS_HT = 0;
  double Mt_Client_HT = 0;
  double Mt_Client_TTC = 0;


  bool FinCh_Opt_1 = false;
  bool FinCh_Opt_2 = false;
  bool FinCh_Opt_3 = false;
  bool FinCh_Opt_4 = false;

  static bool isUpdate = false;
  static bool isUpdateObj = false;

  int etabid = -1;

  int AffAccept = 0;
  int AffDem = 0;

  late Future<List<InventaireDet>> lfInventairePieces;
  late Future<List<InventaireDet>> lfInventaireObjets;
  List<InventaireDet> ListInventaireObj = [];

  int ListInventaireObj_LastID = -1;

  String Status = 'pending';
  int iStatus = -1;

  String Origine = 'Agence';
  String Source = 'Agence';

  String Nature = 'Autre';

  int SelCol = -1;
  int SelID = -1;
  bool onCellTap = false;

  String CDEid = "";

  String wSelPiece = "";
  int _selectedIndex = -1;
  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  int _selectedIndexObj = -1;
  _onSelectedObj(int index) {
    setState(() => _selectedIndexObj = index);
  }

  bool isVisibleObj = false;
  bool isVisiblePhoto = false;
  bool isVisiblePhoto0 = false;

  bool isLoadPhoto = false;
  String LoadPhotoTxt = "";

  int pageIndex = 0;

  bool isLoad = false;
  double textSize = 14.0;

  late List<Widget> imgSlider;
  List<Uint8List> picList = [];
  final CarouselController cC = CarouselController();

  List<String> imgList = [];

  int MaxUpdateAction = -1;

  bool isInitAction = false;

  String wTxt = "";

  String wTxtCb_1 = "";
  String wTxtCb_2 = "";
  String wTxtCb_3 = "";
  String wTxtCb_4 = "";

  String wTxtNewCt = "";

  Widget wImage = Container();

  Future<List<InventaireDet>> loadDataPieces() async {
    await DbTools.getParamNotif();

    await DbTools.getInventaireDetsPieces();
    await DbTools.getInventaireDetPhotosAll();

    return DbTools.ListInventaireDetPieces;
  }

  Future Reload() async {
    print("Reload");
    isLoad = false;

    lfInventairePieces = loadDataPieces();
    var s = Colors.greenAccent;
    await DbTools.getInventaireDets();

    await DbTools.getCde_Ent();

    await DbTools.CalculMtDecheterie();

    await DbTools.Calcul_Montants();

    Mt_Dem_HT = DbTools.gInventaire.Mt_Dem_HT;
    Mt_TKS_HT = DbTools.gInventaire.Mt_TKS_HT;

    if (!isInitAction) {
      await DbTools.genInventaireActions();
      await DbTools.updateInventaireAction();
      await DbTools.initInventaireActions();
      isInitAction = true;
    }

    await DbTools.getInventaireActions();

    await DbTools.setInventaireStatus();

    _selectedIndexObj = -1;
    _onSelected(0);
    isVisibleObj = false;

    if (DbTools.ListInventaireDet.length > 0) {
      InventaireDet inventaireDet = DbTools.ListInventaireDet[0];
      wSelPiece = inventaireDet.piece;
      DbTools.gInventaireDetPiece = wSelPiece;
      lfInventaireObjets = loadDataObjets();
    }

    wTxtCb_1 = "L'intervention a été réalisée dans son intégralité";
    wTxtCb_2 =
        "Absence de dommages (casse, objets manquants pris par erreur, fuite d'eau...)";
    wTxtCb_3 = "Clés remises";
    wTxtCb_4 = "Balayage de fin de chantier réalisé";

    wTxt = "1/ l'intervention a été réalisée dans son intégralité \n"
        "2/ Absence de dommages (casse, objets manquants pris par erreur, fuite d'eau...) \n"
        "3/ clés remises \n"
        "4/ Balayage de fin de chantier réalisé";

    var wImgPath = DbTools.SrvImg + "Sign_${DbTools.gInventaire.id}.jpg";
    Random random = new Random();
    int V = random.nextInt(10444) + 1;
    String wImgPathRanDom = wImgPath + "?v=$V";

    wImage = Image.network(wImgPathRanDom, width: 300, height: 300,
        errorBuilder: (context, error, stackTrace) {
      print("error $error");
      wTxt = "";
      return Container();
    });

    print("wImage ${wImage.toString()}");

    await DbTools.getInventaireDets_Tot();

    isLoad = true;

    setState(() {_selectedIndex = 0;});
  }

  void initLib() async {
    await Reload();
  }

  Future<List<InventaireDet>> loadDataObjets() async {
    ListInventaireObj.clear();
    DbTools.gListInventaireObj.clear();

    int i = 0;
    DbTools.ListInventaireDet.forEach((element) async {
      ListInventaireObj_LastID = -1;

      if (element.piece.trim() == wSelPiece.trim() &&
          ((DbTools.CD_FdC == "I" &&
                  element.libelle != "--- Fin de Chantier ---") ||
              (DbTools.CD_FdC == "F" &&
                  element.libelle == "--- Fin de Chantier ---"))) {
        if (element.id == DbTools.gLastIDObj) {
          ListInventaireObj_LastID = i;
        }
        ListInventaireObj.add(element);
        DbTools.gListInventaireObj.add(element);
        i++;
      }
    });
    print("ListInventaireObj ${ListInventaireObj.length}");

    return ListInventaireObj;
  }

  late StreamSubscription subscription;

  @override
  void dispose() {
    subscription.cancel(); //Not working

    tecNom.dispose();
    tecPresc.dispose();
    tecadresse1.dispose();
    tecadresse2.dispose();
    teccp.dispose();
    tecville.dispose();
    tectel.dispose();
    tecmail.dispose();
    tecCI.dispose();
    tecPiece.dispose();
    tecObjet.dispose();
    tecPx_Vente.dispose();
    tecPx_Achat.dispose();
    tecTemps.dispose();
    tecM3.dispose();
    tecTri.dispose();
    tecDem.dispose();
    tecMan.dispose();
    tecAutre.dispose();
    tecMt_Dem_HT.dispose();
    tecTxForce.dispose();
    tecfNom.dispose();
    tecfadresse1.dispose();
    tecfadresse2.dispose();
    tecfcp.dispose();
    tecfville.dispose();
    tecftel.dispose();
    tecfmail.dispose();


    super.dispose();
  }

  @override
  void initState() {
    print("initState");

    DbTools.notif.addListener(() {
      print('DbTools.notif.addListener');

      InventaireDet inventaireDet =
          DbTools.gListInventaireObj[DbTools.gLastObjIndex];
      onTapObj(DbTools.gLastObjIndex);
    });

    DbTools.CD_FdC = "I";

    subscription = ctrl.stream.asBroadcastStream().listen((data) {
      Reload();
      Status = DbTools.LibStatus(DbTools.gInventaire.Status);
      iStatus = DbTools.gInventaire.Status;
    });

    DbTools.isVisChamps.clear();
    for (int i = 0; i < 17; ++i) {
      DbTools.isVisChamps.add(i <= 2);
    }

    super.initState();
    initLib();

    tecNom.text = DbTools.gInventaire.nom;
    tecPresc.text = DbTools.gInventaire.Presc;
    tecadresse1.text = DbTools.gInventaire.adresse1;
    tecadresse2.text = DbTools.gInventaire.adresse2;
    teccp.text = DbTools.gInventaire.cp;
    tecville.text = DbTools.gInventaire.ville;
    tectel.text = DbTools.gInventaire.tel;
    tecmail.text = DbTools.gInventaire.mail;
    tecCI.text = DbTools.gInventaire.CarteIdentite;

    Status = DbTools.LibStatus(DbTools.gInventaire.Status);
    iStatus = DbTools.gInventaire.Status;

    Origine = DbTools.gInventaire.Origine;
    Source = DbTools.gInventaire.Source;

    if (DbTools.gInventaire.NatureBien == "")
      DbTools.gInventaire.NatureBien = "Autre";
    Nature = DbTools.gInventaire.NatureBien;

    etabid = DbTools.gInventaire.etabid;

    FinCh_Opt_1 = DbTools.gInventaire.FinCh_Opt_1;
    FinCh_Opt_2 = DbTools.gInventaire.FinCh_Opt_2;
    FinCh_Opt_3 = DbTools.gInventaire.FinCh_Opt_3;
    FinCh_Opt_4 = DbTools.gInventaire.FinCh_Opt_4;

    if (DbTools.gInventaire.TxForce == DbTools.gInventaire.Tx) {
      DbTools.gInventaire.TxForce = 0;
    }

    if (DbTools.gInventaire.Origine == "HEXA") DbTools.gInventaire.Tx = 5;

    dTx = DbTools.gInventaire.Tx;
    dTxForce = DbTools.gInventaire.TxForce;

    Mt_Dem_HT = DbTools.gInventaire.Mt_Dem_HT;

    tecMt_Dem_HT.text = Mt_Dem_HT.toString();
    tecTxForce.text = dTxForce.toString();

    CalculPT();

    tecfNom.text = DbTools.gInventaire.fnom;
    tecfadresse1.text = DbTools.gInventaire.fadresse1;
    tecfadresse2.text = DbTools.gInventaire.fadresse2;
    tecfcp.text = DbTools.gInventaire.fcp;
    tecfville.text = DbTools.gInventaire.fville;
    tecftel.text = DbTools.gInventaire.ftel;
    tecfmail.text = DbTools.gInventaire.fmail;
    DbTools.gInventaireDetPiece = "---   ---";

    AffAccept = DbTools.gInventaire.AffAccept;
    AffDem = DbTools.gInventaire.AffDem;

    print(
        ">>>>> AffDem  >>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~~~~ ${AffDem} ${DbTools.gInventaire.AffDem}");

    isUpdateAdr();
  }

  int tabBar_Index = 0;
  TabBar get _tabBar => TabBar(
        onTap: (index) async {
          CalculPT();

          tabBar_Index = index;
          DbTools.CD_FdC = "I";
          if (index == 2) {
            DbTools.CD_FdC = "I";
            print("TabBar onTap I ${DbTools.CD_FdC}");
            await Reload();
            lfInventaireObjets = loadDataObjets();
            onTapObj(0);
          } else if (index == 4) {
            DbTools.CD_FdC = "F";
            print("TabBar onTap F ${DbTools.CD_FdC}");
            await Reload();
            lfInventaireObjets = loadDataObjets();
            onTapObj(0);
          } else {
            setState(() {});
          }
        },
        tabs: [
          Row(children: [
            Icon(Icons.view_quilt),
            SizedBox(width: 5),
            Text("Suivi")
          ]),
          Row(children: [
            Icon(Icons.perm_identity),
            SizedBox(width: 5),
            Text("Adresses")
          ]),
          Row(children: [
            Icon(Icons.chrome_reader_mode),
            SizedBox(width: 5),
            Text("Inventaire")
          ]),
          Row(children: [
            Icon(Icons.list_alt),
            SizedBox(width: 5),
            Text("Devis / Facture")
          ]),
          Row(children: [
            Icon(Icons.engineering),
            SizedBox(width: 5),
            Text("Fin de Chantier")
          ]),
        ],
        indicatorColor: Colors.deepPurpleAccent,
      );

  void CalculPT() {
    print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈   CalculPT");

    Mt_Dem_HT = DbTools.gInventaire.Mt_Dem_HT;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var CD_FdC = DbTools.CD_FdC;
    print("build ${CD_FdC} $tabBar_Index");

    return DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            backgroundColor: gColors.secondary,
            title: Container(
              color: gColors.secondary,
              child: Text("Trokeur débarras : Affaires",
                  style: TextStyle(
                    fontSize: 14,
                    color: gColors.white,
                  )),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20.0),
              child: ColoredBox(
                color: gColors.primary,
                child: _tabBar,
              ),
            ),
          ),
          body: TabBarView(children: [
//            (tabBar_Index == 0) ? buildTabSuivi(context)    : Container(),
            //          (tabBar_Index == 1) ? buildTabAdr(context)      : Container(),
            //        (tabBar_Index == 2) ? buildTabInvStack(context) : Container(),
            //      (tabBar_Index == 3) ? buildTabFdCStack(context) : Container(),

            buildTabSuivi(context),
            buildTabAdr(context),
            buildTabInvStack(context),
            buildTabDevisFact(context),
            buildTabFdCStack(context),
          ]),
        ));
  }

  Widget buildTabDevisFact(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10, bottom: 0),
              child: Row(children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    tecNom.text,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  width: 20,
                ),
                DD_Status(),
                Container(
                  width: 20,
                ),
                Container(
                  width: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isUpdate ? gColors.primary : gColors.LinearGradient1,
                    padding: const EdgeInsets.all(12.0),
                  ),
                  onPressed: () async {
                    await Save();
                  },
                  child: Text('Save',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ])),
          Container(
            height: 5,
          ),
          Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          Devis_Fact(),

//          buildDevisFact(context),
        ]);
  }

  Widget buildDevisFact(BuildContext context) {
    return Expanded(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Expanded(
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Container(
                      width: 20,
                    ),
                    DbTools.gUtilisateurLogin.Role.contains("Plateforme")
                        ? DD_Origine()
                        : Text("Origine : ${DbTools.gInventaire.Origine}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10, bottom: 0),
                  child: Row(children: [
                    DbTools.gUtilisateurLogin.Role.contains("Plateforme")
                        ? DD_Etabs()
                        : (!DbTools.isEtablissementsComm())
                            ? Text("")
                            :
                            //getEtablissementsbyID(int iID)
                            Text(
                                "Plateforme : ${DbTools.getEtablissementsbyID(DbTools.gInventaire.etabidOrigine).Libelle}",
                                style: TextStyle(
                                    color: gColors.tks,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                  ]),
                ),
                DbTools.gUtilisateurLogin.Role.contains("Plateforme")
                    ? builSaisiePT()
                    : (!DbTools.isEtablissementsComm())
                        ? Container()
                        : builSaisieAG(),
              ])),
          Container(width: 20),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Container(
                  height: 20,
                ),
                Expanded(
                  child: Row(children: [
                    Container(
                      width: 30,
                    ),
                    Expanded(child: ActionGridWidget()),
                  ]),
                ),
              ])),
          Container(width: 20),
        ]));
  }

  Widget buildTabAdr(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
        Padding(
          padding:
              const EdgeInsets.only(left: 20.0, right: 0, top: 0, bottom: 0),
          child: Row(
            children: [
              Text("Adresse de Facturation",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Container(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  tecfNom.text = tecNom.text;
                  tecfadresse1.text = tecadresse1.text;
                  tecfadresse2.text = tecadresse2.text;
                  tecfcp.text = teccp.text;
                  tecfville.text = tecville.text;
                  tecftel.text = tectel.text;
                  tecfmail.text = tecmail.text;

                  isUpdateAdr();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: gColors.primary,
                  padding: const EdgeInsets.all(12.0),
                ),
                child: Text('Recopie Adresse ',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              Container(width: 200),
              ElevatedButton(
                onPressed: () async {
                  String Adr =
                      tecadresse1.text + " " + teccp.text + " " + tecville.text;

                  print("https://www.google.com/maps/place/$Adr");
                  js.context.callMethod(
                      'open', ["https://www.google.com/maps/place/$Adr"]);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: gColors.primary,
                  padding: const EdgeInsets.all(12.0),
                ),
                child: Text('Localisation Google Map',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              Container(width: 200),
              (DbTools.gUtilisateurLogin.Role != "Plateforme")
                  ? (DbTools.gEtablissement.IsPT == 0 &&
                          DbTools.gEtablissement.IsNewCT == 1)
                      ? ElevatedButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  A_Dialog_50_100(true),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gColors.primary,
                            padding: const EdgeInsets.all(12.0),
                          ),
                          child: Text('Qualification',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        )
                      : Container()
                  : ElevatedButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,

                          builder: (BuildContext context) =>
                              A_Dialog_PT_50_100(),
                        );
                        await DbTools.getInventaires();
                        AffDem = DbTools.gInventaire.AffDem;
                        Reload();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gColors.primary,
                        padding: const EdgeInsets.all(12.0),
                      ),
                      child: Text('Qualification 50/100',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
            ],
          ),
        ),
        Container(
          child: Row(children: [
            Flexible(
              flex: 5,
              child: buildfAdr(context),
            ),
          ]),
        ),
      ],
    );
  }

  Widget buildTabFdCStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        buildTabFdC(context),
        isLoadPhoto
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width:
                                  1, //                   <--- border width here
                            )),
                        child: Column(
                          children: [
                            SpinKitThreeBounce(
                              color: gColors.primary,
                              size: 50.0,
                            ),
                            Container(
                              color: Colors.white,
                              child: Text(
                                LoadPhotoTxt,
                                style: TextStyle(
                                    fontSize: 36, color: gColors.secondary),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              )
            : Stack(),
      ],
    );
  }

  Widget buildTabFdC(BuildContext context) {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10, bottom: 0),
          child: Row(children: [
            Expanded(
              child: Text(
                tecNom.text,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              width: 20,
            ),
            CD_FdC_Widget(),
            Container(
              width: 20,
            ),
            DD_Status(),
            Container(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoadPhoto = true;
                  LoadPhotoTxt = "Création du PDF";
                });

                imgList.clear();
                DbTools.PdfBitmapList.clear();
                DbTools.PdfBitmapNameList.clear();
                DbTools.PdfBitmapSign.clear();

                DbTools.ListInventaireDetPhotoAll.forEach((element) async {
                  DbTools.ListInventaireDet.forEach((elementdet) async {
                    if (element.invdetid == elementdet.id) {
                      if (((DbTools.CD_FdC == "I" &&
                              elementdet.libelle !=
                                  "--- Fin de Chantier ---") ||
                          (DbTools.CD_FdC == "F" &&
                              elementdet.libelle ==
                                  "--- Fin de Chantier ---"))) {
                        String SrvImgPhoto = DbTools.SrvImg + "Photo_${element.invdetid}_${element.photo}.jpg";
                        imgList.add(SrvImgPhoto);
                      }
                    }
                  });
                });

                Random random = new Random();
                int V = random.nextInt(10444) + 1;

                var wImgPath =
                    DbTools.SrvImg + "Sign_${DbTools.gInventaire.id}.jpg";
                String wImgPathRanDom = wImgPath + "?v=$V";

                Uint8List pic =
                    await DbTools.networkImageToByte(wImgPathRanDom);
                if (pic.length > 1) {
                  PdfBitmap image = await PdfBitmap(pic);
                  DbTools.PdfBitmapSign.add(image);
                }

                print("LoadPdfBitmap >");

                int imgListlength = imgList.length;

                print("LoadPdfBitmap  imgListlength ${imgListlength} ");

                for (int i = 0; i < imgListlength; ++i) {
                  String wTmp = imgList[i] + "?v=$V";
                  print("LoadPdfBitmap $i / $imgListlength ${wTmp} ");

                  setState(() {
                    LoadPhotoTxt =
                        "Chargement des photos $i / ${imgList.length - 1}";
                    if (i == imgList.length - 1)
                      LoadPhotoTxt = "Création du PDF";
                  });

                  Uint8List pic = await DbTools.networkImageToByte(wTmp);
                  if (pic.length > 1) {
//                    pic = await DbTools.resizeImage(pic);

//                    var wImage = Image(image: ResizeImage(MemoryImage(pic), width: 100, height: 200));

                    PdfBitmap image = await PdfBitmap(pic);
                    print(
                        "--------->>>> LoadPdfBitmap ${pic.length} ${image.height}X${image.width}");
                    DbTools.PdfBitmapList.add(image);
                    DbTools.PdfBitmapNameList.add(wTmp);
                    print("AddOK");
                  }
                }

                print("LoadPdfBitmap <");

                await Upload.SaveFilePicker(3);
                setState(() {
                  isLoadPhoto = false;
                  LoadPhotoTxt = "";
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primary,
                padding: const EdgeInsets.all(12.0),
              ),
              child: Text('Rapport Fin de chantier',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await Save();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isUpdate ? gColors.primary : gColors.LinearGradient1,
                padding: const EdgeInsets.all(12.0),
              ),
              child: Text('Save',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ])),
      Container(
        height: 5,
      ),
      Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      Container(
        height: 10,
      ),
      Flexible(
          child: Row(
        children: [
          Flexible(
            flex: 2,
            child: listPiece(),
          ),
          Flexible(
            flex: 4,
//            child: isVisiblePhoto ? buildPhotoFdC() : Container(),
            child: buildPhotoFdC(),
          ),
          Flexible(
            flex: 3,
//            child: isVisiblePhoto ? buildSign() : Container(),
            child: buildSign(),
          ),
        ],
      ))
    ]);
  }

  Widget buildTabInvStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        buildTabInv(context),
        isLoadPhoto
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width:
                                  1, //                   <--- border width here
                            )),
                        child: Column(
                          children: [
                            SpinKitThreeBounce(
                              color: gColors.primary,
                              size: 50.0,
                            ),
                            Container(
                              color: Colors.white,
                              child: Text(
                                LoadPhotoTxt,
                                style: TextStyle(
                                    fontSize: 36, color: gColors.secondary),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              )
            : Stack(),
      ],
    );
  }

  Widget buildTabInv(BuildContext context) {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10, bottom: 0),
          child: Row(children: [
            Expanded(
              child: Text(
                tecNom.text,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              width: 20,
            ),
            CD_FdC_Widget(),
            Container(
              width: 20,
            ),
            DD_Status(),
            Container(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await Upload.SaveFilePicker(0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primary,
                padding: const EdgeInsets.all(12.0),
              ),
              child: Text('XLS',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomDialog(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primary,
                padding: const EdgeInsets.all(12.0),
              ),
              child: Text('Liste',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoadPhoto = true;
                  LoadPhotoTxt = "Chargement des photos";
                });

                imgList.clear();
                DbTools.PdfBitmapList.clear();
                DbTools.PdfBitmapNameList.clear();

                DbTools.ListInventaireDetPhotoAll.forEach((element) async {
                  String SrvImgPhoto = DbTools.SrvImg +
                      "Photo_${element.invdetid}_${element.photo}.jpg";
                  imgList.add(SrvImgPhoto);
                });

                Random random = new Random();
                int V = random.nextInt(10444) + 1;

                print("LoadPdfBitmap >");

                int imgListlength = imgList.length;

//                imgListlength = 10;
                print("LoadPdfBitmap  imgListlength ${imgListlength} ");

                for (int i = 0; i < imgListlength; ++i) {
                  String wTmp = imgList[i] + "?v=$V";
                  print("LoadPdfBitmap  ${wTmp} ");

                  setState(() {
                    LoadPhotoTxt = "Chargement des photos $i / ${imgList.length - 1}";
                    if (i == imgList.length - 1)
                      LoadPhotoTxt = "Création du PDF";
                  });

                  Uint8List pic = await DbTools.networkImageToByte(wTmp);
                  if (pic.length > 1) {
//                    pic = await DbTools.resizeImage(pic);
                    PdfBitmap image = await PdfBitmap(pic);

                    print(
                        "--------->>>> LoadPdfBitmap ${pic.length} ${image.height}X${image.width}");
                    DbTools.PdfBitmapList.add(image);
                    DbTools.PdfBitmapNameList.add(wTmp);
                  }
                }

                await Upload.SaveFilePicker(2);

                setState(() {
                  isLoadPhoto = false;
                  LoadPhotoTxt = "";
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primary,
                padding: const EdgeInsets.all(12.0),
              ),
              child: Text('Photos',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await Save();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isUpdate ? gColors.primary : gColors.LinearGradient1,
                padding: const EdgeInsets.all(12.0),
              ),
              child: Text('Save',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ])),
      Container(
        height: 5,
      ),
      Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      Container(
        height: 10,
      ),
      Flexible(
          child: Row(
        children: [
          Flexible(
            flex: 2,
            child: listPiece(),
          ),
          Flexible(
            flex: 2,
            child: listObjet(),
          ),
          Flexible(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 0.0, top: 10, bottom: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await DbTools.addInventairesDet();
                          //              await Reload();
                          await DbTools.getInventaireDets();

                          if (wSelPiece == "") {
                            wSelPiece = "---   ---";
                            print("ADD  loadDataObjets A");
                            lfInventaireObjets = loadDataObjets();
                          } else {
                            print("ADD  loadDataObjets B");
                            await loadDataObjets();
                          }

                          if (ListInventaireObj_LastID >= 0) {
                            print("onTapObj $ListInventaireObj_LastID");

                            InventaireDet inventaireDet =
                                ListInventaireObj[ListInventaireObj_LastID];
                            onTapObj(ListInventaireObj_LastID);
                          }

                          setState(() {});
                        },
                        child: Icon(Icons.add),
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(CircleBorder()),
                          padding:
                              WidgetStateProperty.all(EdgeInsets.all(20)),
                          backgroundColor: WidgetStateProperty.all(
                              Colors.green), // <-- Button color
                          overlayColor:
                              WidgetStateProperty.resolveWith<Color?>(
                                  (states) {
                            if (states.contains(WidgetState.pressed))
                              return gColors.primary;
                            return null; // <-- Splash color
                          }),
                        ),
                      ),
                    ],
                  ))),
          Flexible(
            flex: 3,
            child: buildObjet(),
          ),
          Flexible(
            flex: 4,
            child: buildPhoto(),
          ),
        ],
      ))
    ]);
  }

  Widget buildTabSuivi(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10, bottom: 0),
              child: Row(children: [
                Expanded(
                  child: Text(
                    tecNom.text,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(width: 20),
                (!DbTools.isEtablissementsComm())
                    ? Container()
                    : ElevatedButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) => DialogNotif(
                                DateTime.now(),
                                false,
                                DbTools.gUtilisateurLogin.Role
                                        .contains("Plateforme")
                                    ? "toTKS+"
                                    : "toAg"),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gColors.push,
                          padding: const EdgeInsets.all(12.0),
                        ),
                        child: Text(
                            '${DbTools.gUtilisateurLogin.Role.contains("Plateforme") ? " Push Agence" : "Push TKS+"}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                Container(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          DialogNotif(DateTime.now(), false, "MsgClient"),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.push,
                    padding: const EdgeInsets.all(12.0),
                  ),
                  child: Text("Message Client",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: 20,
                ),
                DD_Status(),
                Container(
                  width: 20,
                ),
                Container(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Save();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isUpdate ? gColors.primary : gColors.LinearGradient1,
                    padding: const EdgeInsets.all(12.0),
                  ),
                  child: Text('Save',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ])),
          Container(
            height: 5,
          ),
          Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          buildSuivi(context),
        ]);
  }

  void isUpdateAdr() {
    print("Nature ${Nature} ${DbTools.gInventaire.NatureBien}");
    isUpdate = tecNom.text != DbTools.gInventaire.nom ||
        tecPresc.text != DbTools.gInventaire.Presc ||
        tecadresse1.text != DbTools.gInventaire.adresse1 ||
        tecadresse2.text != DbTools.gInventaire.adresse2 ||
        teccp.text != DbTools.gInventaire.cp ||
        tecville.text != DbTools.gInventaire.ville ||
        tectel.text != DbTools.gInventaire.tel ||
        tecmail.text != DbTools.gInventaire.mail ||
        tecCI.text != DbTools.gInventaire.CarteIdentite ||
        iStatus != DbTools.gInventaire.Status ||
        Origine != DbTools.gInventaire.Origine ||
        Source != DbTools.gInventaire.Source ||
        etabid != DbTools.gInventaire.etabid ||
        double.parse(tecMt_Dem_HT.text) != DbTools.gInventaire.Mt_Dem_HT ||
        double.parse(tecTxForce.text) != DbTools.gInventaire.TxForce ||
        tecfNom.text != DbTools.gInventaire.fnom ||
        tecfadresse1.text != DbTools.gInventaire.fadresse1 ||
        tecfadresse2.text != DbTools.gInventaire.fadresse2 ||
        tecfcp.text != DbTools.gInventaire.fcp ||
        tecfville.text != DbTools.gInventaire.fville ||
        tecftel.text != DbTools.gInventaire.ftel ||
        tecfmail.text != DbTools.gInventaire.fmail ||
        FinCh_Opt_1 != DbTools.gInventaire.FinCh_Opt_1 ||
        FinCh_Opt_2 != DbTools.gInventaire.FinCh_Opt_2 ||
        FinCh_Opt_3 != DbTools.gInventaire.FinCh_Opt_3 ||
        FinCh_Opt_4 != DbTools.gInventaire.FinCh_Opt_4 ||
        Nature != DbTools.gInventaire.NatureBien ||
        AffAccept != DbTools.gInventaire.AffAccept ||
        AffDem != DbTools.gInventaire.AffDem;

    setState(() {});
  }

  Future<void> Save() async {
    DbTools.gInventaire.nom = tecNom.text;
    DbTools.gInventaire.Presc = tecPresc.text;
    DbTools.gInventaire.adresse1 = tecadresse1.text;
    DbTools.gInventaire.adresse2 = tecadresse2.text;
    DbTools.gInventaire.adresse1 = tecadresse1.text;
    DbTools.gInventaire.adresse2 = tecadresse2.text;
    DbTools.gInventaire.cp = teccp.text;
    DbTools.gInventaire.ville = tecville.text;
    DbTools.gInventaire.tel = tectel.text;
    DbTools.gInventaire.mail = tecmail.text;
    DbTools.gInventaire.CarteIdentite = tecCI.text;
    DbTools.gInventaire.Status = iStatus;
    DbTools.gInventaire.Origine = Origine;
    DbTools.gInventaire.Source = Source;
    DbTools.gInventaire.etabid = etabid;
    DbTools.gInventaire.Mt_Dem_HT = double.parse(tecMt_Dem_HT.text);
    DbTools.gInventaire.TxForce = double.parse(tecTxForce.text);
    DbTools.gInventaire.NatureBien = Nature;
    DbTools.gInventaire.AffAccept = AffAccept;
    DbTools.gInventaire.AffDem = AffDem;

    if (DbTools.gInventaire.TxForce == DbTools.gInventaire.Tx) {
      DbTools.gInventaire.TxForce = 0;
      tecTxForce.text = "0";
    }

    print(
        "……………………………………… Save gInventaire.TxForce ${DbTools.gInventaire.TxForce}");

    DbTools.gInventaire.fnom = tecfNom.text;
    DbTools.gInventaire.fadresse1 = tecfadresse1.text;
    DbTools.gInventaire.fadresse2 = tecfadresse2.text;
    DbTools.gInventaire.fcp = tecfcp.text;
    DbTools.gInventaire.fville = tecfville.text;
    DbTools.gInventaire.ftel = tecftel.text;
    DbTools.gInventaire.fmail = tecfmail.text;

    DbTools.gInventaire.FinCh_Opt_1 = FinCh_Opt_1;
    DbTools.gInventaire.FinCh_Opt_2 = FinCh_Opt_2;
    DbTools.gInventaire.FinCh_Opt_3 = FinCh_Opt_3;
    DbTools.gInventaire.FinCh_Opt_4 = FinCh_Opt_4;

    await DbTools.setInventaireActionLot(MaxUpdateAction);
    await DbTools.setInventaireStatus();

    Status = DbTools.LibStatus(DbTools.gInventaire.Status);
    iStatus = DbTools.gInventaire.Status;

    print("Save $Status $iStatus");

    await DbTools.setInventaire();
    MaxUpdateAction = -1;
    isUpdateAdr();
    await Reload();
  }

  Widget buildSuivi(BuildContext context) {
    String wComm = "";
    if (DbTools.gInventaire.AffAccept == 2) wComm = "Commission à 1€";
    if (DbTools.gInventaire.AffAccept == 3) wComm = "Commission à 50€";
    if (DbTools.gInventaire.AffAccept == 4) wComm = "Commission à 100€";

    return Expanded(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Container(
                  height: 20,
                ),
                Expanded(
                  child: Row(children: [
                    Container(
                      width: 30,
                    ),
                    Expanded(child: ActionGridWidget()),
                  ]),
                ),
              ])),
          Expanded(
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Container(
                      width: 20,
                    ),
                    DbTools.gUtilisateurLogin.Role.contains("Plateforme")
                        ? DD_Origine()
                        : Text("Origine : ${DbTools.gInventaire.Origine}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                    Container(
                      width: 20,
                    ),
                    DD_Nature(),
                    Container(
                      width: 20,
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              A_Dialog_50_100(true),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gColors.primary,
                        padding: const EdgeInsets.all(12.0),
                      ),
                      child: Text('Qualification',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),



                  ]),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10, bottom: 0),
                  child: Row(children: [
                    DbTools.gUtilisateurLogin.Role.contains("Plateforme")
                        ? DD_Etabs()
                            : Text(
                            "Plateforme : ${DbTools.getEtablissementsbyID(DbTools.gInventaire.etabidOrigine).Libelle}",
                            style: TextStyle(
                                color: gColors.tks,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                  ]),
                ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10, bottom: 0),
                      child: Row(children: [
                        DbTools.gUtilisateurLogin.Role.contains("Plateforme")
                            ? Text(
                          "${DbTools.gInventaire.Date_Push}",
                          style: TextStyle(
                              color: gColors.push,
                              fontSize: 16,
                              fontWeight: FontWeight.bold))
                            :Container()
                      ]),
                    ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10, bottom: 0),
                  child: Row(children: [
                    DbTools.gUtilisateurLogin.Role.contains("Plateforme")
                        ? (DbTools.getEtablissementsbyID(etabid).IsNewCT != 1)
                            ? Container()
                            : Row(
                                children: [
                                  Text(
                                      "=> ${wComm} - ${DbTools.gInventaire.Date_Accept}",
                                      style: TextStyle(
                                          color: gColors.tks,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                        padding: const EdgeInsets.only(
                                        left: 43.0,
                                        right: 0.0,
                                        top: 0,
                                        bottom: 0),
                                    child: ToggleSwitch(
                                        minWidth: 90.0,
                                        activeBgColors: [
                                          [Colors.orangeAccent],
                                          [Colors.green],
                                          [Colors.greenAccent],
                                        ],
                                        customWidths: [
                                          90,
                                          110,
                                          110,
                                        ],
                                        customTextStyles: [
                                          TextStyle(
                                            color: Colors.white,
                                          ),
                                        ],
                                        initialLabelIndex: AffDem,
                                        totalSwitches: 3,
                                        labels: [
                                          'Comm. 1€',
                                          'Comm. 50€',
                                          'Comm. 100€'
                                        ],
                                        onToggle: (index) {
                                          print('switched to A : $index');
                                          AffDem = index!;
                                          print('switched to B : $index');
                                          isUpdateAdr();
                                        }),
                                  ),
                                ],
                              )
                        : (DbTools.gInventaire.AffAccept < 99)
                            ? Text(
                                "=> ${wComm} - ${DbTools.gInventaire.Date_Accept}",
                                style: TextStyle(
                                    color: gColors.tks,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))
                            : Text("")
                  ]),
                ),

                DbTools.gUtilisateurLogin.Role.contains("Plateforme")
                    ? builSaisiePT()
                    : (!DbTools.isEtablissementsComm())
                        ? Container()
                        : builSaisieAG(), // A

                Container(height: 10),
                Container(
                  height: 1,
                  color: Colors.black,
                ),
                Container(height: 10),

                DbTools.gInventaire.DateInv.isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 10, bottom: 0),
                        child: Row(children: [
                          Text(
                              "Date Inventaire : ${DbTools.gInventaire.DateInv}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ]),
                      ),

                DbTools.gInventaire.DateDeb.isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 10, bottom: 0),
                        child: Row(children: [
                          Text("Date Débarras : ${DbTools.gInventaire.DateDeb}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ]),
                      ),
              ])),
        ]));
  }

  Widget builSaisiePT() {
    return Column(children: [
      Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 0),
        child: Row(children: [
          Container(
            width: 180,
            child: Text("Montant Inventaire HT : ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: 70,
            child: Text(
              "${DbTools.Mt_Dem_HT_Inv.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            width: 20,
          ),
          Container(
            width: 180,
            child: Text("Montant Devis HT :",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: 70,
            child: Text(
              "${DbTools.Mt_Dem_HT_Dev.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            width: 20,
          ),
          Container(
            width: 180,
            child: Text("Montant Facture HT :",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: 70,
            child: Text(
              "${DbTools.Mt_Dem_HT_Fact.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ]),
      ),
      DbTools.isEtablissementsComm()
          ? Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10, bottom: 0),
              child: Row(children: [
                Container(
                  width: 180,
                  child: Text("Taux Forcé aa: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: 90,
                  child: TextFormField(
                    onChanged: (text) {
                      isUpdateAdr();
                      MaxUpdateAction = 70;

                      dTxForce = double.parse(text);

                      CalculPT();

                      setState(() {});
                    },
                    controller: tecTxForce,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ], //
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
//                                      labelText: "Montant de base HT",
                    ),
                  ),
                ),
                Container(
                  width: 20,
                ),
                Container(
                  width: 180,
                  child: Text("Taux calculé :",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: 70,
                  child: Text(
                    "${dTx.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ),
              ]),
            )
          : Container(),
    ]);
  }

  Widget builSaisieAG() {
    return Column(children: [
      Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 0),
        child: Row(children: [
          Container(
            width: 180,
            child: Text("Montant Inventaire HT : ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: 70,
            child: Text(
              "${DbTools.Mt_Dem_HT_Inv.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            width: 20,
          ),
          Container(
            width: 180,
            child: Text("Montant Devis HT :",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: 70,
            child: Text(
              "${DbTools.Mt_Dem_HT_Dev.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            width: 20,
          ),
          Container(
            width: 180,
            child: Text("Montant Facture HT :",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: 70,
            child: Text(
              "${DbTools.Mt_Dem_HT_Fact.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ]),
      ),
      !DbTools.isEtablissementsComm()
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10, bottom: 0),
              child: Row(children: [
                Container(
                  width: 180,
                  child: Text("Taux Forcé : ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: 90,
                  child: Text(
                    "${dTxForce.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ),
                Container(
                  width: 20,
                ),
                Container(
                  width: 180,
                  child: Text("Taux calculé :",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: 70,
                  child: Text(
                    "${dTx.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ),
              ])),
    ]);
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
                        flex: 2,
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
                            hintText: "Entrez le nom du client",
                          ),
                        ),
                      ),
                      Container(
                        width: 20,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tecPresc,
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
                            labelText: "Prescripteur",
                            hintText: "Entrez le nom du prescripteur",
                          ),
                        ),
                      ),
                      Container(
                        width: 20,
                      ),
                      DD_Status(),
                      Container(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await Save();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isUpdate
                              ? gColors.primary
                              : gColors.LinearGradient1,
                          padding: const EdgeInsets.all(12.0),
                        ),
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
                            hintText: "Entrez l'Adresse du Client",
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
                            hintText: "Entrez l'Adresse du Client",
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
                              hintText: "Code postal",
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
                              hintText: "Entrez la ville du Client",
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black12,
                            padding: const EdgeInsets.all(12.0),
                          ),
                          child: Text('??',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          width: 20,
                        ),
                        Flexible(
                          flex: 4,
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
                              hintText: "Téléphone",
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                        ),
                        Flexible(
                          flex: 8,
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
                              hintText: "Entrez le mail du Client",
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                        ),
                        Flexible(
                          flex: 6,
                          child: TextFormField(
                            onChanged: (text) {
                              isUpdateAdr();
                            },
                            controller: tecCI,
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
                              labelText: "Carte d'identite",
                              hintText: "Carte d'identite",
                            ),
                          ),
                        ),
                      ],
                    )),
              ]),
        ));
  }

  Widget buildfAdr(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10.0, top: 0, bottom: 0),
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
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tecfNom,
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
                            hintText: "Entrez le nom du client",
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
                          controller: tecfadresse1,
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
                            hintText: "Entrez l'Adresse du Client",
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
                          controller: tecfadresse2,
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
                            hintText: "Entrez l'Adresse du Client",
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
                            controller: tecfcp,
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
                              hintText: "Code postal",
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
                            controller: tecfville,
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
                              hintText: "Entrez la ville du Client",
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (tecfcp.text.length > 0)
                              await DbTools.ReadServer_CpVilles(tecfcp.text);
                            else
                              await DbTools.ReadServer_CpVilles(tecfville.text);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  fCpV_dialog(context),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black12,
                            padding: const EdgeInsets.all(12.0),
                          ),
                          child: Text('??',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          width: 20,
                        ),
                        Flexible(
                          flex: 4,
                          child: TextFormField(
                            onChanged: (text) {
                              isUpdateAdr();
                            },
                            controller: tecftel,
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
                              hintText: "Téléphone",
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                        ),
                        Flexible(
                          flex: 8,
                          child: TextFormField(
                            onChanged: (text) {
                              isUpdateAdr();
                            },
                            controller: tecfmail,
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
                              hintText: "Entrez le mail du Client",
                            ),
                          ),
                        ),
                      ],
                    )),
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
          style: ElevatedButton.styleFrom(
            foregroundColor: gColors.primary,
          ),
          child: const Text('Annuler',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  //***************************

  Widget fListViewCpVille(data) {
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
                    tecfcp.text = DbTools.tCp[index];
                    tecfville.text = DbTools.tVille[index];
                  });
                  Navigator.of(context).pop();
                },
                title: Text("${DbTools.tCp[index]} - ${DbTools.tVille[index]}"),
              ));
        },
      ),
    );
  }

  Widget fCpV_dialog(BuildContext context) {
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
        child: fListViewCpVille(DbTools.tCp),
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: gColors.primary,
          ),
          child: const Text('Annuler',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  //***************************
  //***************************

  Widget listPiece() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 10),
      child: Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.black12,
            width: 1,
          ),
        ),
        child: ListePiece(),
      ),
    );
  }

  Widget ListePiece() {
    return FutureBuilder<List<InventaireDet>>(
      future: lfInventairePieces,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<InventaireDet>? data = snapshot.data;

          return CupertinoScrollbar(
               child: ListViewPieces(data));
        } else if (snapshot.hasError) {
          return Text("Liste vide");
        } else {
//          print("data " + snapshot.connectionState.toString());
        }
        return Column(
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
                "Lecture des données ${DbTools.ListInventaireDet.length.toString()}",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ]);
      },
    );
  }

  ListView ListViewPieces(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          InventaireDet inventaireDet = data?.elementAt(index);

          return Container(
              color: _selectedIndex == index
                  ? gColors.primary
                  : (index.isOdd ? Colors.black12 : Colors.white),
              /**/
              child: ListTile(
                onTap: () async {
                  print("onTap ListViewPieces");
                  _selectedIndexObj = -1;
                  _onSelected(index);
                  isVisibleObj = false;
                  wSelPiece = inventaireDet.piece;
                  DbTools.gInventaireDetPiece = wSelPiece;
                  lfInventaireObjets = loadDataObjets();
                  onTapObj(0);
                },
                contentPadding: const EdgeInsets.only(
                    left: 2.0, right: 2.0, top: 0, bottom: 0),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    AlertDialog alert = AlertDialog(
                      title: Text("Suppression Pièce"),
                      content: Text("Confirmer la suppression ?"),
                      actions: [
                        ElevatedButton(
                          child: Text("Annuler",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                        ElevatedButton(
                          child: Text("Confirmer",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            DbTools.gInventaireDet = inventaireDet;

                            print(
                                "onPressed del piece ${DbTools.gInventaireDet.libelle}");
                            DbTools.delInventairesPiece();
                            await Reload();

                            setState(() {});
                            Navigator.of(dialogContext).pop();
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
                  },
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              inventaireDet.piece.toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ]),
                  ],
                ),
              ));
        });
  }

  //***************************
  //***************************
  //***************************

  Widget buildSign() {
    return Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: FinCh_Opt_1,
                    onChanged: (value) async {
                      print("value $value");
                      FinCh_Opt_1 = value!;
                      isUpdateAdr();
                      setState(() => {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(wTxtCb_1,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: FinCh_Opt_2,
                    onChanged: (value) async {
                      FinCh_Opt_2 = value!;
                      isUpdateAdr();
                      setState(() => {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(wTxtCb_2,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: FinCh_Opt_3,
                    onChanged: (value) async {
                      FinCh_Opt_3 = value!;
                      isUpdateAdr();
                      setState(() => {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(wTxtCb_3,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: FinCh_Opt_4,
                    onChanged: (value) async {
                      FinCh_Opt_4 = value!;
                      isUpdateAdr();
                      setState(() => {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(wTxtCb_4,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  )
                ]),
            wImage,
          ],
        ));
  }

  Widget listObjet() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 10),
      child: Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.black12,
            width: 1,
          ),
        ),
        child: ListInventaireObj.length == 0 ? Container() : ListeObjet(),
      ),
    );
  }

  final ScrollController _firstController = ScrollController();

  Widget ListeObjet() {
    return FutureBuilder<List<InventaireDet>>(
      future: lfInventaireObjets,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<InventaireDet>? data = snapshot.data;

          return Scrollbar(

            child: ListViewObjets(data),
            controller: _firstController,
          );
        } else if (snapshot.hasError) {
          return Text("Liste vide");
        } else {
          print("data obj" + snapshot.connectionState.toString());
        }
        return ListInventaireObj.length == 0
            ? Container()
            : Column(
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
                      "Lecture des données",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ]);
      },
    );
  }

  void onTapObj(int index) async {
    if (ListInventaireObj.length == 0) {
      picList.clear();
      isVisibleObj = false;
      isVisiblePhoto = false;
      isVisiblePhoto0 = false;
      return;
    }

    InventaireDet inventaireDet = ListInventaireObj[index];

    DbTools.gLastObjIndex = index;

    _onSelectedObj(index);
    isVisiblePhoto = false;
    isVisiblePhoto0 = false;
    isVisibleObj = _selectedIndexObj == index;

    consumerB_Inventaire.setState((state) async {
      state.isVisibleObj = isVisiblePhoto;
      state.isVisiblePhoto = isVisiblePhoto;
      state.isVisiblePhoto0 = isVisiblePhoto0;

      //          return;
    });

    DbTools.gInventaireDet = inventaireDet;

    await DbTools.getInventaireDetPhotos();

    print(
        "ListInventaireDetPhoto.length ${DbTools.ListInventaireDetPhoto.length}");

    imgList.clear();
    DbTools.ListInventaireDetPhoto.forEach((element) async {
      String SrvImgPhoto =
          DbTools.SrvImg + "Photo_${element.invdetid}_${element.photo}.jpg";

      imgList.add(SrvImgPhoto);
    });

    print("imgList.length ${imgList.length}");

    tecPiece.text = DbTools.gInventaireDet.piece;
    tecObjet.text = DbTools.gInventaireDet.libelle;

    tecPx_Vente.text = DbTools.gInventaireDet.Px_Vente.toString();
    tecPx_Achat.text = DbTools.gInventaireDet.Px_Achat.toString();
    tecTemps.text = DbTools.gInventaireDet.Temps.toString();
    tecM3.text = DbTools.gInventaireDet.M3.toString();

    tecTri.text = DbTools.gInventaireDet.Tri;
    tecDem.text = DbTools.gInventaireDet.Demontage;
    tecMan.text = DbTools.gInventaireDet.Manip_Delicate;

    CDEid = DbTools.gInventaireDet.CDE;
    tecAutre.text = DbTools.gInventaireDet.Autre;

    tecMt_Dem_HT.text = DbTools.gInventaire.Mt_Dem_HT.toString();
    tecTxForce.text = DbTools.gInventaire.TxForce.toString();

    setState(() {});

    Random random = new Random();
    int V = random.nextInt(10444) + 1;

    picList.clear();
    for (int i = 0; i < imgList.length; ++i) {
      String wTmp = imgList[i] + "?v=$V";

      print(">>>>>>>>>>>> onTapObj $i wTmp ${wTmp}");
      Uint8List pic = await DbTools.networkImageToByte(wTmp);
      print(">>>>>>>>>>>> onTapObj pic ${pic.length}");



      if (pic.length > 1)
        picList.add(pic);
      else {
        final ByteData bytes = await rootBundle.load('images/ErrImg.png');
        final Uint8List piclist = bytes.buffer.asUint8List();
        picList.add(piclist);
      }
    }

    isVisiblePhoto = true;
    if (picList.length > 0) {
      pageIndex = 0;
      isVisiblePhoto0 = true;
    }

    print(">>>>>>>>>>>> onTapObj isVisiblePhoto ${isVisiblePhoto}");
    print(">>>>>>>>>>>> onTapObj isVisiblePhoto ${isVisiblePhoto}");
    print(">>>>>>>>>>>> onTapObj isVisiblePhoto0 ${isVisiblePhoto0}");

    setState(() {});

    consumerB_Inventaire.setState((state) async {
      state.isVisibleObj = isVisiblePhoto;
      state.isVisiblePhoto = isVisiblePhoto;
      state.isVisiblePhoto0 = isVisiblePhoto0;

      //          return;
    });

//    setState(() {});
  }

  late BuildContext dialogContext;

  ListView ListViewObjets(data) {
    return ListView.builder(
        itemCount: data.length,
        controller: _firstController,
        itemBuilder: (context, index) {
          InventaireDet inventaireDet = data?.elementAt(index);
          bool isSelected = false;
          return Container(
              color: _selectedIndexObj == index
                  ? gColors.primary
                  : (index.isOdd ? Colors.black12 : Colors.white),
              /**/
              child: ListTile(
                onTap: () async {
                  onTapObj(index);
                },
                contentPadding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 0, bottom: 0),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    AlertDialog alert = AlertDialog(
                      title: Text("Suppression Objet"),
                      content: Text("Confirmer la suppression ?"),
                      actions: [
                        ElevatedButton(
                          child: Text("Annuler",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () async {
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
                              int wselectedIndex = _selectedIndex;
                              String tmpSelPiece = inventaireDet.piece;

                              DbTools.gInventaireDet = inventaireDet;
                              print(
                                  "onPressed del obj ${ListInventaireObj.length}");

                              int wlen = ListInventaireObj.length;

                              await DbTools.delInventairesDet();

                              await Reload();
                              if (wlen > 1) {
                                _onSelected(wselectedIndex);
                                isVisibleObj = false;
                                wSelPiece = inventaireDet.piece;
                                DbTools.gInventaireDetPiece = wSelPiece;
                                lfInventaireObjets = loadDataObjets();
                              }

                              setState(() {});
                              Navigator.pop(dialogContext);

                              //                              Navigator.of(context).pop();
                            }),
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
                  },
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              inventaireDet.libelle,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14),
                            ),
                          ),
                        ]),
                  ],
                ),
              ));
        });
  }

  @override
  Widget DD_Status() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 0.0, right: 10.0, top: 0, bottom: 0),
          child: Text(
            "Statut :",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Text("$Status"),
/*
        DropdownButton<String>(
          value: Status,
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
              iStatus = DbTools.getStatusID(newValue!);
              Status = newValue;
              isUpdateAdr();
            });
          },




          items: <String>[
            DbTools.LibStatus(0),
            DbTools.LibStatus(1),
            DbTools.LibStatus(2),
            DbTools.LibStatus(3),
            DbTools.LibStatus(4),
            DbTools.LibStatus(5),
            DbTools.LibStatus(6),
            DbTools.LibStatus(7),
            DbTools.LibStatus(8),
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 14)),
            );
          }).toList(),
        ),
        */
      ],
    );
  }

  @override
  Widget DD_Nature() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 0.0, right: 10.0, top: 0, bottom: 0),
          child: Text(
            "Nature :",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        DropdownButton<String>(
          value: Nature,
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
              Nature = newValue!;
              isUpdateAdr();
            });
          },
          items: <String>[
            "Maison",
            "Appartement",
            "Cave",
            "Grenier",
            "Garage",
            "Autre",
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

  @override
  Widget DD_Origine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 0.0, right: 10.0, top: 0, bottom: 0),
          child: Text(
            "Origine :",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        DropdownButton<String>(
          value: Origine,
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
              Origine = newValue!;

              if (Origine == "HEXA") {
                dTxForce = 5;
                tecTxForce.text = dTxForce.toString();
              }

              isUpdateAdr();
            });
          },
          items: <String>[
            DbTools.LibOrigines(0),
            DbTools.LibOrigines(1),
            DbTools.LibOrigines(2),
            DbTools.LibOrigines(3),
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

  @override
  Widget DD_Source() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 0.0, right: 10.0, top: 0, bottom: 0),
          child: Text(
            "Source :",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        DropdownButton<String>(
          value: Source,
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
              Source = newValue!;
              isUpdateAdr();
            });
          },
          items: <String>[
            DbTools.LibSources(0),
            DbTools.LibSources(1),
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
  //****************************************

  void isUpdateObjet() async {
    await SaveDet();
/*
        isUpdateObj = tecPiece.text != DbTools.gInventaireDet.piece ||
        tecObjet.text != DbTools.gInventaireDet.libelle ||
        tecPx_Vente.text != DbTools.gInventaireDet.Px_Vente.toString() ||
        tecPx_Achat.text != DbTools.gInventaireDet.Px_Achat.toString() ||
        tecTemps.text != DbTools.gInventaireDet.Temps.toString() ||
        tecM3.text != DbTools.gInventaireDet.M3.toString() ||
        tecTri.text != DbTools.gInventaireDet.Tri ||
        tecDem.text != DbTools.gInventaireDet.Demontage ||
        tecMan.text != DbTools.gInventaireDet.Manip_Delicate ||
        CDEid != DbTools.gInventaireDet.CDE ||
        tecAutre.text != DbTools.gInventaireDet.Autre;
    setState(() {});
*/
  }

  Widget buildObjet() {
    return !isVisibleObj
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 0, bottom: 0),
            child: Form(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 0, bottom: 0),
                        child: Row(children: [CDEWidget()])),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10, bottom: 0),
                      child: TextFormField(
                        onChanged: (text) {
                          isUpdateObjet();
                        },
                        controller: tecPiece,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          labelText: "Pièce",
                          hintText: "Entrez le nom de la Pièce",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10, bottom: 0),
                      child: TextFormField(
                        onChanged: (text) {
                          isUpdateObjet();
                        },
                        controller: tecObjet,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          labelText: "Objet",
                          hintText: "Entrez le nom de l'objet",
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 10, bottom: 0),
                        child: Row(children: [
                          Flexible(
                            child: TextFormField(
                              onChanged: (text) {
                                isUpdateObjet();
                              },
                              controller: tecPx_Vente,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^(\d+)?\.?\d{0,2}'))
                              ], //
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                labelText: "Prix Ventes",
                                hintText: "Entrez le Prix Vente de l'objet",
                              ),
                            ),
                          ),
                          Container(
                            width: 20,
                          ),
                          Flexible(
                            child: TextFormField(
                              onChanged: (text) {
                                isUpdateObjet();
                              },
                              controller: tecPx_Achat,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                labelText: "Prix Achat",
                                hintText: "Entrez le Prix Achat de l'objet",
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
                                isUpdateObjet();
                              },
                              controller: tecTemps,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                labelText: "Temps",
                                hintText: "Entrez le Temps",
                              ),
                            ),
                          ),
                          Container(
                            width: 20,
                          ),
                          Flexible(
                            child: TextFormField(
                              controller: tecM3,
                              onChanged: (text) {
                                isUpdateObjet();
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                labelText: "M3",
                                hintText: "Entrez le M3",
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
                                isUpdateObjet();
                              },
                              controller: tecTri,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                labelText: "Tri",
                              ),
                            ),
                          ),
                          Container(
                            width: 20,
                          ),
                          Flexible(
                            child: TextFormField(
                              onChanged: (text) {
                                isUpdateObjet();
                              },
                              controller: tecDem,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                labelText: "Dém",
                              ),
                            ),
                          ),
                          Container(
                            width: 20,
                          ),
                          Flexible(
                            child: TextFormField(
                              onChanged: (text) {
                                isUpdateObjet();
                              },
                              controller: tecMan,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                labelText: "Manip",
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
                                isUpdateObjet();
                              },
                              controller: tecAutre,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                labelText: "Autres Contraintes",
                              ),
                            ),
                          ),
                        ])),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 10, bottom: 0),
                          child: Text("${DbTools.gInventaireDet.id}"),
                        ),

/*                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10, bottom: 0),
                      child: ElevatedButton(
                              onPressed: () async {
                                await SaveDet();
                              },
                              padding: const EdgeInsets.only(
                                  left: 50.0,
                                  right: 50.0,
                                  top: 12,
                                  bottom: 12),

                            color: isUpdateObj
                                ? gColors.primary
                                : gColors.LinearGradient1,

                        child: Text('Save',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                    ),*/
                      ],
                    )
                  ]),
            ));
  }

  Future<void> SaveDet() async {
    bool wMaj = (DbTools.gInventaireDet.piece != tecPiece.text);

    DbTools.gInventaireDet.piece = tecPiece.text;
    DbTools.gInventaireDet.libelle = tecObjet.text;
    DbTools.gInventaireDet.Px_Vente = double.parse(tecPx_Vente.text);
    DbTools.gInventaireDet.Px_Achat = double.parse(tecPx_Achat.text);
    DbTools.gInventaireDet.Temps = double.parse(tecTemps.text);
    DbTools.gInventaireDet.M3 = double.parse(tecM3.text);
    DbTools.gInventaireDet.Tri = tecTri.text;
    DbTools.gInventaireDet.Demontage = tecDem.text;
    DbTools.gInventaireDet.Manip_Delicate = tecMan.text;
    DbTools.gInventaireDet.CDE = CDEid;
    DbTools.gInventaireDet.Autre = tecAutre.text;

    await DbTools.setInventaireDet();
    if (wMaj) {
      loadDataPieces();
      lfInventairePieces = loadDataPieces();
      wSelPiece = DbTools.gInventaireDet.piece;
      DbTools.gInventaireDetPiece = wSelPiece;
    }
    await loadDataObjets();
    setState(() {});
  }

  Widget CD_FdC_Widget() {
    return Container();
  }

  Widget CDEWidget() {
    return Row(
//      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: "C",
          groupValue: CDEid,
          onChanged: (val) {
            setState(() {
              CDEid = "C";
              isUpdateObjet();
            });
          },
        ),
        Text(
          "C",
          style: new TextStyle(fontSize: 14.0),
        ),
        Radio(
          value: "D",
          groupValue: CDEid,
          onChanged: (val) {
            setState(() {
              CDEid = "D";
              isUpdateObjet();
            });
          },
        ),
        Text(
          "D",
          style: new TextStyle(fontSize: 14.0),
        ),
        Radio(
          value: "E",
          groupValue: CDEid,
          onChanged: (val) {
            setState(() {
              CDEid = "E";
              isUpdateObjet();
            });
          },
        ),
        Text(
          "E",
          style: new TextStyle(fontSize: 14.0),
        ),
        Radio(
          value: "",
          groupValue: CDEid,
          onChanged: (val) {
            setState(() {
              CDEid = "";
              isUpdateObjet();
            });
          },
        ),
        Text(
          "?",
          style: new TextStyle(fontSize: 14.0),
        ),
      ],
    );
  }

  Widget buildPhoto() {
    return consumerB_Inventaire.build(
      (ctx, state) {
        state.picList = picList;
        state.isVisibleObj = isVisibleObj;
        state.isVisiblePhoto = isVisiblePhoto;
        state.isVisiblePhoto0 = isVisiblePhoto0;

        return !state.isVisibleObj
            ? Container()
            : !state.isVisiblePhoto
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
                          "Lecture des Photos ...",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ])
                : Scaffold(
                    body: Column(
                      children: [
                        !state.isVisiblePhoto0
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      cC.animateToPage(0);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurpleAccent,
                                    ),
                                    child: Text('<<',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      cC.previousPage();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurpleAccent,
                                    ),
                                    child: Text('<',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  Text(
                                      "${pageIndex + 1}/${state.picList.length}",
                                      style: TextStyle(
                                        fontSize: 14,
                                      )),
                                  Container(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      cC.nextPage();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurpleAccent,
                                    ),
                                    child: Text('>',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      cC.animateToPage(picList.length - 1);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurpleAccent,
                                    ),
                                    child: Text('>>',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                        Container(
                          width: 10,
                        ),
                        BlockCarousel(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                consumerA_Inventaire.setState((state) async {
                                  state.imgList.clear();
                                  state.picList.clear();
                                });

                                await DbTools.getInventaireDetPhotos();

                                print(
                                    "ListInventaireDetPhoto.length ${DbTools.ListInventaireDetPhoto.length}");

                                imgList.clear();
                                DbTools.ListInventaireDetPhoto.forEach(
                                    (element) async {
                                  String SrvImgPhoto = DbTools.SrvImg +
                                      "Photo_${element.invdetid}_${element.photo}.jpg";
                                  imgList.add(SrvImgPhoto);
                                });

                                Random random = new Random();
                                int V = random.nextInt(10444) + 1;

                                picList.clear();
                                for (int i = 0; i < imgList.length; ++i) {
                                  String wTmp = imgList[i] + "?v=$V";

                                  print(">>>>>>>>>>>> wTmp ${wTmp}");

                                  Uint8List pic =
                                      await DbTools.networkImageToByte(wTmp);
                                  if (pic.length > 1)
                                    picList.add(pic);
                                  else {
                                    final ByteData bytes = await rootBundle
                                        .load('images/ErrImg.png');
                                    final Uint8List piclist =
                                        bytes.buffer.asUint8List();
                                    picList.add(piclist);
                                  }
                                }

                                isVisiblePhoto = true;
                                state.isVisiblePhoto = true;
                                if (picList.length > 0) {
                                  pageIndex = 0;
                                  isVisiblePhoto0 = true;
                                  state.isVisiblePhoto0 = true;
                                }
                                print("imgList.length ${imgList.length}");
                                setState(() {});
                              },
                              child: Icon(Icons.refresh),
                              style: ButtonStyle(
                                shape:
                                    WidgetStateProperty.all(CircleBorder()),
                                padding: WidgetStateProperty.all(
                                    EdgeInsets.all(20)),
                                backgroundColor: WidgetStateProperty.all(
                                    Colors
                                        .deepPurpleAccent), // <-- Button color
                                overlayColor:
                                    WidgetStateProperty.resolveWith<Color?>(
                                        (states) {
                                  if (states.contains(WidgetState.pressed))
                                    return gColors.primary;
                                  return null; // <-- Splash color
                                }),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await getImage();
                              },
                              child: Icon(Icons.add),
                              style: ButtonStyle(
                                shape:
                                    WidgetStateProperty.all(CircleBorder()),
                                padding: WidgetStateProperty.all(
                                    EdgeInsets.all(20)),
                                backgroundColor: WidgetStateProperty.all(
                                    Colors.green), // <-- Button color
                                overlayColor:
                                    WidgetStateProperty.resolveWith<Color?>(
                                        (states) {
                                  if (states.contains(WidgetState.pressed))
                                    return gColors.primary;
                                  return null; // <-- Splash color
                                }),
                              ),
                            ),
                            !state.isVisiblePhoto0
                                ? Container()
                                : ElevatedButton(
                                    onPressed: () async {
                                      int wIndex = DbTools
                                          .ListInventaireDetPhoto[pageIndex]
                                          .photo;

                                      await DbTools.removephoto_API_Post(
                                          wIndex);

                                      consumerA_Inventaire
                                          .setState((state) async {
                                        state.imgList.clear();
                                        state.picList.clear();
                                      });

                                      await DbTools.getInventaireDetPhotos();

                                      print(
                                          "ListInventaireDetPhoto.length ${DbTools.ListInventaireDetPhoto.length}");

                                      imgList.clear();
                                      DbTools.ListInventaireDetPhoto.forEach(
                                          (element) async {
                                        String SrvImgPhoto = DbTools.SrvImg +
                                            "Photo_${element.invdetid}_${element.photo}.jpg";
                                        imgList.add(SrvImgPhoto);
                                      });

                                      Random random = new Random();
                                      int V = random.nextInt(10444) + 1;

                                      picList.clear();
                                      for (int i = 0; i < imgList.length; ++i) {
                                        String wTmp = imgList[i] + "?v=$V";

                                        print(">>>>>>>>>>>> wTmp ${wTmp}");

                                        Uint8List pic =
                                            await DbTools.networkImageToByte(
                                                wTmp);
                                        if (pic.length > 1)
                                          picList.add(pic);
                                        else {
                                          final ByteData bytes =
                                              await rootBundle
                                                  .load('images/ErrImg.png');
                                          final Uint8List piclist =
                                              bytes.buffer.asUint8List();
                                          picList.add(piclist);
                                        }
                                      }

                                      isVisiblePhoto = true;
                                      state.isVisiblePhoto = true;
                                      if (picList.length > 0) {
                                        pageIndex = 0;
                                        isVisiblePhoto0 = true;
                                        state.isVisiblePhoto0 = true;
                                      }
                                      print("imgList.length ${imgList.length}");
                                      setState(() {});
                                    },
                                    child: Icon(Icons.delete),
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                          CircleBorder()),
                                      padding: WidgetStateProperty.all(
                                          EdgeInsets.all(20)),
                                      backgroundColor:
                                          WidgetStateProperty.all(
                                              Colors.red), // <-- Button color
                                      overlayColor: WidgetStateProperty
                                          .resolveWith<Color?>((states) {
                                        if (states
                                            .contains(WidgetState.pressed))
                                          return gColors
                                              .primary;
                                        return null; // <-- Splash color
                                      }),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  );
      },
      memo: (state) => [
        state.picList,
        state.isVisibleObj,
        state.isVisiblePhoto,
        state.isVisiblePhoto0,
      ],
    );
    ;
  }

  Widget buildPhotoFdC() {
    return !isVisibleObj
        ? Container()
        : !isVisiblePhoto
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    SpinKitThreeBounce(
                      color: gColors.secondary,
                      size: 100.0,
                    ),
                    Container(
                      height: 10,
                    ),
                    Text(
                      "Lecture des Photos ...",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ])
            : Scaffold(
                body: Column(
                  children: [
                    !isVisiblePhoto0
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  cC.animateToPage(0);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                ),
                                child: Text('<<',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  cC.previousPage();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                ),
                                child: Text('<',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                width: 10,
                              ),
                              Text("${pageIndex + 1}/${picList.length}",
                                  style: TextStyle(
                                    fontSize: 14,
                                  )),
                              Container(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  cC.nextPage();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                ),
                                child: Text('>',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  cC.animateToPage(picList.length - 1);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                ),
                                child: Text('>>',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                    Container(
                      width: 10,
                    ),
                    BlockCarousel(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            consumerA_Inventaire.setState((state) async {
                              imgList.clear();
                              picList.clear();
                            });

                            await DbTools.getInventaireDetPhotos();

                            print("ListInventaireDetPhoto.length ${DbTools.ListInventaireDetPhoto.length}");

                            imgList.clear();
                            DbTools.ListInventaireDetPhoto.forEach(
                                (element) async {
                              String SrvImgPhoto = DbTools.SrvImg + "Photo_${element.invdetid}_${element.photo}.jpg";
                              imgList.add(SrvImgPhoto);
                            });

                            Random random = new Random();
                            int V = random.nextInt(10444) + 1;

                            picList.clear();
                            for (int i = 0; i < imgList.length; ++i) {
                              String wTmp = imgList[i] + "?v=$V";

                              print(">>>>>>>>>>>> wTmp ${wTmp}");

                              Uint8List pic =
                                  await DbTools.networkImageToByte(wTmp);
                              if (pic.length > 1)
                                picList.add(pic);
                              else {
                                final ByteData bytes =
                                    await rootBundle.load('images/ErrImg.png');
                                final Uint8List piclist =
                                    bytes.buffer.asUint8List();
                                picList.add(piclist);
                              }
                            }

                            isVisiblePhoto = true;
                            isVisiblePhoto = true;
                            if (picList.length > 0) {
                              pageIndex = 0;
                              isVisiblePhoto0 = true;
                              isVisiblePhoto0 = true;
                            }
                            print("imgList.length ${imgList.length}");
                            setState(() {});
                          },
                          child: Icon(Icons.refresh),
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(CircleBorder()),
                            padding:
                                WidgetStateProperty.all(EdgeInsets.all(20)),
                            backgroundColor: WidgetStateProperty.all(
                                Colors.deepPurpleAccent), // <-- Button color
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color?>(
                                    (states) {
                              if (states.contains(WidgetState.pressed))
                                return gColors.primary;
                              return null; // <-- Splash color
                            }),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await getImage();
                          },
                          child: Icon(Icons.add),
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(CircleBorder()),
                            padding:
                                WidgetStateProperty.all(EdgeInsets.all(20)),
                            backgroundColor: WidgetStateProperty.all(
                                Colors.green), // <-- Button color
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color?>(
                                    (states) {
                              if (states.contains(WidgetState.pressed))
                                return gColors.primary;
                              return null; // <-- Splash color
                            }),
                          ),
                        ),
                        !isVisiblePhoto0
                            ? Container()
                            : ElevatedButton(
                                onPressed: () async {
                                  int wIndex = DbTools
                                      .ListInventaireDetPhoto[pageIndex].photo;

                                  await DbTools.removephoto_API_Post(wIndex);

                                  consumerA_Inventaire.setState((state) async {
                                    imgList.clear();
                                    picList.clear();
                                  });

                                  await DbTools.getInventaireDetPhotos();

                                  print(
                                      "ListInventaireDetPhoto.length ${DbTools.ListInventaireDetPhoto.length}");

                                  imgList.clear();
                                  DbTools.ListInventaireDetPhoto.forEach(
                                      (element) async {
                                    String SrvImgPhoto = DbTools.SrvImg +  "Photo_${element.invdetid}_${element.photo}.jpg";
                                    imgList.add(SrvImgPhoto);
                                  });

                                  Random random = new Random();
                                  int V = random.nextInt(10444) + 1;

                                  picList.clear();
                                  for (int i = 0; i < imgList.length; ++i) {
                                    String wTmp = imgList[i] + "?v=$V";

                                    print(">>>>>>>>>>>> wTmp ${wTmp}");

                                    Uint8List pic =  await DbTools.networkImageToByte(wTmp);
                                    if (pic.length > 1)
                                      picList.add(pic);
                                    else {
                                      final ByteData bytes = await rootBundle
                                          .load('images/ErrImg.png');
                                      final Uint8List piclist =
                                          bytes.buffer.asUint8List();
                                      picList.add(piclist);
                                    }
                                  }

                                  isVisiblePhoto = true;
                                  isVisiblePhoto = true;
                                  if (picList.length > 0) {
                                    pageIndex = 0;
                                    isVisiblePhoto0 = true;
                                    isVisiblePhoto0 = true;
                                  }
                                  print("imgList.length ${imgList.length}");
                                  setState(() {});
                                },
                                child: Icon(Icons.delete),
                                style: ButtonStyle(
                                  shape:
                                      WidgetStateProperty.all(CircleBorder()),
                                  padding: WidgetStateProperty.all(
                                      EdgeInsets.all(20)),
                                  backgroundColor: WidgetStateProperty.all(
                                      Colors.red), // <-- Button color
                                  overlayColor:
                                      WidgetStateProperty.resolveWith<Color?>(
                                          (states) {
                                    if (states.contains(WidgetState.pressed))
                                      return gColors
                                          .primary;
                                    return null; // <-- Splash color
                                  }),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              );
  }

  @override
  Widget BlockCarousel() {
    return consumerA_Inventaire.build(
      (ctx, state) {
//        if (state.imgList.isEmpty)
        state.imgList = imgList;
//        if (state.picList.isEmpty)
        state.picList = picList;

        imgSlider = state.picList
            .map(
              (pic) => Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        /*AspectRatio(
                          aspectRatio: 1920 / 1080,
                          child:
                        */
                        pic == null
                            ? Container()
                            : Image.memory(
                                pic,
                                fit: BoxFit.fitWidth,
                              ),
                        //),
                      ],
                    )),
              ),
            )
            .toList();

        return CarouselSlider(
          carouselController: cC,
          options: CarouselOptions(
              autoPlay: false,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                pageIndex = index;
                print("onPageChanged");
                setState(() {});
              }),
          items: imgSlider,
        );
      },
      memo: (state) => [
        state.picList,
        state.imgList,
        state.pageIndex,
      ],
    );
  }

  //**************************************************

  Future getImage() async {
    int wIndex = picList.length + 1;
    print("pageIndex $wIndex");

    await _startFilePicker(wIndex);
  }

  _startFilePicker(int aIndex) async {
    print("UploadFilePicker > Photo_${DbTools.gInventaireDet.id}_" + aIndex.toString() + ".jpg");
//    await Upload.UploadFilePicker("Photo_${DbTools.gInventaireDet.id}_" + aIndex.toString() + ".jpg", 0, aIndex);

    setState(() {
      isVisiblePhoto = false;
      isVisiblePhoto0 = false;

    });




    await Upload.UploadFilePickerMulti(0, aIndex);



    print("UploadFilePicker <");
    print("UploadFilePicker <<");
  }

  //**************************************************
  //**************************************************
  //**************************************************

  Widget buildDropDownRowEtab(Etablissement etablissement) {
    return Text(etablissement.Libelle);
  }

  @override
  Widget DD_Etabs() {
    print("DbTools.gEtablissement.IsNewCT ${DbTools.gEtablissement.IsNewCT}");
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 0.0, right: 10.0, top: 15, bottom: 0),
          child: Text(
            "Affectation :",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        DropDown<Etablissement>(
          items: DbTools.ListEtablissementAll,
          initialValue:
              DbTools.getEtablissementsbyID(DbTools.gInventaire.etabid),
          icon: Icon(
            Icons.expand_more,
            color: gColors.secondary,
          ),
          onChanged: (newValue) async {
            Etablissement wEtablissement = newValue!;
            etabid = wEtablissement.id;
            MaxUpdateAction = 30;
            isUpdateAdr();
          },
          customWidgets:
              DbTools.ListEtablissementAll.map((z) => buildDropDownRowEtab(z))
                  .toList(),
          isExpanded: false,
        ),
        Container(width: 15),
        ElevatedButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) => DialogNotif(
                  DateTime.now(),
                  false,
                  DbTools.getEtablissementsbyID(DbTools.gInventaire.etabid)
                              .IsNewCT ==                       1 ? "Affectation2" : "Affectation"),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: gColors.push,
            padding: const EdgeInsets.all(12.0),
          ),
          child: Text('Push',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
        Container(width: 15),
        (DbTools.getEtablissementsbyID(etabid).IsNewCT == 1)
            ? ToggleSwitch(
                minWidth: 90.0,
                activeBgColors: [
                  [Colors.purple],
                  [Colors.red],
                  [Colors.orangeAccent],
                  [Colors.green],
                  [Colors.greenAccent],
                ],
                customWidths: [
                  80,
                  80,
                  80,
                  80,
                  90,
                ],
                initialLabelIndex: AffAccept,
                totalSwitches: 5,
                labels: [
                  'En cours',
                  'Refusé',
                  'Acc. 1€',
                  'Acc. 50€',
                  'Acc. 100€'
                ],
                customTextStyles: [
                  TextStyle(
                    color: Colors.white,
                  ),
                ],
                onToggle: (index) {
                  print('switched to A : $index');
                  AffAccept = index!;
                  print('switched to B : $index');
                  isUpdateAdr();
                })
            : Container(),
      ],
    );
  }

  //**************************************************
  //**************************************************
  //**************************************************

  Widget ActionGridWidget() {
    actionDataSource = ActionDataSource(DbTools.ListInventaireAction);
    print("ListInventaireAction lenght ${DbTools.ListInventaireAction.length}");

    return (DbTools.ListInventaireAction.length == 0 && !isLoad)
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
                child: SfDataGrid(
                  isScrollbarAlwaysShown: true,
                  source: actionDataSource,
                  frozenColumnsCount: 1,
                  onQueryRowHeight: (details) {
                    return details.rowIndex == 0 ? 30.0 : 30.0;
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
                        columnWidthMode: ColumnWidthMode.fitByCellValue,
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
                        columnName: 'ACTION',
                        columnWidthMode: ColumnWidthMode.auto,
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  action',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'OK',
                        columnWidthMode: ColumnWidthMode.auto,
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  OK',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'DATE',
                        columnWidthMode: ColumnWidthMode.auto,
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Date',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'REMARQUE',
                        columnWidthMode: ColumnWidthMode.lastColumnFill,
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Remarque',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                  ],
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  selectionMode: SelectionMode.single,
                  navigationMode: GridNavigationMode.cell,
                  onSelectionChanged: (List<Object> addedRows, List<Object> removedRows) async {
                    DataGridRow selDataGridRow =                     (addedRows.last as DataGridRow);

                    SelCol = -1;
                    onCellTap = false;

                    DbTools.gInventaireAction = DbTools.ListInventaireAction[selDataGridRow.getCells()[0].value];

                    bool isOK = true;
                    print(
                        "onSelectionChanged >>>> Actionid ${DbTools.gInventaireAction.Actionid} ${!DbTools.gUtilisateurLogin.Role.contains("Plateforme")}");
                    DbTools.ListAction.forEach((element) async {
                      if (element.Actionid == DbTools.gInventaireAction.Actionid) {
                        print(
                            "onSelectionChanged >>>> PTF_Only ${element.PTF_Only == 1}");
                        if (element.PTF_Only == 1 &&
                            !DbTools.gUtilisateurLogin.Role
                                .contains("Plateforme")) {
                          isOK = false;
                        }
                      }
                    });

                    if (isOK) {
                      print(
                          "onSelectionChanged >>>> ${DbTools.gInventaireAction.id}");
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) => ActionDialog(),
                      );
                      await Reload();
                    } else {
                      print(
                          "onSelectionChanged >>>> ${DbTools.gInventaireAction.id}");
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) => ActionDialogRo(),
                      );
                      await Reload();
                    }
                  },
                  onCurrentCellActivated: (RowColumnIndex currentRowColumnIndex,
                      RowColumnIndex previousRowColumnIndex) async {
                    print("onCurrentCellActivated ${SelCol}");
                    SelCol = currentRowColumnIndex.columnIndex;

                    bool isOK = true;
                    print(
                        "onSelectionChanged >>>> Actionid ${DbTools.gInventaireAction.Actionid} ${!DbTools.gUtilisateurLogin.Role.contains("Plateforme")}");
                    DbTools.ListAction.forEach((element) async {
                      if (element.Actionid ==
                          DbTools.gInventaireAction.Actionid) {
                        print(
                            "onSelectionChanged >>>> PTF_Only ${element.PTF_Only == 1}");
                        if (element.PTF_Only == 1 &&
                            !DbTools.gUtilisateurLogin.Role
                                .contains("Plateforme")) {
                          isOK = false;
                        }
                      }
                    });

                    if (isOK) {
                      if (!onCellTap &&
                          currentRowColumnIndex.rowIndex ==
                              previousRowColumnIndex.rowIndex) {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => ActionDialog(),
                        );

                        await Reload();
                      }
                    } else {
                      if (!onCellTap &&
                          currentRowColumnIndex.rowIndex ==
                              previousRowColumnIndex.rowIndex) {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => ActionDialogRo(),
                        );

                        await Reload();
                      }
                    }
                    onCellTap = false;
                  },
                ),
              ),
            ),
          );
  }

  //**************************************************
  //**************************************************
  //**************************************************

}

class ActionDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  int i = 0;

  ActionDataSource(List<InventaireAction> Actions) {
    dataGridRows =
        Actions.map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'CID', value: i++),
              DataGridCell<int>(columnName: 'ID', value: dataGridRow.Actionid),
              DataGridCell<String>(
                  columnName: 'Action', value: dataGridRow.Action),
              DataGridCell(
                  columnName: 'OK', value: dataGridRow.OK == 1 ? true : false),
              DataGridCell<String>(columnName: 'DATE', value: dataGridRow.Date),
              DataGridCell<String>(
                  columnName: 'REMARQUE',
                  value: dataGridRow.Remarque.replaceAll("\n", " - ")),
            ])).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    DbTools.gInventaireAction =
        DbTools.ListInventaireAction[row.getCells()[0].value];
    bool isOK = true;

    DbTools.ListAction.forEach((element) async {
      if (element.Actionid == DbTools.gInventaireAction.Actionid) {
        if (element.PTF_Only == 1 &&
            !DbTools.gUtilisateurLogin.Role.contains("Plateforme")) {
          isOK = false;
        }
      }
    });

    return DataGridRowAdapter(cells: [
      Container(),
      Container(
          color: DbTools.StatusColorArray[
              DbTools.ActionIDtoStatus(row.getCells()[1].value)],
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            row.getCells()[1].value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          )),
      Container(
          color: isOK ? Colors.white : Colors.black12,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            row.getCells()[2].value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          )),
      Container(
          color: isOK ? Colors.white : Colors.black12,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Checkbox(
            value: row.getCells()[3].value,
            onChanged: (value) async {
              DbTools.gInventaireAction =
                  DbTools.ListInventaireAction[row.getCells()[0].value];

              bool isOK = true;
              print(
                  "onSelectionChanged >>>> Actionid ${DbTools.gInventaireAction.Actionid} ${!DbTools.gUtilisateurLogin.Role.contains("Plateforme")}");
              DbTools.ListAction.forEach((element) async {
                if (element.Actionid == DbTools.gInventaireAction.Actionid) {
                  print(
                      "onSelectionChanged >>>> PTF_Only ${element.PTF_Only == 1}");
                  if (element.PTF_Only == 1 &&
                      !DbTools.gUtilisateurLogin.Role.contains("Plateforme")) {
                    isOK = false;
                  }
                }
              });

              if (!isOK) {
                return;
              }

              DbTools.gInventaireAction.Date = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
              if (value!)
                DbTools.gInventaireAction.OK = 1;
              else
                DbTools.gInventaireAction.OK = 0;

              await DbTools.setInventaireAction();
              if (DbTools.gInventaireAction.OK == 1) {
                await DbTools.setInventaireActionLot(
                    DbTools.gInventaireAction.Actionid);
              }

              await DbTools.setInventaireStatus();
              DbTools.setInventaire();

              ctrl.sink.add(true);

//              print("onChanged $value ${DbTools.gInventaireAction.DevisFact}");
            },
          )),
      Container(
          color: isOK ? Colors.white : Colors.black12,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            row.getCells()[4].value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          )),
      Container(
          color: isOK ? Colors.white : Colors.black12,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            row.getCells()[5].value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          )),
    ]);
  }
}
//**********************************
//**********************************
//**********************************

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  List<bool> _isChecked = [false, false];
  bool canUpload = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        color: gColors.secondary,
        child: Text("Edition Liste PDF",
            style: TextStyle(
              color: gColors.white,
            )),
      ),
      content: Container(
        height: 280,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 280,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Sélection des champs"),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[2],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[2] = value!;
                          });
                        },
                      ),
                      Text("CDE"),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[3],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[3] = value!;
                          });
                        },
                      ),
                      Text("Prix Vente"),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[4],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[4] = value!;
                          });
                        },
                      ),
                      Text("Prix Achat"),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[5],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[5] = value!;
                          });
                        },
                      ),
                      Text("Temps"),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[6],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[6] = value!;
                          });
                        },
                      ),
                      Text("Temps C"),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[7],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[7] = value!;
                          });
                        },
                      ),
                      Text("Temps D"),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[8],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[8] = value!;
                          });
                        },
                      ),
                      Text("Temps E"),
                    ]),
                  ]),
            ),
            Container(width: 30),
            Container(
              height: 280,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(""),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[9],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[9] = value!;
                          });
                        },
                      ),
                      Text("M3"),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[10],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[10] = value!;
                          });
                        },
                      ),
                      Text("M3 C"),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[11],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[11] = value!;
                          });
                        },
                      ),
                      Text("M3 D"),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[12],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[12] = value!;
                          });
                        },
                      ),
                      Text("M3 E"),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[13],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[13] = value!;
                          });
                        },
                      ),
                      Text("Tri"),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[14],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[14] = value!;
                          });
                        },
                      ),
                      Text("Dem"),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[15],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[15] = value!;
                          });
                        },
                      ),
                      Text("Man"),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: DbTools.isVisChamps[16],
                        onChanged: (value) {
                          setState(() {
                            DbTools.isVisChamps[16] = value!;
                          });
                        },
                      ),
                      Text("Autre"),
                    ]),
                  ]),
            ),
            Container(width: 30),
          ],
        ),
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: gColors.primary,
          ),
          child: const Text('Annuler',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
        new ElevatedButton(
          onPressed: () async {
            await Upload.SaveFilePicker(1);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: gColors.secondary,
          ),
          child: const Text('Edition',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

//****************************************
//**********************************
//**********************************
//**********************************

class ActionDialog extends StatefulWidget {
  @override
  _ActionDialogState createState() => _ActionDialogState();
}

class _ActionDialogState extends State<ActionDialog> {
  final tecRem = TextEditingController();


  String Avis = "";

  List<String> LnkAvis = [];
  List<String> LblAvis = [];

  @override
  void initState() {
    print("_ActionDialogState initState");

    if (DbTools.gInventaireAction.Actionid == 130) {
      print("DbTools.gEtablissement.Url_Avis ${DbTools.gEtablissement.Url_Avis}");

      String wAvis = DbTools.gEtablissement.Url_Avis;
      final splitted1 = wAvis.split('\n');
      print("splitted1 ${splitted1}");

      int i = 0;
      splitted1.forEach((element) {
        final splitted2 = element.split('|');
        LnkAvis.add(splitted2[1]);
        LblAvis.add(splitted2[0]);

        if (i == 0) {
          Avis = splitted2[0];
          DbTools.AvisLink = splitted2[1];
        }
        i++;
      });
    }

    try {
      DateTime_Action = new DateFormat('dd-MM-yyyy HH:mm').parse(DbTools.gInventaireAction.Date);
    } catch (e) {
      print("Erreur Date 1 ${DateTime_Action}");
      try {
        DateTime_Action = DateTime.now();
        DateTime_Action = DateTime(
            DateTime_Action.year,
            DateTime_Action.month,
            DateTime_Action.day,
            DateTime_Action.hour,
            DateTime_Action.minute,
            0,
            0,
            0);
      } catch (e) {
        print("Erreur Date 2");
        DateTime_Action = DateTime.now();
      }
    }

    print("ActionDialog DbTools.gInventaireAction ${DbTools.gInventaireAction.Action}");
    tecRem.text = DbTools.gInventaireAction.Remarque;
    print("ActionDialog DbTools.gInventaireAction.Date ${DbTools.gInventaireAction.Date}");
    print("ActionDialog DateTime_Action ${DateTime_Action}");
  }

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale("fr"),
        initialDate: DateTime_Action,
        firstDate: new DateTime(2019),
        lastDate: new DateTime(2100));

    if (picked != null) {
      DateTime_Action = DateTime(picked.year, picked.month, picked.day, DateTime_Action.hour, DateTime_Action.minute, 0, 0, 0);

      print("ActionDialog DateTime_Action picked ${DateTime_Action}");

      TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(DateTime_Action),
          useRootNavigator: false,
          initialEntryMode: TimePickerEntryMode.input,
          builder: (context, childWidget) {
            return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: childWidget!);
          });

      print("pickedTime ${pickedTime.toString()}");

      DateTime_Action = DateTime(DateTime_Action.year, DateTime_Action.month,
          DateTime_Action.day, pickedTime!.hour, pickedTime.minute, 0, 0, 0);

      print("DateTime_Action ${DateTime_Action}");

      setState(() {});
    }
  }

  @override
  void dispose() {
    tecRem.dispose();
    super.dispose();
  }


  @override //A
  Widget build(BuildContext context) {
    String ActionsPush = "50,120";

    if (DbTools.gEtablissement.Url_Avis.length > 0) ActionsPush += ",130";

    return AlertDialog(
      title: Container(
        color: gColors.secondary,
        child: Text(
            "Actions ${DbTools.gInventaireAction.Action} (${DbTools.gInventaireAction.Actionid})",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: gColors.white,
            )),
      ),
      content: Container(
          height: 343,
          width: MediaQuery.of(context).size.width / 2,
          child: Column(children: [
            Row(children: [
              Text("OK : "),
              Checkbox(
                value: (DbTools.gInventaireAction.OK == 1),
                onChanged: (value) {
                  setState(() {
                    if (value!)
                      DbTools.gInventaireAction.OK = 1;
                    else
                      DbTools.gInventaireAction.OK = 0;
                  });
                },
              ),
              Container(
                width: 20,
              ),
              Text("Date : "),
              TextButton(
                onPressed: () async {
                  print('_selectDate>');

                  await _selectDate();

                  print(
                      "${DateFormat('dd-MM-yyyy  HH:mm').format(DateTime_Action)}");
                },
                child: Text(
                  '${DateFormat('dd-MM-yyyy HH:mm').format(DateTime_Action)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
              Container(width: 15),
              DbTools.gUtilisateurLogin.Role.contains("Plateforme")
                  ? Container()
                  : ActionsPush.contains(
                          DbTools.gInventaireAction.Actionid.toString())
                      ? ElevatedButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) => DialogNotif(DateTime_Action, true, ""),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gColors.push,
                            padding: const EdgeInsets.all(12.0),
                          ),
                          child: Text('Push',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        )
                      : Container(),
              Container(width: 15),
              DbTools.gInventaireAction.Actionid == 130
                  ? Container(
                      child: DropdownButton<String>(
                        value: Avis,
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
                            final index = LblAvis.indexWhere(
                                (element) => element.startsWith("${newValue}"));
                            Avis = newValue!;
                            DbTools.AvisLink = LnkAvis[index];
                          });
                        },
                        items: LblAvis.map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                      ),
                    )
                  : Container(),
              Spacer(),
              Text("${DbTools.gInventaireAction.id}"),
            ]),
            Container(
              height: 20,
            ),
            Row(children: [
              Text("Remarque :"),
            ]),
            Container(
              height: 10,
            ),
            TextFormField(
              onChanged: (text) {},
              controller: tecRem,
              style: TextStyle(
                fontSize: 14,
              ),
//              keyboardType: TextInputType.name,
              keyboardType: TextInputType.multiline,
              maxLines: 14,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
            ),
          ])),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () async {
            DbTools.gInventaireAction.Remarque = tecRem.text;
            DbTools.gInventaireAction.Date = DateFormat('dd-MM-yyyy HH:mm').format(DateTime_Action);

            print("Save DateTime_Action ${DateTime_Action}");
            print("Save DbTools.gInventaireAction.Date ${DbTools.gInventaireAction.Date}");

            await DbTools.setInventaireAction();
            await DbTools.setInventaireStatus();

            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: gColors.secondary,
          ),
          child: const Text('Save',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: gColors.secondary,
          ),
          child: const Text('Annuler',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

//**********************************
//**********************************
//**********************************
//**********************************

class ActionDialogRo extends StatefulWidget {
  @override
  _ActionDialogRoState createState() => _ActionDialogRoState();
}

class _ActionDialogRoState extends State<ActionDialogRo> {
  final tecRem = TextEditingController();

  @override
  void initState() {
    print("_ActionDialogRoState initState");

    try {
      DateTime_Action = new DateFormat('dd-MM-yyyy HH:mm').parse(DbTools.gInventaireAction.Date);
    } catch (e) {
      try {
        DateTime_Action = new DateFormat('dd-MM-yyyy').parse(DbTools.gInventaireAction.Date);
        DateTime_Action = DateTime(DateTime_Action.year, DateTime_Action.month, DateTime_Action.day, 10, 0, 0, 0, 0);
      } catch (e) {
        DateTime_Action = DateTime.now();
      }
    }

    print("ActionDialogRo DbTools.gInventaireAction ${DbTools.gInventaireAction.Action}");
    tecRem.text = DbTools.gInventaireAction.Remarque;
    print("ActionDialogRo DbTools.gInventaireAction.Date ${DbTools.gInventaireAction.Date}");
    print("ActionDialogRo DateTime_Action ${DateTime_Action}");
  }

  @override
  void dispose() {
    tecRem.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    String ActionsPush = "50,120,";
    if (DbTools.gEtablissement.Url_Avis.length > 0) ActionsPush += ",130";

    return AlertDialog(
      backgroundColor: gColors.LinearGradient3,
      title: Container(
        color: gColors.secondary,
        child: Text(
            "Actions ${DbTools.gInventaireAction.Action} (${DbTools.gInventaireAction.Actionid})",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: gColors.white,
            )),
      ),
      content: Container(
          height: 343,
          width: MediaQuery.of(context).size.width / 2,
          child: Column(children: [
            Row(children: [
              Text("OK : "),
              Checkbox(
                value: (DbTools.gInventaireAction.OK == 1),
                onChanged: null,
              ),
              Container(
                width: 20,
              ),
              Text("Date : "),
              TextButton(
                onPressed: () async {},
                child: Text(
                  '${DateFormat('dd-MM-yyyy HH:mm').format(DateTime_Action)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
              Container(width: 15),
              Spacer(),
              Text("${DbTools.gInventaireAction.id}"),
            ]),
            Container(
              height: 20,
            ),
            Row(children: [
              Text("Remarque :"),
            ]),
            Container(
              height: 10,
            ),
            TextFormField(
              enabled: false,

              onChanged: (text) {},
              controller: tecRem,
              style: TextStyle(
                fontSize: 14,
              ),
//              keyboardType: TextInputType.name,
              keyboardType: TextInputType.multiline,
              maxLines: 15,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
            ),
          ])),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: gColors.secondary,
          ),
          child: const Text('OK',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
