class Etablissement {
  int id = 0;
  String Libelle = "";

  String Nom_TK = "";
  String Interlocuteur = "";

  String keyid = "";
  String adresse1 = "";
  String adresse2 = "";
  String cp = "";
  String ville = "";
  String Pays = "";
  String RC = "";
  String Ass_RC = "";
  String RIB = "";
  String RGLT = "";
  String tel = "";
  String mail = "";

  int IsPT = 0;

  double TxTVA = 0;
  String No_TVA = "";
  double MtDechM3 = 0;

  int indexDevis = 0;
  int indexFacture = 0;

  String AppToken_1 = "";
  String AppToken_2 = "";
  String AppToken_3 = "";
  String AppToken_4 = "";
  String AppToken_5 = "";

  String UrlNecro_1 = "";
  String UrlNecro_2 = "";
  String UrlNecro_3 = "";

  String Url_Avis = "";

  String Brouillon = "";
  String Adresse = "";

  int IsNewCT = 0;
  String CGV = "";

  Etablissement(
      int id,
      String keyid,
      String Libelle,
      String Nom_TK,
      String Interlocuteur,
      String adresse1,
      String adresse2,
      String cp,
      String ville,
      String Pays,
      String RC,
          String Ass_RC,
      String RIB,
      String RGLT,
      String tel,
      String mail,
      int IsPT,
      double TxTVA,
      String No_TVA,
      double MtDechM3,
      int indexDevis,
      int indexFacture,
      String AppToken_1,
      String AppToken_2,
      String AppToken_3,
      String AppToken_4,
      String AppToken_5,

      String UrlNecro_1,
      String UrlNecro_2,
      String UrlNecro_3,
      String Url_Avis,
      String Brouillon,
      String Adresse,
      int IsNewCT,
      String CGV,

      ) {
    this.id = id;
    this.keyid = keyid;
    this.Libelle = Libelle;
    this.Nom_TK = Nom_TK;
    this.Interlocuteur = Interlocuteur;
    this.adresse1 = adresse1;
    this.adresse2 = adresse2;
    this.cp = cp;
    this.ville = ville;
    this.Pays = Pays;
    this.RC = RC;
    this.Ass_RC = Ass_RC;
    this.RIB = RIB;
    this.RGLT = RGLT;
    this.tel = tel;
    this.mail = mail;
    this.IsPT = IsPT;
    this.TxTVA = TxTVA;
    this.No_TVA = No_TVA;
    this.MtDechM3 = MtDechM3;

    this.indexDevis = indexDevis;
    this.indexFacture = indexFacture;

    this.AppToken_1 = AppToken_1;
    this.AppToken_2 = AppToken_2;
    this.AppToken_3 = AppToken_3;
    this.AppToken_4 = AppToken_4;
    this.AppToken_5 = AppToken_5;

    this.UrlNecro_1 = UrlNecro_1;
    this.UrlNecro_2 = UrlNecro_2;
    this.UrlNecro_3 = UrlNecro_3;

    this.Url_Avis = Url_Avis;

    this.Brouillon = Brouillon;
    this.Adresse = Adresse;
    this.IsNewCT = IsNewCT;

  this.CGV = CGV;
  }

  factory Etablissement.fromJson(Map<String, dynamic> json) {
    Etablissement wEtablissement = Etablissement(
      int.parse(json['id']),
      json['keyid'],
      json['Libelle'],
      json['Nom_TK'],
      json['Interlocuteur'],
      json['Adresse1'],
      json['Adresse2'],
      json['Cp'],
      json['Ville'],
      json['Pays'],
      json['RC'],
      json['Ass_RC'],
      json['RIB'],
      json['RGLT'],
      json['Tel'],
      json['Mail'],
      int.parse(json['IsPT']),
      double.parse(json['TxTVA']),
      json['No_TVA'],
      double.parse(json['MtDechM3']),
      int.parse(json['indexDevis']),
      int.parse(json['indexFacture']),
      json['AppToken_1'],
      json['AppToken_2'],
      json['AppToken_3'],
      json['AppToken_4'],
      json['AppToken_5'],

      json['UrlNecro_1'],
      json['UrlNecro_2'],
      json['UrlNecro_3'],

      json['Url_Avis'],

      json['Brouillon'],
      json['Adresse'],
        int.parse(json['IsNewCT']),
      json['CGV'],

    );

    if (wEtablissement.keyid == null) wEtablissement.keyid = "";
    if (wEtablissement.Libelle == null) wEtablissement.Libelle = "";
    if (wEtablissement.adresse1 == null) wEtablissement.adresse1 = "";
    if (wEtablissement.adresse2 == null) wEtablissement.adresse2 = "";

    if (wEtablissement.cp == null) wEtablissement.cp = "";
    if (wEtablissement.ville == null) wEtablissement.ville = "";
    if (wEtablissement.tel == null) wEtablissement.tel = "";
    if (wEtablissement.mail == null) wEtablissement.mail = "";

    if (wEtablissement.Url_Avis == null) wEtablissement.Url_Avis = "";


    return wEtablissement;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'keyid': keyid,
      'Libelle': Libelle,
      'Nom_TK': Nom_TK,
      'Interlocuteur': Interlocuteur,
      'adresse1': adresse1,
      'adresse2': adresse2,
      'cp': cp,
      'ville': ville,
      'tel': tel,
      'mail': mail,
      'IsPT': IsPT,
      'TxTVA': TxTVA,
      'No_TVA': No_TVA,
      'MtDechM3': MtDechM3,
      'indexDevis': indexDevis,
      'indexFacture': indexFacture,
      'AppToken_1': AppToken_1,
      'AppToken_2': AppToken_2,
      'AppToken_3': AppToken_3,
      'AppToken_4': AppToken_4,
      'AppToken_5': AppToken_5,

      'UrlNecro_1': UrlNecro_1,
      'UrlNecro_2': UrlNecro_2,
      'UrlNecro_3': UrlNecro_3,

      'Url_Avis': Url_Avis,
      'IsNewCT': IsNewCT,
    };
  }
}
