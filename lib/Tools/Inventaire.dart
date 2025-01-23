class Inventaire {
  int id = 0;
  int etabid = 0;
  int etabidOrigine = 0;
  String nom = "";
  String adresse1 = "";
  String adresse2 = "";
  String cp = "";
  String ville = "";
  String tel = "";
  String mail = "";
  int Status = 0;
  String CarteIdentite = "";
  String DateCrt = "";
  String Origine = "";
  String Source = "";

  double Mt_Dem_HT = 0.0;
  double Tx = 0.0;
  double Mt_TKS_HT = 0.0;

  String fnom = "";
  String fadresse1 = "";
  String fadresse2 = "";
  String fcp = "";
  String fville = "";
  String ftel = "";
  String fmail = "";

  bool FinCh_Opt_1 = false;
  bool FinCh_Opt_2 = false;
  bool FinCh_Opt_3 = false;
  bool FinCh_Opt_4 = false;

  String DateInv = "";
  String DateDeb = "";

  double TxForce = 0.0;
  bool GenFdc = false;

  String NatureBien = "";
  int AffDem = 0;
  int AffAccept = 0;

  String NomReduit = "";
  String Remarque = "";

  String Date_Accept = "";
  String Date_Accept_Date = "";

  String Presc = "";
  String Date_Push = "";



  static InventaireInit() {
    return Inventaire(0, 0, 0 ,"" ,"" ,"" ,"" ,"" ,"" ,"" , 0 ,"" ,"" ,"" ,"" ,0,0,0, "" ,"" ,"" ,"" ,"" ,"" ,"" , false, false ,false,false,"" ,"" , 0, false ,"" , 0,0,"" ,"" ,"" ,"" ,"" , "" );
  }

  Inventaire(
    int id,
    int etabid,
    int etabidOrigine,
    String nom,
    String adresse1,
    String adresse2,
    String cp,
    String ville,
    String tel,
    String mail,
    int Status,
    String CarteIdentite,
    String DateCrt,
    String Origine,
    String Source,
    double Mt_Dem_HT,
    double Tx,
    double Mt_TKS_HT,
    String fnom,
    String fadresse1,
    String fadresse2,
    String fcp,
    String fville,
    String ftel,
    String fmail,
    bool FinCh_Opt_1,
    bool FinCh_Opt_2,
    bool FinCh_Opt_3,
    bool FinCh_Opt_4,
    String DateInv,
    String DateDeb,
    double TxForce,
    bool GenFdc,
    String NatureBien,
    int AffDem,
    int AffAccept,
    String NomReduit,
    String Remarque,
    String Date_Accept,
    String Date_Accept_Date,
    String Presc,
      String Date_Push,
  ) {
    this.id = id;
    this.etabid = etabid;
    this.etabidOrigine = etabidOrigine;
    this.nom = nom;
    this.adresse1 = adresse1;
    this.adresse2 = adresse2;
    this.cp = cp;
    this.ville = ville;
    this.tel = tel;
    this.mail = mail;
    this.Status = Status;
    this.CarteIdentite = CarteIdentite;
    this.DateCrt = DateCrt;
    this.Origine = Origine;
    this.Source = Source;
    this.Mt_Dem_HT = Mt_Dem_HT;
    this.Tx = Tx;
    this.Mt_TKS_HT = Mt_TKS_HT;
    this.fnom = fnom;
    this.fadresse1 = fadresse1;
    this.fadresse2 = fadresse2;
    this.fcp = fcp;
    this.fville = fville;
    this.ftel = ftel;
    this.fmail = fmail;
    this.FinCh_Opt_1 = FinCh_Opt_1;
    this.FinCh_Opt_2 = FinCh_Opt_2;
    this.FinCh_Opt_3 = FinCh_Opt_3;
    this.FinCh_Opt_4 = FinCh_Opt_4;
    this.DateInv = DateInv;
    this.DateDeb = DateDeb;

    this.TxForce = TxForce;
    this.GenFdc = GenFdc;
    this.NatureBien = NatureBien;
    this.AffDem = AffDem;
    this.AffAccept = AffAccept;
    this.NomReduit = NomReduit;
    this.Remarque = Remarque;
    this.Date_Accept = Date_Accept;

    this.Date_Accept_Date = Date_Accept_Date;
    this.Presc = Presc;
    this.Date_Push = Date_Push;
  }

  factory Inventaire.fromJson(Map<String, dynamic> json) {
    int etabid = int.parse(json['etabid']);
    int etabidOrigine = int.parse(json['etabidOrigine']);
    if (etabidOrigine == 0) etabidOrigine = etabid;

    int iFinCh_Opt_1 = int.parse(json['FinCh_Opt_1']);
    bool bFinCh_Opt_1 = (iFinCh_Opt_1 == 1);
    int iFinCh_Opt_2 = int.parse(json['FinCh_Opt_2']);
    bool bFinCh_Opt_2 = (iFinCh_Opt_2 == 1);
    int iFinCh_Opt_3 = int.parse(json['FinCh_Opt_3']);
    bool bFinCh_Opt_3 = (iFinCh_Opt_3 == 1);
    int iFinCh_Opt_4 = int.parse(json['FinCh_Opt_4']);
    bool bFinCh_Opt_4 = (iFinCh_Opt_4 == 1);

    int iGenFdc = int.parse(json['GenFdc']);
    bool bGenFdc = (iGenFdc == 1);

    var DateInv = json['DateInv'];
    if (DateInv == null) DateInv = "";

    var DateDeb = json['DateDeb'];
    if (DateDeb == null) DateDeb = "";

    var Date_Accept = json['Date_Accept'];
    if (Date_Accept == null) Date_Accept = "";

    var Date_Accept_Date = json['Date_Accept_Date'];
    if (Date_Accept_Date == null) Date_Accept_Date = "";

    var Presc = json['Presc'];
    if (Presc == null) Presc = "";

    var Date_Push = json['Date_Push'];
    if (Date_Push == null) Date_Push = "";

    Inventaire wInventaire = Inventaire(
      int.parse(json['id']),
      etabid,
      etabidOrigine,
      json['Nom'],
      json['Adresse1'],
      json['Adresse2'],
      json['Cp'],
      json['Ville'],
      json['Tel'],
      json['Mail'],
      int.parse(json['Status']),
      json['CarteIdentite'],
      json['DateCrt'],
      json['Origine'],
      json['Source'],
      double.parse(json['Mt_Dem_HT']),
      double.parse(json['Tx']),
      double.parse(json['Mt_TKS_HT']),
      json['fNom'],
      json['fAdresse1'],
      json['fAdresse2'],
      json['fCp'],
      json['fVille'],
      json['fTel'],
      json['fMail'],
      bFinCh_Opt_1,
      bFinCh_Opt_2,
      bFinCh_Opt_3,
      bFinCh_Opt_4,
      DateInv,
      DateDeb,
      double.parse(json['TxForce']),
      bGenFdc,
      json['NatureBien'],
      int.parse(json['AffDem']),
      int.parse(json['AffAccept']),
      json['NomReduit'],
      json['Remarque'],
      Date_Accept,
      Date_Accept_Date,
      Presc,
        Date_Push

    );


    return wInventaire;
  }

  void Purge() {
    this.nom = this.nom.replaceAll("'", "\'");
    this.adresse1 = this.adresse1.replaceAll("'", "\'");
    this.adresse2 = this.adresse2.replaceAll("'", "\'");
    this.cp = this.cp.replaceAll("'", "\'");
    this.ville = this.ville.replaceAll("'", "\'");
    this.tel = this.tel.replaceAll("'", "\'");
    this.mail = this.mail.replaceAll("'", "\'");
    this.CarteIdentite = this.CarteIdentite.replaceAll("'", "\'");

    this.fnom = this.fnom.replaceAll("'", "\'");
    this.fadresse1 = this.fadresse1.replaceAll("'", "\'");
    this.fadresse2 = this.fadresse2.replaceAll("'", "\'");
    this.fcp = this.fcp.replaceAll("'", "\'");
    this.fville = this.fville.replaceAll("'", "\'");
    this.ftel = this.ftel.replaceAll("'", "\'");
    this.fmail = this.fmail.replaceAll("'", "\'");
  }
}
