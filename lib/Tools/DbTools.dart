import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:TrocWeb_BackOff/Tools/Action.dart';
import 'package:TrocWeb_BackOff/Tools/Cde_Ent.dart';
import 'package:TrocWeb_BackOff/Tools/Etablissement.dart';
import 'package:TrocWeb_BackOff/Tools/Inventaire.dart';
import 'package:TrocWeb_BackOff/Tools/InventaireAction.dart';
import 'package:TrocWeb_BackOff/Tools/InventaireDet.dart';
import 'package:TrocWeb_BackOff/Tools/InventaireDetPhoto.dart';
import 'package:TrocWeb_BackOff/Tools/ParamNotif.dart';
import 'package:TrocWeb_BackOff/Tools/Utilisateur.dart';

import 'package:TrocWeb_BackOff/widgets/Agence/A_Affaires.dart';
import 'package:TrocWeb_BackOff/widgets/Agence/A_Dialog_50_100.dart';
import 'package:consumer/consumer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';

import 'package:image/image.dart' as IMG;
import 'package:intl/intl.dart';

//SELECT Inventaires.* FROM Inventaires WHERE Inventaires.id >= 663

//SELECT InventairesDet.* FROM InventairesDet, Inventaires WHERE Inventaires.id = InventairesDet.invid AND Inventaires.id >= 663
//SELECT InventairesDetPhoto.* FROM InventairesDetPhoto, InventairesDet, Inventaires WHERE Inventaires.id = InventairesDet.invid AND Inventaires.id >= 663 AND InventairesDet.id = InventairesDetPhoto.invdetid

var consumerA_Inventaire = Consumer(A_InventaireState());
var consumerB_Inventaire = Consumer(A_InventaireState());
var consumerC_Inventaire = Consumer(A_Dialog_50_100(false));

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}


class Notif with ChangeNotifier {
  Notif();
  void BroadCast() {
    notifyListeners();
  }
}





class DbTools {
  DbTools();

  static String Hexa_nom = "SAS HEXADE";
  static String Hexa_adresse1 = "2 place Gustave Rivet";
  static String Hexa_adresse2 = "";
  static String Hexa_cp = "38000";
  static String Hexa_ville = "GRENOBLE";

  static var notif = Notif();
  static String gVersion = "v2.42.0 b242";
  static bool gTED = false;
  static bool gIsRememberLogin = true;
  static String Url = "185.98.136.238";
  //static String Url = "palmisphere.com";

  static int gLastID = 0;
  static int gLastIDObj = 0;

  static int gLastObjIndex = 0;
  static List<InventaireDet> gListInventaireObj = [];

  static String gPasswordLogin = "";

  static String sRole = 'User';
  static bool isChecked = false;

  static List<bool> isVisChamps = [];

  static bool isCDE = true;
  static bool isPv = true;
  static bool isPa = true;

  static bool isTps = true;
  static bool isTpsC = true;
  static bool isTpsD = true;
  static bool isTpsE = true;

  static bool isM3 = true;
  static bool isM3C = true;
  static bool isM3D = true;
  static bool isM3E = true;

  static bool isTri = true;
  static bool isDem = true;
  static bool isMan = true;
  static bool isAutre = true;


  static String AvisLink = '';



  static List<Color> StatusColorArray = [
    Color(0xFF88FF88), //0 "Fiche Client";

    Color(0xFF0099EE), //1 "Saisie Mob.";
    Color(0xFF8888FF), //2 "Validation PC"

    Color(0xFF88FFFF), //3 "Edition"
    Color(0xFFFF88FF), //4 "Devis"

    Color(0xFFFFEE00), //5 "Débarras"
    Color(0xFFBB88BB), //6 "Fact/Solde"

    Color(0xFF88BBBB), //8 "Cloture"
    Color(0xFFFF8888), //9 "Annulation"

    Color(0xFFBBBBBB), //7 "Comm"
  ];


  static List<Inventaire> lInventaire = [];

  static String SrvUrl = "http://$Url/API_TWERP4.php";
  static String SrvUrlt = "http://$Url/API_TWERPT.php";


  static String SrvImg = "http://$Url/Img/";
  static String SrvTokenKey = "Ad2844Ze";
  static String SrvToken = "";

  static late ByteData LogoimageData;



  static String CD_FdC = "I";

  static String LibStatus(int Status) {
    switch (Status) {
      case (0):
        {
          return "Fiche Client";
        }
      case (1):
        {
          return "Saisie Mob.";
        }
      case (2):
        {
          return "Validation PC";
        }
      case (3):
        {
          return "Edition";
        }
      case (4):
        {
          return "Devis";
        }
      case (5):
        {
          return "Débarras";
        }
      case (6):
//      case (9):
        {
          return "Fact/Solde";
        }
      case (7):
        {
          return "Cloture";
        }
      case (8):
        {
          return "Annulation";
        }

      default:
        {
          return "";
        }
    }
  }

  static int getStatusID(String Condition) {
    switch (Condition) {
      case ("Fiche Client"):
        {
          return 0;
        }
      case ("Saisie Mob."):
        {
          return 1;
        }
      case ("Validation PC"):
        {
          return 2;
        }
      case ("Edition"):
        {
          return 3;
        }
      case ("Devis"):
        {
          return 4;
        }
      case ("Débarras"):
        {
          return 5;
        }
      case ("Fact/Solde"):
        {
          return 6;
        }
      case ("Cloture"):
        {
          return 7;
        }
      case ("Annulation"):
        {
          return 8;
        }
      default:
        {
          return 0;
        }
    }
  }

  static String LibRoles(int Roles) {
    switch (Roles) {
      case (0):
        {
          return "SuperAdmin";
        }
      case (1):
        {
          return "Admin";
        }
      case (2):
        {
          return "User";
        }
      case (3):
        {
          return "Plateforme";
        }

      default:
        {
          return "";
        }
    }
  }

  static int getRolesID(String Condition) {
    switch (Condition) {
      case ("SuperAdmin"):
        {
          return 0;
        }
      case ("Admin"):
        {
          return 1;
        }
      case ("User"):
        {
          return 2;
        }
      case ("Plateforme"):
        {
          return 3;
        }

      default:
        {
          return 0;
        }
    }
  }

  static String LibOrigines(int Origines) {
    switch (Origines) {
      case (0):
        {
          return "Agence";
        }
      case (1):
        {
          return "Téléphone";
        }
      case (2):
        {
          return "Mail";
        }
      case (3):
        {
          return "HEXA";
        }

      default:
        {
          return "";
        }
    }
  }



  static String LibSources(int Sources) {
    switch (Sources) {
      case (0):
        {
          return "Agence";
        }
      case (1):
        {
          return "Plateforme";
        }

      default:
        {
          return "";
        }
    }
  }

  static int getSourcesID(String Condition) {
    switch (Condition) {
      case ("Agence"):
        {
          return 0;
        }
      case ("Plateforme"):
        {
          return 1;
        }

      default:
        {
          return 0;
        }
    }
  }

  //****************************************************
  //************************  Etablissement  ***********
  //****************************************************

  static List<Etablissement> ListEtablissement = [];
  static List<Etablissement> ListEtablissementAll = [];
  static late Etablissement gEtablissement;
  static late Etablissement SelEtablissement;

  static int SelEtabID = 14;
  static int SelEtabIDi = 0;

  static late Etablissement selectedEtablissement;

  static String getEtablissementsbyInvID2(Inventaire wInventaire) {
    String wName = "";

    wName = "Agence ${wInventaire.etabid} ${wInventaire.etabidOrigine}";

    DbTools.ListEtablissementAll.forEach((element) {
      if (element.id == wInventaire.etabid) {
        wName = element.Libelle;
      }
    });
    return wName;
  }

  static int getEtablissementsbyInvID2_NexCT(Inventaire wInventaire) {
    int wRet = 0;
    DbTools.ListEtablissementAll.forEach((element) {
      if (element.id == wInventaire.etabid) {
        wRet = element.IsNewCT;
      }
    });
    return wRet;
  }


  static String getEtablissementsbyInvID3(Inventaire wInventaire) {
    String wName = "";

    wName = "";
    DbTools.ListEtablissementAll.forEach((element) {
      if (element.id == wInventaire.etabidOrigine &&
          wInventaire.etabid != wInventaire.etabidOrigine) {
//          wName = "${wInventaire.etabidOrigine} / ${wInventaire.Origine}";
        wName = "TKS+ / ${wInventaire.Origine}";
      }
    });

    return wName;
  }

  static String getEtablissementsbyInvID(Inventaire wInventaire) {
    String wName = "";

    if (selectedEtablissement.IsPT == 1) {
      wName = "Non Affecté";
      DbTools.ListEtablissementAll.forEach((element) {
        if (element.id == wInventaire.etabid &&
            wInventaire.etabid != wInventaire.etabidOrigine) {
          wName = element.Libelle;
        }
      });
    } else {
      wName = "";
      DbTools.ListEtablissementAll.forEach((element) {
        if (element.id == wInventaire.etabidOrigine &&
            wInventaire.etabid != wInventaire.etabidOrigine) {
//          wName = "${wInventaire.etabidOrigine} / ${wInventaire.Origine}";
          wName = "TKS+ / ${wInventaire.Origine}";
        }
      });
    }

    return wName;
  }

  static Etablissement getEtablissementsbyID(int iID) {
    Etablissement wEtablissement = Etablissement(-1, "", "", "", "", "", "", "", "",
        "", "", "", "", "", "", "", 0, 0, "", 0, 0, 0, "", "", "", "", "", "", "", "", "", "","", 0,"");
    DbTools.ListEtablissementAll.forEach((element) {
      if (element.id == iID) {
        wEtablissement = element;
      }
    });
    return wEtablissement;
  }

  //****************************************************
  //****************************************************
  //****************************************************



  static bool isEtablissementsComm() {
    bool wRet =   (gInventaire.etabid != gInventaire.etabidOrigine && (getEtablissementsbyID(gInventaire.etabid).IsNewCT == 0));
//    print("isEtablissementsComm ${wRet} ${gInventaire.etabid} ${gInventaire.etabidOrigine} ${getEtablissementsbyID(gInventaire.etabid).IsNewCT}   ${gInventaire.etabid != gInventaire.etabidOrigine }  ${getEtablissementsbyID(gInventaire.etabid).IsNewCT}");
    return wRet;
  }


  static Future<bool> getEtablissementsAll() async {
    ListEtablissementAll = await getEtablissement_API_Post(
        "select", "select * from Etablissements");

    print(">>>>>>>> getEtablissementsAll() ${ListEtablissementAll.length}");

    if (ListEtablissementAll == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getEtablissements() async {
    ListEtablissement = await getEtablissement_API_Post(
        "select", "select * from Etablissements");
    if (ListEtablissement == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getEtablissement(String keyid) async {
    ListEtablissement = await getEtablissement_API_Post(
        "select", "select * from Etablissements where keyid = '$keyid'");
    if (ListEtablissement == []) {
      return false;
    } else {
      gEtablissement = ListEtablissement[0];

      return true;
    }
  }

  static Future<bool> getEtablissementid(int etabid) async {
    ListEtablissement = await getEtablissement_API_Post(
        "select", "select * from Etablissements where id = '$etabid'");
    if (ListEtablissement == []) {
      return false;
    } else {
      gEtablissement = ListEtablissement[0];
      print("gEtablissement ${gEtablissement.Libelle}");
      return true;
    }
  }

  static Future<List<Etablissement>> getEtablissement_API_Post(
      String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=

    final bodys = {'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL};


    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll(bodys);

    http.StreamedResponse response;

    response = await request.send();


    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      var success = parsedJson['success'];


      if (success == "0") return [];

      final items = parsedJson['data'];

      if (items != null) {
        List<Etablissement> EtablissementList =
            items.map<Etablissement>((json) {
          return Etablissement.fromJson(json);
        }).toList();
        return EtablissementList;
      }
    } else {
      print("getEtablissement_API_Post reasonPhrase ${response.reasonPhrase}");
    }
    return [];
  }

  static Future<bool> setEtablissement() async {
    String aSQL = "UPDATE Etablissements SET "
            "Libelle = \"" +
        gEtablissement.Libelle +
        "\", Nom_TK = \"" +
        gEtablissement.Nom_TK +
        "\", Adresse1 = \"" +
        gEtablissement.Interlocuteur +
        "\", Adresse1 = \"" +
        gEtablissement.adresse1 +
        "\", Adresse2 = \"" +
        gEtablissement.adresse2 +
        "\", Cp = \"" +
        gEtablissement.cp +
        "\", Ville = \"" +
        gEtablissement.ville +
        "\", Pays = \"" +
        gEtablissement.Pays +
        "\", RC = \"" +
        gEtablissement.RC +
        "\", Ass_RC = \"" +
        gEtablissement.Ass_RC +
        "\", RIB = \"" +
        gEtablissement.RIB +
        "\", RGLT = \"" +
        gEtablissement.RGLT +
        "\", Tel = \"" +
        gEtablissement.tel +
        "\", Mail = \"" +
        gEtablissement.mail +
        "\", CGV = \"" +
        gEtablissement.CGV +
        "\", keyid = \"" +
        gEtablissement.keyid.toString() +
        "\", No_TVA = \"" +
        gEtablissement.No_TVA +



        "\", UrlNecro_1 = \"" +
        gEtablissement.UrlNecro_1.toString() +
        "\", UrlNecro_2 = \"" +
        gEtablissement.UrlNecro_2.toString() +
        "\", UrlNecro_3 = \"" +
        gEtablissement.UrlNecro_3.toString() +
        "\", Url_Avis = \"" +
        gEtablissement.Url_Avis.toString() +
        "\", Brouillon = \"" +
        gEtablissement.Brouillon.toString() +
        "\", Adresse = \"" +
        gEtablissement.Adresse.toString() +
        "\", IsPT = " +
        gEtablissement.IsPT.toString() +
        ", TxTVA = " +
        gEtablissement.TxTVA.toString() +
        ", MtDechM3 = " +
        gEtablissement.MtDechM3.toString() +
        ", indexDevis = " +
        gEtablissement.indexDevis.toString() +
        ", indexFacture = " +
        gEtablissement.indexFacture.toString() +
        " WHERE id = " +
        gEtablissement.id.toString();
    print("setEtablissement " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("setEtablissement ret " + ret.toString());
    return ret;
  }

  static Future<bool> addEtablissement() async {
    String aSQL =
        "INSERT INTO Etablissements ( keyid, Libelle, Nom_TK, Interlocuteur, Adresse1, Adresse2, Cp, Ville, Pays, RC, RIB, RGLT, tel, mail, IsPT, TxTVA, No_TVA, MtDechM3, indexDevis, indexFacture, UrlNecro_1,UrlNecro_2,UrlNecro_3,Url_Avis) "
                "VALUES ( "
                "'" +
            gEtablissement.keyid +
            "', '" +
            gEtablissement.Libelle +
            "', '" +
            gEtablissement.Nom_TK +
            "', '" +
            gEtablissement.Interlocuteur +
            "', '" +
            gEtablissement.adresse1 +
            "', '" +
            gEtablissement.adresse2 +
            "', '" +
            gEtablissement.cp +
            "', '" +
            gEtablissement.ville +
            "', '" +
            gEtablissement.Pays +
            "', '" +
            gEtablissement.RC +
            "', '" +
            gEtablissement.Ass_RC +
            "', '" +
            gEtablissement.RIB +
            "', '" +
            gEtablissement.RGLT +
            "', '" +
            gEtablissement.tel +
            "', '" +
            gEtablissement.mail +
            "', " +
            gEtablissement.IsPT.toString() +
            ", " +
            gEtablissement.TxTVA.toString() +
            ", '" +
            gEtablissement.No_TVA +
            "', " +
            gEtablissement.MtDechM3.toString() +
            ", " +
            gEtablissement.indexDevis.toString() +
            ", " +
            gEtablissement.indexFacture.toString() +
            " " +
            ", '" +
            gEtablissement.UrlNecro_1 +
            "', '" +
            gEtablissement.UrlNecro_2 +
            "', '" +
            gEtablissement.UrlNecro_3 +
            "', '" +
            gEtablissement.Url_Avis +
            "', '" +
            gEtablissement.Brouillon +
            "', '" +
            gEtablissement.Adresse +
            "'" +
            ")";
    print("addEtablissement " + aSQL);
    bool ret = await add_API_Post("insert", aSQL);
    print("addEtablissement ret " + ret.toString());

    return ret;
  }

  //****************************************************
  //************************  ParamNotif  ***********
  //****************************************************

  static List<ParamNotif> ListParamNotif = [];

  static late ParamNotif gParamNotif;

  static Future<bool> getParamNotif() async {
    ListParamNotif =
        await getParamNotif_API_Post("select", "select * from ParamNotif");
    if (ListParamNotif == []) {
      return false;
    } else {
      return true;
    }
  }

  static Future<List<ParamNotif>> getParamNotif_API_Post(
      String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=

    final bodys = {'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL};

    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll(bodys);

    http.StreamedResponse response;
    print("request.send ${aSQL}");
    response = await request.send();
    print("response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      var success = parsedJson['success'];
      print("success ${success}");

      if (success == "0") return [];

      final items = parsedJson['data'];

      if (items != null) {
        List<ParamNotif> ParamNotifList = items.map<ParamNotif>((json) {
          return ParamNotif.fromJson(json);
        }).toList();
        return ParamNotifList;
      }
    } else {
      print("getParamNotif_API_Post reasonPhrase ${response.reasonPhrase}");
    }
    return [];
  }

  static Future<bool> setParamNotif() async {
    String aSQL = "UPDATE ParamNotif SET PushTitle = \"" +
        gParamNotif.PushTitle +
        "\", PushBody = \"" +
        gParamNotif.PushBody +
        "\", MailSubject = \"" +
        gParamNotif.MailSubject +
        "\", MailMessage = \"" +
        gParamNotif.MailMessage +
        "\" WHERE id = " +
        gParamNotif.id.toString();
    print("setParamNotif " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("setParamNotif ret " + ret.toString());
    return ret;
  }

  //****************************************************
  //************************  Utilisateur  ***********
  //****************************************************

  static List<Utilisateur> ListUtilisateur = [];
  static late Utilisateur gUtilisateur;
  static late Utilisateur gUtilisateurLogin;

  //****************************************************
  //****************************************************
  //****************************************************

  static Future<bool> getUtilisateurs() async {
    ListUtilisateur =
        await getUtilisateur_API_Post("select", "select * from Utilisateurs");
    if (ListUtilisateur == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getUtilisateursEtab(String aKeyId) async {
    ListUtilisateur = await getUtilisateur_API_Post("select",
        "select * from Utilisateurs WHERE etabid = ${gEtablissement.id}");
    if (ListUtilisateur == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getUtilisateur(
      String aUtilisateur, String aMotdepasse) async {
    String aSQL = "select * FROM Utilisateurs WHERE Utilisateur = '" +
        aUtilisateur +
        "' AND Motdepasse = '" +
        aMotdepasse +
        "'";

    ListUtilisateur = await getUtilisateur_API_Post("select", aSQL);
    if (ListUtilisateur == null) {
      return false;
    } else {
      gUtilisateur = ListUtilisateur[0];
      gUtilisateurLogin = gUtilisateur;
      await getEtablissementid(gUtilisateur.etabid);
      return true;
    }
  }

  static Future<List<Utilisateur>> getUtilisateur_API_Post(
      String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=

    final bodys = {'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL};

    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll(bodys);

    http.StreamedResponse response;
    print("request.send");
    response = await request.send();
    print("response $response");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      var success = parsedJson['success'];
      final items = parsedJson['data'];

      if (items != null) {
        print("items alloc");
        List<Utilisateur> UtilisateurList = items.map<Utilisateur>((json) {
          return Utilisateur.fromJson(json);
        }).toList();
        return UtilisateurList;
      }
    } else {
      print("getUtilisateur_API_Post reasonPhrase ${response.reasonPhrase}");
    }
    return [];
  }

  static Future<bool> setUtilisateur() async {
    String aSQL = "UPDATE Utilisateurs SET Utilisateur = \"" +
        gUtilisateur.User +
        "\", Motdepasse = \"" +
        gUtilisateur.Motdepasse +
        "\", Role = \"" +
        gUtilisateur.Role +
        "\", Actif = " +
        gUtilisateur.Actif.toString() +
        " WHERE id = " +
        gUtilisateur.id.toString();
    print("setUtilisateur " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("setUtilisateur ret " + ret.toString());
    return ret;
  }

  static Future<bool> addUtilisateur() async {
    String aSQL =
        "INSERT INTO Utilisateurs ( etabid, Utilisateur, Motdepasse, Role, Actif ) "
                "VALUES ( ${gEtablissement.id}, "
                "'" +
            gUtilisateur.User +
            "', "
                "'" +
            gUtilisateur.Motdepasse +
            "', "
                "'" +
            gUtilisateur.Role +
            "', "
                "" +
            gUtilisateur.Actif.toString() +
            ")";
    print("addUtilisateur " + aSQL);
    bool ret = await add_API_Post("insert", aSQL);
    print("addUtilisateur ret " + ret.toString());
    return ret;
  }

  //****************************************************
  //************************  Cde_Ent  ***********
  //****************************************************

  static List<Cde_Ent> ListCde_Ent = [];
  static late Cde_Ent gCde_Ent;
  static late Cde_Ent gCde_EntLogin;

  //****************************************************
  //****************************************************
  //****************************************************

  static Future<bool> getCde_Ents() async {
    ListCde_Ent = await getCde_Ent_API_Post("select", "select * from Cde_Ent");
    if (ListCde_Ent == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getCde_Ent() async {
    ListCde_Ent = await getCde_Ent_API_Post("select",
        "select * from Cde_Ent WHERE Cde_Ent_Invid = ${gInventaire.id}");
    if (ListCde_Ent == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<List<Cde_Ent>> getCde_Ent_API_Post(
      String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=

    final bodys = {'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL};

    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll(bodys);

    http.StreamedResponse response;
    print("request.send");
    response = await request.send();
    print("response $response");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      var success = parsedJson['success'];
      final items = parsedJson['data'];

      if (items != null) {
        print("items alloc");
        List<Cde_Ent> Cde_EntList = items.map<Cde_Ent>((json) {
          return Cde_Ent.fromJson(json);
        }).toList();
        return Cde_EntList;
      }
    } else {
      print("getCde_Ent_API_Post reasonPhrase ${response.reasonPhrase}");
    }
    return [];
  }

  static Future<bool> setCde_Ent() async {
    print("setCde_Ent setCde_Ent setCde_Ent setCde_Ent setCde_Ent setCde_Ent");

    int wFact = gCde_Ent.Cde_Ent_Fact ? 1 : 0;
    int wAnnul = gCde_Ent.Cde_Ent_Annul ? 1 : 0;

    int wCde_Ent_EDT = gCde_Ent.Cde_Ent_EDT ? 1 : 0;

    String aSQL = "UPDATE Cde_Ent SET Cde_Ent_Date = \"" +
        gCde_Ent.Cde_Ent_Date +
        "\", "
            "Cde_Ent_Remarque = \"" +
        gCde_Ent.Cde_Ent_Remarque +
        "\", "
            "Cde_Ent_DF = \"" +
        gCde_Ent.Cde_Ent_DF +
        "\", "
            "Cde_Ent_Tx_Tks = " +
        gCde_Ent.Cde_Ent_Tx_Tks.toStringAsFixed(2).toString() +
        ", Cde_Ent_Tot_HT = " +
        gCde_Ent.Cde_Ent_Tot_HT.toStringAsFixed(2).toString() +
        ", Cde_Ent_Tot_TVA = " +
        gCde_Ent.Cde_Ent_Tot_TVA.toStringAsFixed(2).toString() +
        ", Cde_Ent_Tot_TTC = " +
        gCde_Ent.Cde_Ent_Tot_TTC.toStringAsFixed(2).toString() +
        ", Cde_Ent_Tot_CLIENT = " +
        gCde_Ent.Cde_Ent_Tot_CLIENT.toStringAsFixed(2).toString() +
        ", Cde_Ent_EDT = " + wCde_Ent_EDT.toString() +
        ", Cde_Ent_Fact = " + wFact.toString() +
        ", Cde_Ent_Annul = " + wAnnul.toString() +
        ", Cde_Ent_Rep_Net = " +
        gCde_Ent.Cde_Ent_Rep_Net.toStringAsFixed(2).toString() +
        ", Cde_Ent_Rem_Net = " +
        gCde_Ent.Cde_Ent_Rem_Net.toStringAsFixed(2).toString() +
        ", Cde_Ent_Px_1  = " +
        gCde_Ent.Cde_Ent_Px_1.toStringAsFixed(2).toString() +
        ", Cde_Ent_Qte_1 = " +
        gCde_Ent.Cde_Ent_Qte_1.toStringAsFixed(2).toString() +
        ", Cde_Ent_Mt_1  = " +
        gCde_Ent.Cde_Ent_Mt_1.toStringAsFixed(2).toString() +
        ", Cde_Ent_Net_1 = " +
        gCde_Ent.Cde_Ent_Net_1.toStringAsFixed(2).toString() +
        ", Cde_Ent_Px_2  = " +
        gCde_Ent.Cde_Ent_Px_2.toStringAsFixed(2).toString() +
        ", Cde_Ent_Qte_2 = " +
        gCde_Ent.Cde_Ent_Qte_2.toStringAsFixed(2).toString() +
        ", Cde_Ent_Mt_2  = " +
        gCde_Ent.Cde_Ent_Mt_2.toStringAsFixed(2).toString() +
        ", Cde_Ent_Net_2 = " +
        gCde_Ent.Cde_Ent_Net_2.toStringAsFixed(2).toString() +
        ", Cde_Ent_Px_3  = " +
        gCde_Ent.Cde_Ent_Px_3.toStringAsFixed(2).toString() +
        ", Cde_Ent_Qte_3 = " +
        gCde_Ent.Cde_Ent_Qte_3.toStringAsFixed(2).toString() +
        ", Cde_Ent_Mt_3  = " +
        gCde_Ent.Cde_Ent_Mt_3.toStringAsFixed(2).toString() +
        ", Cde_Ent_Net_3 = " +
        gCde_Ent.Cde_Ent_Net_3.toStringAsFixed(2).toString() +
        ", Cde_Ent_Px_4  = " +
        gCde_Ent.Cde_Ent_Px_4.toStringAsFixed(2).toString() +
        ", Cde_Ent_Qte_4 = " +
        gCde_Ent.Cde_Ent_Qte_4.toStringAsFixed(2).toString() +
        ", Cde_Ent_Mt_4  = " +
        gCde_Ent.Cde_Ent_Mt_4.toStringAsFixed(2).toString() +
        ", Cde_Ent_Net_4 = " +
        gCde_Ent.Cde_Ent_Net_4.toStringAsFixed(2).toString() +
        ", Cde_Ent_Px_5  = " +
        gCde_Ent.Cde_Ent_Px_5.toStringAsFixed(2).toString() +
        ", Cde_Ent_Qte_5 = " +
        gCde_Ent.Cde_Ent_Qte_5.toStringAsFixed(2).toString() +
        ", Cde_Ent_Mt_5  = " +
        gCde_Ent.Cde_Ent_Mt_5.toStringAsFixed(2).toString() +
        ", Cde_Ent_Net_5 = " +
        gCde_Ent.Cde_Ent_Net_5.toStringAsFixed(2).toString() +
        ", Cde_Ent_Lib_1 = \"" +
        gCde_Ent.Cde_Ent_Lib_1 +
        "\""
            ", Cde_Ent_Lib_2 = \"" +
        gCde_Ent.Cde_Ent_Lib_2 +
        "\""
            ", Cde_Ent_Lib_3 = \"" +
        gCde_Ent.Cde_Ent_Lib_3 +
        "\""
            ", Cde_Ent_Lib_4 = \"" +
        gCde_Ent.Cde_Ent_Lib_4 +
        "\""
            ", Cde_Ent_Lib_5 = \"" +
        gCde_Ent.Cde_Ent_Lib_5 +
        "\""
            ", Cde_Ent_Rep_Lib = \"" +
        gCde_Ent.Cde_Ent_Rep_Lib +
        "\" "
            ", Cde_Ent_indexDevis = " +
        gCde_Ent.Cde_Ent_indexDevis.toString() +
        ", Cde_Ent_indexFacture = " +
        gCde_Ent.Cde_Ent_indexFacture.toString() +
        " WHERE Cde_Entid = " +
        gCde_Ent.Cde_Entid.toString();

    print("setCde_Ent " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("setCde_Ent ret " + ret.toString());
    return ret;
  }

  static Future<bool> addCde_Ent(Cde_Ent wCde_Ent) async {
    int wFact = wCde_Ent.Cde_Ent_Fact ? 1 : 0;
    int wAnnul = wCde_Ent.Cde_Ent_Annul ? 1 : 0;
    int wCde_Ent_EDT = wCde_Ent.Cde_Ent_EDT ? 1 : 0;

    String aSQL =
        "INSERT INTO Cde_Ent ( Cde_Ent_Invid, Cde_Ent_DF, Cde_Ent_EDT,  Cde_Ent_Remarque, Cde_Ent_Tx_Tks, Cde_Ent_Tot_HT,Cde_Ent_Tot_TVA ,Cde_Ent_Tot_TTC, Cde_Ent_Tot_CLIENT, Cde_Ent_Fact,Cde_Ent_Annul,Cde_Ent_Rep_Net,Cde_Ent_Rem_Net"
                ", Cde_Ent_Px_1, Cde_Ent_Qte_1, Cde_Ent_Mt_1, Cde_Ent_Net_1"
                ", Cde_Ent_Px_2, Cde_Ent_Qte_2, Cde_Ent_Mt_2, Cde_Ent_Net_2"
                ", Cde_Ent_Px_3, Cde_Ent_Qte_3, Cde_Ent_Mt_3, Cde_Ent_Net_3"
                ", Cde_Ent_Px_4, Cde_Ent_Qte_4, Cde_Ent_Mt_4, Cde_Ent_Net_4"
                ", Cde_Ent_Px_5, Cde_Ent_Qte_5, Cde_Ent_Mt_5, Cde_Ent_Net_5"
                ", Cde_Ent_Lib_1, Cde_Ent_Lib_2, Cde_Ent_Lib_3, Cde_Ent_Lib_4, Cde_Ent_Lib_5"
                ", Cde_Ent_Rep_Lib,Cde_Ent_Rem_Lib, Cde_Ent_indexDevis, Cde_Ent_indexFacture"
                " ) " +
            "VALUES ( " +
            gInventaire.id.toString() +
            ", " +
            "\"" +
            wCde_Ent.Cde_Ent_DF +
            "\", "
                "" +
            wCde_Ent_EDT.toString() +
            ", "
                "\"" +
            wCde_Ent.Cde_Ent_Remarque +
            "\", "
                "" +
            wCde_Ent.Cde_Ent_Tx_Tks.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Tot_HT.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Tot_TVA.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Tot_TTC.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Tot_CLIENT.toStringAsFixed(2).toString() +
            ", "
                "" +
            wFact.toString() +
            ", "
                "" +
            wAnnul.toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Rep_Net.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Rem_Net.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Px_1.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Qte_1.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Mt_1.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Net_1.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Px_2.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Qte_2.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Mt_2.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Net_2.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Px_3.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Qte_3.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Mt_3.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Net_3.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Px_4.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Qte_4.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Mt_4.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Net_4.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Px_5.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Qte_5.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Mt_5.toStringAsFixed(2).toString() +
            ", "
                "" +
            wCde_Ent.Cde_Ent_Net_5.toStringAsFixed(2).toString() +
            ", "
                "\"" +
            wCde_Ent.Cde_Ent_Lib_1 +
            "\", "
                "\"" +
            wCde_Ent.Cde_Ent_Lib_2 +
            "\", "
                "\"" +
            wCde_Ent.Cde_Ent_Lib_3 +
            "\", "
                "\"" +
            wCde_Ent.Cde_Ent_Lib_4 +
            "\", "
                "\"" +
            wCde_Ent.Cde_Ent_Lib_5 +
            "\", "
                "\"" +
            wCde_Ent.Cde_Ent_Rep_Lib +
            "\", " +
            "\"" +
            wCde_Ent.Cde_Ent_Rem_Lib +
            "\", " +
            wCde_Ent.Cde_Ent_indexDevis.toString() +
            ", " +
            wCde_Ent.Cde_Ent_indexFacture.toString() +
            ")";
    print("addCde_Ent " + aSQL);
    bool ret = await add_API_Post("insert", aSQL);
    print("addCde_Ent ret " + ret.toString());
    return ret;
  }

  //****************************************************
  //************************  Inventaire  ***********
  //****************************************************

  static List<Inventaire> ListInventaire = [];
  static List<Inventaire> ListInventaireCalendar = [];
  static Inventaire gInventaire = Inventaire(
      -1,
      gEtablissement.id,
      gEtablissement.id,
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      0,
      "",
      "",
      "Agence",
      "agence",
      0,
      0,
      0,
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      false,
      false,
      false,
      false,
      "",
      "",
      0,
      false,
      "",
      0,
      0,
      "",
      "",
  "",
  "", "", "");

  //****************************************************
  //****************************************************
  //****************************************************

  //****************************************************
  //************************  CALCUL MONTANTS  **********
  //****************************************************

  static double Mt_Dem_HT_Inv = 0;
  static double Mt_Dem_HT_Dev = 0;
  static double Mt_Dem_HT_Fact = 0;

  static Calcul_Montants() async {
    Mt_Dem_HT_Inv = 0;
    Mt_Dem_HT_Dev = 0;
    Mt_Dem_HT_Fact = 0;

    print("≈~~~~~~~~~~~~~~~~~~~~~~~~ CALCUL MONTANTS ${gInventaire.etabid}");

    Etablissement wEtablissement =
        DbTools.getEtablissementsbyID(gInventaire.etabid);

    await DbTools.getInventaireDets();

    double mtM3 = 0;
    if (ListInventaireDet != null) {
      ListInventaireDet.forEach((element) {
        if (element.CDE == "D") mtM3 += element.M3;
      });
    }
    Mt_Dem_HT_Inv = mtM3 * wEtablissement.MtDechM3;

    print(
        "≈~~~~~~~~~~~~~~~~~~~~~~~~ CALCUL MONTANTS INV $mtM3 * ${gEtablissement.MtDechM3} $Mt_Dem_HT_Inv");

    await DbTools.getCde_Ent();
    double MtLig = 0;
    double QteLig = 0;
    double MtBrut = 0;

    if (DbTools.ListCde_Ent.length >= 1) {
      DbTools.gCde_Ent = DbTools.ListCde_Ent[0];

      MtLig = 0;
      MtLig += DbTools.gCde_Ent.Cde_Ent_Mt_1;
      MtLig += DbTools.gCde_Ent.Cde_Ent_Mt_2;
      MtLig += DbTools.gCde_Ent.Cde_Ent_Mt_3;
      MtLig += DbTools.gCde_Ent.Cde_Ent_Mt_4;
      MtLig += DbTools.gCde_Ent.Cde_Ent_Mt_5;
      Mt_Dem_HT_Dev += MtLig;
      print("≈~~~~~~~~~~~~~~~~~~~~~~~~ CALCUL MONTANTS DEVIS ${Mt_Dem_HT_Dev}");
    }
    if (DbTools.ListCde_Ent.length >= 2) {
      DbTools.gCde_Ent = DbTools.ListCde_Ent[1];
      MtLig = 0;
      MtLig += DbTools.gCde_Ent.Cde_Ent_Mt_1;
      MtLig += DbTools.gCde_Ent.Cde_Ent_Mt_2;
      MtLig += DbTools.gCde_Ent.Cde_Ent_Mt_3;
      MtLig += DbTools.gCde_Ent.Cde_Ent_Mt_4;
      MtLig += DbTools.gCde_Ent.Cde_Ent_Mt_5;
      Mt_Dem_HT_Fact += MtLig;

      print("≈~~~~~~~~~~~~~~~~~~~~~~~~ CALCUL MONTANTS FACT ${Mt_Dem_HT_Fact}");
    }
  }

  static CalculMtDecheterie() async {
    double mtM3 = 0;

    if (ListInventaireDet != null) {
      ListInventaireDet.forEach((element) {
        if (element.CDE == "D") mtM3 += element.M3;
      });
    }

    double mtDech = mtM3 * gEtablissement.MtDechM3;

    gInventaire.Mt_Dem_HT = mtDech;

    double Mt_TKS_HT = 0;
    if (ListCde_Ent != null) {
      ListCde_Ent.forEach((element) {
        Mt_TKS_HT += element.Cde_Ent_Tot_HT;
      });
    }

    gInventaire.Mt_TKS_HT = Mt_TKS_HT;

    CalculTaux();

    await setInventaire();

    print(
        "≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ Mt_Dem_HT ${gInventaire.Mt_Dem_HT} Mt_TKS_HT ${gInventaire.Mt_TKS_HT}");
  }

  static CalculTaux() {
    double Mt_TX = 0;
    double Mt_Dem_HT = 0;

    double Mt_Inv_HT = gInventaire.Mt_Dem_HT;
    double Mt_Devis_HT = gInventaire.Mt_TKS_HT;

    if (Mt_Devis_HT > 0)
      Mt_Dem_HT = Mt_Devis_HT;
    else
      Mt_Dem_HT = Mt_Inv_HT;

    if (Mt_Dem_HT < 1000) {
      Mt_TX = 30;
    } else if (Mt_Dem_HT < 2000) {
      Mt_TX = 25;
    } else {
      Mt_TX = 20;
    }

    if (DbTools.gInventaire.Origine == "HEXA")
      Mt_TX = 5;

    print(
        "≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ CalculTaux ${gInventaire.Tx} TxForce ${gInventaire.TxForce} Mt_TKS_HT ${gInventaire.TxForce}");

    gInventaire.Tx = Mt_TX;
// tedted    if (gInventaire.TxForce == 0) gInventaire.TxForce = Mt_TX;
  }

  //****************************************************
  //****************************************************
  //****************************************************

  static Future<bool> getInventairesNewCT() async {
    String aSQL = "select * FROM Inventaires WHERE etabid = ${gEtablissement.id} and (etabid = etabidOrigine OR (etabid != etabidOrigine AND AffAccept > 1)) order by Nom";
    print("getInventaires " + aSQL);

    ListInventaire = await getInventaire_API_Post("select", aSQL);
    print("getInventaires <");
    if (ListInventaire == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getInventairesNewCT_Encours() async {
    String aSQL = "select * FROM Inventaires WHERE etabid = ${gEtablissement.id} and AffAccept = 0 AND etabid !=  etabidOrigine AND Status != 8 order by Nom";
    print("getInventaires " + aSQL);

    ListInventaire = await getInventaire_API_Post("select", aSQL);
    print("getInventaires <");
    if (ListInventaire == null) {
      return false;
    } else {
      return true;
    }
  }



  static Future<bool> getInventaires() async {

    String aSQL = "select * FROM Inventaires WHERE etabid = ${gEtablissement.id}  order by Nom";
    print("getInventaires " + aSQL);

    ListInventaire = await getInventaire_API_Post("select", aSQL);
    print("getInventaires <");
    if (ListInventaire == null) {
      return false;
    } else {
      return true;
    }
  }


  static Future<bool> getInventaire(int ID) async {
    String aSQL = "select * FROM Inventaires WHERE id = ${ID}";
    print("ListInventaireCalendar " + aSQL);
    List<Inventaire> wListInventaire = [];

    wListInventaire = await getInventaire_API_Post("select", aSQL);
    print("wListInventaire <");
    if (wListInventaire != null) {
      DbTools.gInventaire = wListInventaire[0];
      return true;
    } else {
      return false;
    }
  }




  static Future<bool> getInventaires_Calendar(int EtabID) async {
    String aSQL =
        "select * FROM Inventaires WHERE etabid = ${EtabID}  AND Status < 7 AND ( !ISNULL( DateInv) OR !ISNULL( DateDeb));";
    print("ListInventaireCalendar " + aSQL);

    ListInventaireCalendar = await getInventaire_API_Post("select", aSQL);
    print("ListInventaireCalendar <");
    if (ListInventaireCalendar == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getInventairesEtabID(int EtabID) async {
    String aSQL =
        "select * FROM Inventaires WHERE etabid = ${EtabID} OR etabidOrigine = ${EtabID}  order by Nom";

    ListInventaire = await getInventaire_API_Post("select", aSQL);

    print("getInventairesEtabID ListInventaire ${ListInventaire.length}");


    if (ListInventaire == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getInventairesEtabID50100(int EtabID) async {
    String aSQL =
        "select Inventaires.* FROM Inventaires, Etablissements WHERE etabid = Etablissements.id AND Etablissements.IsNewCT = 1 and (etabid = ${EtabID} OR etabidOrigine = ${EtabID}) AND etabid !=  etabidOrigine AND  AffAccept != 99 AND Status !=8 order by Nom";

    ListInventaire = await getInventaire_API_Post("select", aSQL);

    print("getInventairesEtabID ListInventaire ${ListInventaire.length}");


    if (ListInventaire == null) {
      return false;
    } else {
      return true;
    }
  }


  static Future<bool> getInventairesEtabID_NewCT(int EtabID) async {
    String aSQL =
        "select * FROM Inventaires WHERE (etabid = ${EtabID} OR etabidOrigine = ${EtabID}) AND Origine != 'Agence' AND  AffAccept < 99 order by Nom";

    print("getInventairesEtabID_NewCT aSQL ${aSQL}");


    ListInventaire = await getInventaire_API_Post("select", aSQL);
    if (ListInventaire == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getInventairesEtabID_AllCT(int EtabID) async {
    String aSQL =
        "select * FROM Inventaires WHERE (etabid = ${EtabID} OR etabidOrigine = ${EtabID}) AND Status < 8 order by id";

    print("getInventairesEtabID_NewCT aSQL ${aSQL}");


    ListInventaire = await getInventaire_API_Post("select", aSQL);
    if (ListInventaire == null) {
      return false;
    } else {
      return true;
    }
  }


  static Future<bool> getInventairesAll(String aName) async {
    String aSQL =
        "select * FROM Inventaires WHERE UPPER(Nom) LIKE UPPER('%${aName}%') OR UPPER(Adresse1) LIKE UPPER('%${aName}%')  OR UPPER(Ville) LIKE UPPER('%${aName}%') order by Nom";
    ListInventaire = await getInventaire_API_Post("select", aSQL);
    if (ListInventaire == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getInventairesActif() async {
    String aSQL =
        "select * FROM Inventaires WHERE `Status` !=8 ";
    ListInventaire = await getInventaire_API_Post("select", aSQL);
    if (ListInventaire == null) {
      return false;
    } else {
      return true;
    }
  }



  static Future<List<Inventaire>> getInventaire_API_Post(
      String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    print("request $aSQL");

    final bodys = {'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL};



    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));



    request.fields.addAll(bodys);


    http.StreamedResponse response;


    response = await request.send();


    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      var success = parsedJson['success'];
      final items = parsedJson['data'];

      if (items != null) {
        List<Inventaire> InventaireList = items.map<Inventaire>((json) {
          return Inventaire.fromJson(json);
        }).toList();
        return InventaireList;
      }
    } else {
      print("getInventaire_API_Post reasonPhrase ${response.reasonPhrase}");
    }
    return [];
  }

  static int ActionIDtoStatus(int Action) {
    int wRet = 0;
    if (Action < 50) {
      wRet = 0;
    } else if (Action < 60) {
      wRet = 1;
    } else if (Action < 90) {
      wRet = 2;
    } else if (Action < 100) {
      wRet = 3;
    } else if (Action < 120) {
      wRet = 4;
    } else if (Action < 130) {
      wRet = 5;
    } else if (Action <= 140) {
      wRet = 6;
    } else if (Action <= 160) {
      wRet = 6;
    } else if (Action <= 200) {
      wRet = 7;
    } else if (Action <= 210) {
      wRet = 8;
    }

//    print("ActionIDtoStatus ${Action} ${wRet}");

    return wRet;
  }

/*


SELECT DateInv, DateDeb, Date,  CONCAT(MID(Date, 7, 4) , '-' , MID(Date, 4, 2)  , '-' , MID(Date, 1, 2)) FROM Inventaires,InventaireAction  WHERE Inventaires.id = invid and Actionid = 50 and OK = 1;


UPDATE Inventaires i
INNER JOIN InventaireAction a
  ON i.id = a.invid
SET i.DateInv = CONCAT(MID(a.Date, 7, 4) , '-' , MID(a.Date, 4, 2)  , '-' , MID(a.Date, 1, 2))
WHERE a.Actionid = 50 and a.OK = 1;


UPDATE Inventaires i
INNER JOIN InventaireAction a
  ON i.id = a.invid
SET i.DateDeb = CONCAT(MID(a.Date, 7, 4) , '-' , MID(a.Date, 4, 2)  , '-' , MID(a.Date, 1, 2))
WHERE a.Actionid = 120 and a.OK = 1;


*/

  static Future<void> setInventaireStatus() async {
//    if (gInventaire.Status >= 7) return;
    int MaxAction = 0;
    ListInventaireAction.forEach((element) {
      if (element.OK == 1) {
        MaxAction = element.Actionid;
      }

      if (element.Actionid == 50) {
        DbTools.gInventaire.DateInv = element.OK == 1 ? element.Date : "";
      }

      if (element.Actionid == 120) {
        DbTools.gInventaire.DateDeb = element.OK == 1 ? element.Date : "";
      }
    });

    gInventaire.Status = ActionIDtoStatus(MaxAction);

    print("DateInv ${DbTools.gInventaire.DateInv}");
    print("DateDeb ${DbTools.gInventaire.DateDeb}");

    setInventaire();


//0 "Fiche Client";
//1 "Saisie Mob.";
//2 "Validation PC"
//3 "Edition"
//4 "Devis"
//5 "Débarras"
//6 "Fact/Solde"
//7 "Cloture"
//8 "Annulation"
  }

  static String getDateFmt(String wDate) {
    String wDateRet = "";

    try {
      var wDateI = new DateFormat('dd-MM-yyyy hh:mm').parse(wDate);

      wDateRet = DateFormat('yyyy-MM-dd HH:mm').format(wDateI);

      return wDateRet;
    } catch (e) {
      return "";
    }
  }

  static Future<bool> setInventaire() async {
    print(">>>>>>>>>>>>> setInventaire gInventaire.TxForce ${gInventaire.TxForce}");

    int wFinCh_Opt_1 = gInventaire.FinCh_Opt_1 ? 1 : 0;
    int wFinCh_Opt_2 = gInventaire.FinCh_Opt_2 ? 1 : 0;
    int wFinCh_Opt_3 = gInventaire.FinCh_Opt_3 ? 1 : 0;
    int wFinCh_Opt_4 = gInventaire.FinCh_Opt_4 ? 1 : 0;

    String wDateInv = getDateFmt(gInventaire.DateInv);
    String wDateDeb = getDateFmt(gInventaire.DateDeb);

    String wDateInvStr =
        wDateInv != "" ? ", DateInv = '${wDateInv}'" : ", DateInv = NULL";
    String wDateDebStr =
        wDateDeb != "" ? ", DateDeb = '${wDateDeb}'" : ", DateDeb = NULL";

    gInventaire.Purge();

    String aSQL = "UPDATE Inventaires SET Nom = \"" +
        gInventaire.nom +
        "\", Adresse1 = \"" +
        gInventaire.adresse1 +
        "\", Adresse2 = \"" +
        gInventaire.adresse2 +
        "\", Cp = \"" +
        gInventaire.cp +
        "\", Ville = \"" +
        gInventaire.ville +
        "\", Tel = \"" +
        gInventaire.tel +
        "\", Mail = \"" +
        gInventaire.mail +
        "\", Status = " +
        gInventaire.Status.toString() +
        ",CarteIdentite = \"" +
        gInventaire.CarteIdentite +
        "\", Origine = \"" +
        gInventaire.Origine +
        "\",Source = \"" +
        gInventaire.Source +
        "\",etabid = " +
        gInventaire.etabid.toString() +
        ",Mt_Dem_HT = " +
        gInventaire.Mt_Dem_HT.toString() +
        ",Tx = " +
        gInventaire.Tx.toString() +
        ",Mt_TKS_HT = " +
        gInventaire.Mt_TKS_HT.toString() +
        ", fNom = \"" +
        gInventaire.fnom +
        "\", fAdresse1 = \"" +
        gInventaire.fadresse1 +
        "\", fAdresse2 = \"" +
        gInventaire.fadresse2 +
        "\", fCp = \"" +
        gInventaire.fcp +
        "\", fVille = \"" +
        gInventaire.fville +
        "\", fTel = \"" +
        gInventaire.ftel +
        "\""
            ", fMail = \"" +
        gInventaire.fmail +
        "\""
            ", FinCh_Opt_1 = " +
        wFinCh_Opt_1.toString() +
        ", FinCh_Opt_2 = " +
        wFinCh_Opt_2.toString() +
        ", FinCh_Opt_3 = " +
        wFinCh_Opt_3.toString() +
        ", FinCh_Opt_4 = " +
        wFinCh_Opt_4.toString() +
        ", NatureBien = \"" +
        gInventaire.NatureBien +
        "\", NomReduit = \"" +
        gInventaire.NomReduit +
        "\", Remarque = \"" +
        gInventaire.Remarque +
        "\", AffDem = \"" +
        gInventaire.AffDem.toString() +
        "\", Date_Push = \"" +
        gInventaire.Date_Push.toString() +
        "\", Date_Accept = \"" +
        gInventaire.Date_Accept.toString() +
        "\", Presc = \"" +
        gInventaire.Presc.toString() +
        "\", AffAccept = " +
        gInventaire.AffAccept.toString() +
        ", TxForce = " +
        gInventaire.TxForce.toString() +
        ", GenFdc = " +
        gInventaire.GenFdc.toString() +
        wDateInvStr +
        wDateDebStr +
        " WHERE id = " +
        gInventaire.id.toString();
    print("setInventaire " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("setInventaire ret " + ret.toString());
    return ret;




  }

  static Future<bool> addInventaires() async {
    String aSQL = "INSERT INTO Inventaires (etabid,etabidOrigine, Nom) VALUES ( ${gEtablissement.id},${gEtablissement.id}, '****** Ajout *****')";
    print("addInventairesDet " + aSQL);
    bool ret = await add_API_Post("insert", aSQL);
    print("addInventaires ret " + ret.toString());
    return ret;
  }

  //****************************************************
  //************************  InventaireDet  ***********
  //****************************************************

  static List<InventaireDet> ListInventaireDet = [];
  static List<InventaireDet> ListInventaireDetPieces = [];
  static late InventaireDet gInventaireDet;
  static late String gInventaireDetPiece;

  static double gInventaireDet_Px_Achat = 0.0;
  static double gInventaireDet_M3 = 0.0;

  //****************************************************
  //****************************************************
  //****************************************************

  static Future<bool> getInventaireDetsPieces() async {
    String aSQL =
        "select * FROM InventairesDet WHERE invid = ${gInventaire.id}  group by Piece order by id";
    print("getInventaireDetsPieces() " + aSQL);

    ListInventaireDetPieces = await getInventaireDet_API_Post("select", aSQL);
    if (ListInventaireDetPieces == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getInventaireDets() async {
    String aSQL =
        "select * FROM InventairesDet WHERE invid = ${gInventaire.id}  order by id";

    print("getInventaireDets " + aSQL);

    ListInventaireDet = await getInventaireDet_API_Post("select", aSQL);
    if (ListInventaireDet == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getInventaireDets_Tot() async {
    String aSQL =
        "select * FROM InventairesDet WHERE invid = ${gInventaire.id}  order by id";

    print("getInventaireDets " + aSQL);

    gInventaireDet_Px_Achat = 0.0;
    gInventaireDet_M3 = 0.0;

    List<InventaireDet> wListInventaireDet = [];
    wListInventaireDet = await getInventaireDet_API_Post("select", aSQL);
    if (wListInventaireDet == null) {
      return false;
    } else {
      wListInventaireDet.forEach((element) async {
        if (element.libelle != "--- Fin de Chantier ---") {
          gInventaireDet_Px_Achat += element.Px_Achat;
          if (element.CDE == "D") gInventaireDet_M3 += element.M3;
        }
      });

      return true;
    }
  }

  static Future<List<InventaireDet>> getInventaireDet_API_Post(
      String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=

    final bodys = {'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL};

    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll(bodys);

    http.StreamedResponse response;

    response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      var success = parsedJson['success'];
      final items = parsedJson['data'];

      if (items != null) {
        List<InventaireDet> InventaireDetList =
            items.map<InventaireDet>((json) {
          return InventaireDet.fromJson(json);
        }).toList();
        return InventaireDetList;
      }
    } else {
      print("getInventaireDet_API_Post reasonPhrase ${response.reasonPhrase}");
    }
    return [];
  }

  /*

  SELECT * FROM `InventairesDet` where `invid` = 673 ORDER BY `id` DESC

   */

  static Future<bool> delInventaires_Fin_de_Chantier() async {
    String aSQL = "DELETE FROM InventairesDet WHERE invid = " +
        gInventaire.id.toString() +
        " AND Libelle = \"--- Fin de Chantier ---\"";
    print("delInventairesDet " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delInventairesDet ret " + ret.toString());
    return ret;
  }

  static Future<bool> addInventairesDet_Fin_de_Chantier() async {
    bool ret = false;
    DbTools.ListInventaireDetPieces.forEach((element) async {
      bool TRV = false;
      DbTools.ListInventaireDet.forEach((elementf) {
        if (element.piece == elementf.piece &&
            elementf.libelle == "--- Fin de Chantier ---") TRV = true;
      });

      if (!TRV) {
        String aSQL =
            "INSERT INTO InventairesDet ( invid, Piece, libelle) VALUES ( " +
                element.invid.toString() +
                ",  '" +
                element.piece +
                "',  '--- Fin de Chantier ---')";
        print("addInventairesDet " + aSQL);
        ret = await add_API_Post("insert", aSQL);
        print("addInventairesDet ret " + ret.toString());
      }
    });

    return ret;
  }

  static Future<bool> addInventairesDet() async {
    String aSQL =
        "INSERT INTO InventairesDet ( invid, Piece, libelle) VALUES ( " +
            gInventaire.id.toString() +
            ",  '" +
            gInventaireDetPiece +
            "',  '---   ---')";
    print("addInventairesDet " + aSQL);
    bool ret = await add_API_Post("insert", aSQL);
    print("addInventairesDet ret " + ret.toString());
    return ret;
  }

  static Future<bool> setInventaireDet() async {
    gInventaireDet.Purge();

    String aSQL = "UPDATE InventairesDet SET CDE = '" +
        gInventaireDet.CDE +
        "', " +
        " Piece = '" +
        gInventaireDet.piece +
        "', " +
        " Libelle = '" +
        gInventaireDet.libelle +
        "', " +
        " Px_Vente = " +
        gInventaireDet.Px_Vente.toString() +
        ", " +
        " Px_Achat = " +
        gInventaireDet.Px_Achat.toString() +
        ", " +
        " Temps = " +
        gInventaireDet.Temps.toString() +
        ", " +
        " M3 = " +
        gInventaireDet.M3.toString() +
        ", " +
        " Tri = '" +
        gInventaireDet.Tri +
        "', " +
        " Demontage = '" +
        gInventaireDet.Demontage +
        "', " +
        " Manip_Delicate = '" +
        gInventaireDet.Manip_Delicate +
        "', " +
        " Autre = '" +
        gInventaireDet.Autre +
        "' " +
        " WHERE id = " +
        gInventaireDet.id.toString();

    print("setInventaireDet " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("setInventaireDet ret " + ret.toString());
    return ret;
  }

  static Future<bool> delInventairesDet() async {
    String aSQL =
        "DELETE FROM InventairesDet WHERE id = " + gInventaireDet.id.toString();
    print("delInventairesDet " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delInventairesDet ret " + ret.toString());
    return ret;
  }

  static Future<bool> delInventairesPiece() async {
    String aSQL = "DELETE FROM InventairesDet WHERE invid = " +
        gInventaireDet.invid.toString() +
        " AND piece =  \"" +
        gInventaireDet.piece +
        "\"";
    print("delInventairesDet " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delInventairesDet ret " + ret.toString());
    return ret;
  }

  //****************************************************
  //************************  Action  ***********
  //****************************************************

  static List<pActions> ListAction = [];

  //****************************************************
  //****************************************************
  //****************************************************

  static Future<bool> getActions() async {
    String aSQL = "select * FROM Actions order by Actionid";
    ListAction = await getAction_API_Post("select", aSQL);
    if (ListAction == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<List<pActions>> getAction_API_Post(
      String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=

    final bodys = {'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL};

    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll(bodys);

    http.StreamedResponse response;

    response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      var success = parsedJson['success'];
      final items = parsedJson['data'];

      if (items != null) {
        List<pActions> ActionList = items.map<pActions>((json) {
          return pActions.fromJson(json);
        }).toList();
        return ActionList;
      }
    } else {
      print("getAction_API_Post reasonPhrase ${response.reasonPhrase}");
    }
    return [];
  }

  //****************************************************
  //************************  InventaireAction  ***********
  //****************************************************

  static List<InventaireAction> ListInventaireAction = [];
  static InventaireAction gInventaireAction =
      InventaireAction(0, 0, 0, "", 0, "", "");

  //****************************************************
  //****************************************************
  //****************************************************

  static Future<bool> genInventaireActions() async {
//    String aSQL = "INSERT INTO InventaireAction (id, invid , Actionid, Action) SELECT null, ${gInventaire.id}, Actionid, Action FROM Actions";

    String aSQL =
        "INSERT INTO InventaireAction (id, invid , Actionid, Action, OK, Date,Remarque) SELECT null, ${gInventaire.id}, A.Actionid, A.Action,  0, '', '' FROM Actions A LEFT JOIN InventaireAction I ON A.Actionid = I.Actionid AND I.invid = ${gInventaire.id} WHERE I.invid IS NULL;";

    print("genInventaireActions " + aSQL);

    ListInventaireAction = await getInventaireAction_API_Post("select", aSQL);
    if (ListInventaireAction == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> updateInventaireAction() async {
    String aSQL =
        "UPDATE InventaireAction, Actions SET InventaireAction.Action = Actions.Action WHERE InventaireAction.Actionid = Actions.Actionid AND InventaireAction.invid = ${gInventaire.id}";
    print("updateInventaireAction " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("updateInventaireAction ret " + ret.toString());
    return ret;
  }


  static Future<bool> initInventaireActions() async {
    String aSQL = "UPDATE InventaireAction SET " +
        " OK = 1, " +
        " Date = '${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}' " +
        " WHERE invid = ${gInventaire.id.toString()} AND OK = 0 AND Actionid = 10";
    print("setInventaireAction " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("setInventaireAction ret " + ret.toString());
    return ret;
  }

  static Future<bool> RemQualInventaireActions(String Remarque) async {
    String aSQL = "UPDATE InventaireAction SET " +
        " OK = 1, " +
        " Date = '${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}', " +
        " Remarque = '$Remarque' " +
        " WHERE invid = ${gInventaire.id.toString()} AND Actionid = 20";
    print("setInventaireAction " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("setInventaireAction ret " + ret.toString());
    return ret;
  }



  static Future<bool> getInventaireActions() async {
    String aSQL =
        "select * FROM InventaireAction WHERE invid = ${gInventaire.id}  order by id";

    if (gInventaire.etabidOrigine != 14)
      aSQL =
          "select * FROM InventaireAction, Actions WHERE InventaireAction.Actionid = Actions.Actionid AND Actions.Agence = 1 AND invid = ${gInventaire.id}  order by id";

    ListInventaireAction = await getInventaireAction_API_Post("select", aSQL);
    if (ListInventaireAction == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<List<InventaireAction>> getInventaireAction_API_Post(
      String aType, String aSQL) async {
    print("getInventaireAction_API_Post aSQL ${aSQL}");

    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=

    final bodys = {'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL};

    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll(bodys);

    http.StreamedResponse response;

    response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      var success = parsedJson['success'];
      final items = parsedJson['data'];

      if (items != null) {
        List<InventaireAction> InventaireActionList =
            items.map<InventaireAction>((json) {
          return InventaireAction.fromJson(json);
        }).toList();
        return InventaireActionList;
      }
    } else {
      print(
          "getInventaireAction_API_Post reasonPhrase ${response.reasonPhrase}");
    }
    return [];
  }

  static Future<bool> addInventaireAction() async {
    String aSQL =
        "INSERT INTO InventaireAction ( invid, Actionid, Action, Date, Remarque, ) VALUES ( " +
            gInventaire.id.toString() +
            ", " +
            gInventaireAction.Actionid.toString() +
            ",  '" +
            gInventaireAction.Action +
            "', '" +
            gInventaireAction.Date +
            "','" +
            gInventaireAction.Remarque +
            "')";
    print("addInventaireAction " + aSQL);
    bool ret = await add_API_Post("insert", aSQL);
    print("addInventaireAction ret " + ret.toString());
    return ret;
  }

  static Future<bool> setInventaireAction() async {
    gInventaireAction.Remarque = gInventaireAction.Remarque.replaceAll("'", "’");

    String aSQL = "UPDATE InventaireAction SET " +
        " Action = '" +
        gInventaireAction.Action +
        "', " +
        " OK = " +
        gInventaireAction.OK.toString() +
        ", " +
        " Date = '" +
        gInventaireAction.Date +
        "', " +
        " Remarque = '" +
        gInventaireAction.Remarque +
        "' " +
        " WHERE id = " +
        gInventaireAction.id.toString();

    print("setInventaireAction " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("setInventaireAction ret " + ret.toString());
    return ret;
  }

  static Future<bool> setInventaireActionLot(int MaxAction) async {
    if (MaxAction == 120) {
//        delInventaires_Fin_de_Chantier();
      print("≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈ setInventaireActionLot");
      addInventairesDet_Fin_de_Chantier();
    }

    String aSQL = "UPDATE InventaireAction SET " +
        " OK = 1, " +
        " Date = '${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}' " +
        " WHERE invid = ${gInventaire.id.toString()} AND OK = 0 AND Actionid <= $MaxAction";
    print("setInventaireActionLot " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("setInventaireActionLot ret " + ret.toString());
    return ret;
  }

  static Future<bool> delInventaireAction() async {
    String aSQL = "DELETE FROM InventaireAction WHERE id = " +
        gInventaireAction.id.toString();
    print("delInventaireAction " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delInventaireAction ret " + ret.toString());
    return ret;
  }

  //****************************************************
  //************************  InventaireDetPhoto  ***********
  //****************************************************

  static List<InventaireDetPhoto> ListInventaireDetPhoto = [];
  static List<InventaireDetPhoto> ListInventaireDetPhotoAll = [];
  static late InventaireDetPhoto gInventaireDetPhoto;

  static List<PdfBitmap> PdfBitmapList = [];
  static List<String> PdfBitmapNameList = [];

  static List<PdfBitmap> PdfBitmapSign = [];

  //****************************************************
  //****************************************************
  //****************************************************

  static Future<bool> getInventaireDetPhotos() async {
    String aSQL =
        "select * FROM InventairesDetPhoto WHERE invdetid = ${gInventaireDet.id}  order by id";
    ListInventaireDetPhoto =
        await getInventaireDetPhoto_API_Post("select", aSQL);
    if (ListInventaireDetPhoto == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getInventaireDetPhotosAll() async {
    String aSQL =
        "SELECT InventairesDetPhoto.* FROM InventairesDet,InventairesDetPhoto WHERE invid = ${gInventaire.id} AND InventairesDet.id = InventairesDetPhoto.invdetid group by InventairesDetPhoto.invdetid,InventairesDetPhoto.photo";
    ListInventaireDetPhotoAll =
        await getInventaireDetPhoto_API_Post("select", aSQL);
    if (ListInventaireDetPhotoAll == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> addInventaireDetPhotos(int aIndex) async {
    String wValue = "${gInventaireDet.id}, ${aIndex} ";
    String wSlq =
        "INSERT INTO InventairesDetPhoto( invdetid ,photo) VALUES (${wValue})";
    print("addInventaireDetPhotos " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    return ret;
  }

  static Future<List<InventaireDetPhoto>> getInventaireDetPhoto_API_Post(
      String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=

    print("getITC_Data_API_Post SrvTokenSrvToken $SrvToken");
    print("getITC_Data_API_Post aType $aType");
    print("getITC_Data_API_Post eSQL $eSQL");
    print("getITC_Data_API_Post $aSQL");
    print("getInventaire_API_Post SrvUrl $SrvUrl");

    final bodys = {'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL};

    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll(bodys);

    http.StreamedResponse response;
    print("request.send");
    response = await request.send();
    print("response $response");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      var success = parsedJson['success'];
      final items = parsedJson['data'];

      if (items != null) {
        List<InventaireDetPhoto> InventaireDetPhotoList =
            items.map<InventaireDetPhoto>((json) {
          return InventaireDetPhoto.fromJson(json);
        }).toList();
        return InventaireDetPhotoList;
      }
    } else {
      print(
          "getInventaireDetPhoto_API_Post reasonPhrase ${response.reasonPhrase}");
    }
    return [];
  }

  static Future<bool> add_API_Post(String aType, String aSQL) async {
    setSrvToken();

    gLastID = -1;
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=

    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());

//      print("parsedJson " + parsedJson.toString());

      var success = parsedJson['success'];
      if (success == 1) {
        if (aType == "insert") {
          gLastID = parsedJson['last_id'];
          gLastIDObj = gLastID;
          print("$aType $gLastID");
        }

        return true;
      }
    } else {
      print(response.reasonPhrase);
    }
    return false;
  }

  static Future<bool> removephoto_API_Post(int aIndex) async {
    setSrvToken();
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));

    request.fields.addAll({
      'tic12z': SrvToken,
      'zasq': 'removephoto',
      'InventaireDetID': gInventaireDet.id.toString(),
      'InventaireDetPhoto': aIndex.toString(),
    });

    print("removephoto_API_Post ${request.fields}");

    http.StreamedResponse response = await request.send();
    print("removephoto_API_Post " + response.statusCode.toString());

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      var success = parsedJson['success'];
      if (success == 1) {
        return true;
      }
    } else {
      print(response.reasonPhrase);
    }
    return false;
  }


  static Future<bool> removephotoQualif_API_Post(int aIndex) async {
    setSrvToken();
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));

    request.fields.addAll({
      'tic12z': SrvToken,
      'zasq': 'removephotoqualif',
      'InventaireID': gInventaire.id.toString(),
      'InventairePhoto': aIndex.toString(),
    });

    print("removephotoQualif_API_Post ${request.fields}");

    http.StreamedResponse response = await request.send();
    print("removephotoQualif_API_Post " + response.statusCode.toString());

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());

      print("removephotoQualif_API_Post photopath " + parsedJson['photopath']);


      var success = parsedJson['success'];
      print("removephotoQualif_API_Post success ${parsedJson['success']}" );
      print("removephotoQualif_API_Post " + parsedJson['photopath']);
      if (success == 1) {
        return true;
      }
    } else {
      print(response.reasonPhrase);
    }
    return false;
  }



  //****************************************
  //****************************************
  //****************************************

  static Future<bool> SrvSendMail(String aTitle, String aBody, String aDate,
      String afrom, String aMail) async {


    aTitle = ReplaceWord(aTitle, aDate, "");
    aBody = ReplaceWord(aBody, aDate, "");

    aBody = aBody.replaceAll("\n", "<br>");
    aBody = aBody.replaceAll("'", "‘");

    aBody += "<br><br><br>";

    Etablissement wEtablissement =
        DbTools.getEtablissementsbyID(DbTools.gInventaire.etabid);

    setSrvToken();
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));

    request.fields.addAll({
      'tic12z': SrvToken,
      'zasq': 'mailprinthtml',
      'from': "${afrom}",
      'to': "${aMail}",
      "subject": '${aTitle}',
      "message": '${aBody}',
    });

    print("SrvSendMail ${request.fields}");

    http.StreamedResponse response = await request.send();
    print("SrvSendMail " + response.statusCode.toString());

    if (response.statusCode == 200) {
      var wRep = await response.stream.bytesToString();
      print("SrvSendMail success " + wRep.toString());

      return true;
    } else {
      print(response.reasonPhrase);
    }
    return false;
  }


  static Future<bool> TestMail(String aTitle, String aBody, String aDate,
      String afrom, String aMail) async {
    setSrvToken();
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrlt.toString()));
    request.fields.addAll({
      'tic12z': SrvToken,
      'zasq': 'testMail',
      'from': "${afrom}",
      'to': "${aMail}",
      "subject": '${aTitle}',
      "message": '${aBody}',
    });
    print("SrvSendMail ${request.fields}");
    http.StreamedResponse response = await request.send();
    print("SrvSendMail " + response.statusCode.toString());
    if (response.statusCode == 200) {
      var wRep = await response.stream.bytesToString();
      print("SrvSendMail success " + wRep.toString());
      return true;
    } else {
      print(response.reasonPhrase);
    }
    return false;
  }



  static String ReplaceWord(String aString, String aDate, String aAgence) {
    aString = aString.replaceAll("#ID#", "${DbTools.gInventaire.id}");
    aString = aString.replaceAll(
        "#Now#", "${DateFormat('dd-MM-yyyy hh:mm').format(DateTime.now())}");
    aString = aString.replaceAll("#Nom#", "${DbTools.gInventaire.nom}");
    aString = aString.replaceAll("#Date#", "${aDate}");

//    aString = aString.replaceAll("#Avis#", "${DbTools.gEtablissement.Url_Avis}");
    aString = aString.replaceAll("#Avis#", "${DbTools.AvisLink}");
    aString = aString.replaceAll("#Réduit#", "${DbTools.gInventaire.NomReduit}");


    aString = aString.replaceAll("#Ville#", "${DbTools.gInventaire.ville}");
    aString = aString.replaceAll("#Nature#", "${DbTools.gInventaire.NatureBien}");


    if (DbTools.gInventaire.AffAccept == 2)
      aString = aString.replaceAll("#50/100#", "50");
    else if (DbTools.gInventaire.AffAccept == 3)
      aString = aString.replaceAll("#50/100#", "100");
    else
      aString = aString.replaceAll("#50/100#", "???");




    aString = aString.replaceAll("#Signature#",
        "${DbTools.gEtablissement.Libelle}\n${DbTools.gEtablissement.tel}\n${DbTools.gEtablissement.mail}");

    aString = aString.replaceAll("#Date#", "${aDate}");

    aString = aString.replaceAll("#Agence#", "${aAgence}");

    return aString;
  }

  //****************************************
  //****************************************
  //****************************************

  static Future<bool> SrvSendPushNotifications(
      String aTitle, String aBody, String aDate) async {
    aTitle = ReplaceWord(aTitle, aDate, "");
    aBody = ReplaceWord(aBody, aDate, "");

    Etablissement wEtablissement = DbTools.getEtablissementsbyID(DbTools.gInventaire.etabid);
    print("SrvSendPushNotifications ${wEtablissement.AppToken_1}");
    setSrvToken();
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));

    aTitle = aTitle.replaceAll("'", "`");
    aBody = aBody.replaceAll("'", "`");

    request.fields.addAll({
      'tic12z': SrvToken,
      'zasq': 'push',
      'token1': "${wEtablissement.AppToken_1}",
      'token2': "${wEtablissement.AppToken_2}",
      'token3': "${wEtablissement.AppToken_3}",
      'token4': "${wEtablissement.AppToken_4}",
      'token5': "${wEtablissement.AppToken_5}",
      'etabid': "${DbTools.gInventaire.etabid}",
      "title": "${aTitle}",
      "body": "${aBody}",
      "invid": "${DbTools.gInventaire.id}",
    });

    print("SrvSendPushNotifications ${request.fields}");

    http.StreamedResponse response = await request.send();
    print("SrvSendPushNotifications " + response.statusCode.toString());

    if (response.statusCode == 200) {
      var wRep = await response.stream.bytesToString();
      print("SrvSendPushNotifications success " + wRep.toString());
      return true;
    } else {
      print(response.reasonPhrase);
    }
    return false;
  }

  static Future<bool> callOnFcmApiSendPushNotifications() async {
    print("callOnFcmApiSendPushNotifications ");
    List<String> userToken = [];

    Etablissement wEtablissement =
        DbTools.getEtablissementsbyID(DbTools.gInventaire.etabid);

    print("callOnFcmApiSendPushNotifications ${wEtablissement.Libelle}");
    print("callOnFcmApiSendPushNotifications ${wEtablissement.AppToken_1}");

    if (!wEtablissement.AppToken_1.isEmpty)
      userToken.add(wEtablissement.AppToken_1);
    if (!wEtablissement.AppToken_2.isEmpty)
      userToken.add(wEtablissement.AppToken_2);
    if (!wEtablissement.AppToken_3.isEmpty)
      userToken.add(wEtablissement.AppToken_3);
    if (!wEtablissement.AppToken_4.isEmpty)
      userToken.add(wEtablissement.AppToken_4);
    if (!wEtablissement.AppToken_5.isEmpty)
      userToken.add(wEtablissement.AppToken_5);

    if (userToken.length == 0) return false;

    print("callOnFcmApiSendPushNotifications ${userToken}");

    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "to": userToken,
      "collapse_key": "type_a",
      "notification": {
        "title": 'NewTextTitle',
        "body": 'NewTextBody',
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAA8TcdceY:APA91bG0fyNBxpMPva1BWiYcNGw9wXrcNtwLz7eCnsAjx_g0LDm4_a3-OG-BqkTQbf32OFIVZyJUU-1OgtiqoDgD8c_BIBiPN8HW0HNtFG6tsSNv0a-QXd7O0iXaL0wTU2AYyAwjOC6F'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error ${response.statusCode}');
      print(' CFM error ${response.body}');
      print(' CFM error ${response.headers}');
      print(' CFM error ${response.reasonPhrase}');
      // on failure do sth
      return false;
    }
  }
  //****************************************
  //****************************************
  //****************************************

  static void setSrvToken() {
    var uuid = Uuid();
    var v1 = uuid.v1();

    Random random = new Random();

    int Cut = random.nextInt(8) + 1;
    String sCut = "T" + Cut.toString();

    String S1 = SrvTokenKey.substring(0, Cut);
    String S2 = SrvTokenKey.substring(Cut);

    int F1 = random.nextInt(7);
    String sR3 = "P" + F1.toString().padLeft(2, '0');
    int F3 = random.nextInt(7);
    int F2 = 16 - F1 - F3;

    int R5 = F1 + Cut + 3 + F2 + 2;

    String sR5 = "S" + R5.toString().padLeft(2, '0');

//    print("v1 $v1");

    int C1 = random.nextInt(20) + 1;
    int C2 = random.nextInt(20) + 1;
    int C3 = random.nextInt(20) + 1;

//    print("F1  $C1 $F1");
//    print("F2  $C2 $F2");
//    print("F3  $C3 $F3");

    String sF1 = v1.substring(C1, C1 + F1);
//    print("sF1 $sF1");
    String sF2 = v1.substring(C2, C2 + F2);
//    print("sF2 $sF2");
    String sF3 = v1.substring(C3, C3 + F3);
//    print("sF3 $sF3");

//    print("SrvTokenKey $SrvTokenKey");
//    print("Cut $Cut $sCut");
//    print("S1 $S1");
//    print("S2 $S2");

//    print("R3 $sR3");
//    print("R5 $R5 $sR5");

    String Tok = sF1 + S1 + sR5 + sF2 + sCut + S2 + sR3 + sF3;
    int TokLen = Tok.length;
//    print("Tok $Tok $TokLen");

    SrvToken = Tok;

    int pT = Tok.indexOf('T') + 1;
    String rsT1 = Tok.substring(pT, pT + 1);
    int rT1 = int.parse(rsT1);
//    print("rT1 $rT1");
    int rT2 = 8 - rT1;
//    print("rT2 $rT2");

    int pP = Tok.indexOf('P') + 1;
//    print("pP $pP");
    String rsP = Tok.substring(pP, pP + 2);
    int rP = int.parse(rsP);
//    print("rP $rP");

    int pS = Tok.indexOf('S') + 1;
//    print("pS $pS");
    String rsS = Tok.substring(pS, pS + 2);
    int rS = int.parse(rsS);
//    print("rS $rS");

    String rR3 = Tok.substring(rP, rP + rT1);
    String rR5 = Tok.substring(rS, rS + rT2);
//    print("rR3 $rR3");
//    print("rR5 $rR5");

    String rR35 = rR3 + rR5;

//    print("VERIF $rR35");
  }

  //****************************************
//****************************************
//****************************************

  static void evictImage(String url) {
    final NetworkImage provider = NetworkImage(url);
    provider.evict().then<void>((bool success) {
      if (success) debugPrint('removed image!');
    });
  }

  static Future<Uint8List> networkImageToByte(String path) async {
    var response = await http.get(Uri.parse(path.toString()));
    if (response.statusCode == 200)
      {
//        print("networkImageToByte 200");
        return response.bodyBytes;
      }
    else
      {
//        print("networkImageToByte Error");
        return new Uint8List(0);
      }
  }

  static Future<Uint8List> resizeImage(Uint8List data) async {
    Uint8List resizedData = data;

    print("decodeImage > ${data.length}");
    IMG.Image? img = await IMG.decodeImage(data);
    print("decodeImage<");

    double wRatio = 1.0;
    var iwidth = img!.width;
    var iheight = img.height;

    double iRatio = iwidth / iheight;

    print("w ${iwidth} ${iheight}");

    print("iRatio ${iRatio}");

    if (iwidth < iheight) {
      IMG.Image resized = IMG.copyResize(img, width: 100, height: 200);
      var wresizedData = IMG.encodeJpg(resized);
      resizedData = Uint8List.fromList(wresizedData);
    } else {
      IMG.Image resized = IMG.copyResize(img, width: 100, height: 200);
      var wresizedData = IMG.encodeJpg(resized);
      resizedData = Uint8List.fromList(wresizedData);
    }

    return resizedData;
  }

  static List<String> tVille = [];
  static List<String> tCp = [];

  static Future<void> ReadServer_CpVilles(String aCp) async {
    tVille.clear();
    tCp.clear();

    String wParam = "http://api-adresse.data.gouv.fr/search/?q=" +
        aCp +
        "&type=municipality&limit=30";

    print("wParam " + wParam);

    http.Response wRet = await http.get(Uri.parse(wParam));

    var parsedJson = json.decode(wRet.body);

//    print("parsedJson ${parsedJson}");
    final features = parsedJson['features'];
    features.forEach((element) {
      var properties = element['properties'];
      var label = properties['label'];
      var postcode = properties['postcode'];
//      print("postcode $postcode label $label ");

      tVille.add(label);
      tCp.add(postcode);
    });
    return;
  }

  static double dp(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }
}
