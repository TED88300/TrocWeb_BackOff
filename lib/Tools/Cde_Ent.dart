class Cde_Ent {
  int Cde_Entid = 0;
  int Cde_Ent_Invid = 0;

  String Cde_Ent_DF = "";

  bool Cde_Ent_EDT = false;


  double Cde_Ent_Tx_Tks = 0;
  String Cde_Ent_Date = "";
  String Cde_Ent_Remarque = "";
  double Cde_Ent_Tot_HT = 0;
  double Cde_Ent_Tot_TVA = 0;
  double Cde_Ent_Tot_TTC = 0;
  double Cde_Ent_Tot_CLIENT = 0;

  bool Cde_Ent_Fact = false;
  bool Cde_Ent_Annul = false;

  double Cde_Ent_Rep_Net = 0;
  double Cde_Ent_Rem_Net = 0;
  double Cde_Ent_Px_1 = 0;
  double Cde_Ent_Qte_1 = 0;
  double Cde_Ent_Mt_1 = 0;
  double Cde_Ent_Net_1 = 0;
  double Cde_Ent_Px_2 = 0;
  double Cde_Ent_Qte_2 = 0;
  double Cde_Ent_Mt_2 = 0;
  double Cde_Ent_Net_2 = 0;
  double Cde_Ent_Px_3 = 0;
  double Cde_Ent_Qte_3 = 0;
  double Cde_Ent_Mt_3 = 0;
  double Cde_Ent_Net_3 = 0;
  double Cde_Ent_Px_4 = 0;
  double Cde_Ent_Qte_4 = 0;
  double Cde_Ent_Mt_4 = 0;
  double Cde_Ent_Net_4 = 0;
  double Cde_Ent_Px_5 = 0;
  double Cde_Ent_Qte_5 = 0;
  double Cde_Ent_Mt_5 = 0;
  double Cde_Ent_Net_5 = 0;

  String Cde_Ent_Lib_1 = "";
  String Cde_Ent_Lib_2 = "";
  String Cde_Ent_Lib_3 = "";
  String Cde_Ent_Lib_4 = "";
  String Cde_Ent_Lib_5 = "";

  String Cde_Ent_Rep_Lib = "";
  String Cde_Ent_Rem_Lib = "";

  int Cde_Ent_indexDevis = 0;
  int Cde_Ent_indexFacture = 0;

  Cde_Ent(
    int Cde_Entid,
    int Cde_Ent_Invid,
    String Cde_Ent_DF,
      bool Cde_Ent_EDT,
    double Cde_Ent_Tx_Tks,
    String Cde_Ent_Date,
    String Cde_Ent_Remarque,
    double Cde_Ent_Tot_HT,
    double Cde_Ent_Tot_TVA,
    double Cde_Ent_Tot_TTC,
    Cde_Ent_Tot_CLIENT,
    bool Cde_Ent_Fact,
    bool Cde_Ent_Annul,
    Cde_Ent_Rep_Net,
      Cde_Ent_Rem_Net,
    Cde_Ent_Px_1,
    Cde_Ent_Qte_1,
    Cde_Ent_Mt_1,
    Cde_Ent_Net_1,
    Cde_Ent_Px_2,
    Cde_Ent_Qte_2,
    Cde_Ent_Mt_2,
    Cde_Ent_Net_2,
    Cde_Ent_Px_3,
    Cde_Ent_Qte_3,
    Cde_Ent_Mt_3,
    Cde_Ent_Net_3,
    Cde_Ent_Px_4,
    Cde_Ent_Qte_4,
    Cde_Ent_Mt_4,
    Cde_Ent_Net_4,
    Cde_Ent_Px_5,
    Cde_Ent_Qte_5,
    Cde_Ent_Mt_5,
    Cde_Ent_Net_5,
    Cde_Ent_Lib_1,
    Cde_Ent_Lib_2,
    Cde_Ent_Lib_3,
    Cde_Ent_Lib_4,
    Cde_Ent_Lib_5,
    Cde_Ent_Rep_Lib,
      Cde_Ent_Rem_Lib,
    Cde_Ent_indexDevis,
    Cde_Ent_indexFacture,
  ) {
    this.Cde_Entid = Cde_Entid;
    this.Cde_Ent_Invid = Cde_Ent_Invid;
    this.Cde_Ent_DF = Cde_Ent_DF;
    this.Cde_Ent_EDT = Cde_Ent_EDT;



    this.Cde_Ent_Tx_Tks = Cde_Ent_Tx_Tks;
    this.Cde_Ent_Date = Cde_Ent_Date;
    this.Cde_Ent_Remarque = Cde_Ent_Remarque;
    this.Cde_Ent_Tot_HT = Cde_Ent_Tot_HT;
    this.Cde_Ent_Tot_TVA = Cde_Ent_Tot_TVA;
    this.Cde_Ent_Tot_TTC = Cde_Ent_Tot_TTC;
    this.Cde_Ent_Tot_CLIENT = Cde_Ent_Tot_CLIENT;
    this.Cde_Ent_Fact = Cde_Ent_Fact;
    this.Cde_Ent_Annul = Cde_Ent_Annul;

    this.Cde_Ent_Rep_Net = Cde_Ent_Rep_Net;
    this.Cde_Ent_Rem_Net = Cde_Ent_Rem_Net;

    this.Cde_Ent_Px_1 = Cde_Ent_Px_1;
    this.Cde_Ent_Qte_1 = Cde_Ent_Qte_1;
    this.Cde_Ent_Mt_1 = Cde_Ent_Mt_1;
    this.Cde_Ent_Net_1 = Cde_Ent_Net_1;
    this.Cde_Ent_Px_2 = Cde_Ent_Px_2;
    this.Cde_Ent_Qte_2 = Cde_Ent_Qte_2;
    this.Cde_Ent_Mt_2 = Cde_Ent_Mt_2;
    this.Cde_Ent_Net_2 = Cde_Ent_Net_2;
    this.Cde_Ent_Px_3 = Cde_Ent_Px_3;
    this.Cde_Ent_Qte_3 = Cde_Ent_Qte_3;
    this.Cde_Ent_Mt_3 = Cde_Ent_Mt_3;
    this.Cde_Ent_Net_3 = Cde_Ent_Net_3;
    this.Cde_Ent_Px_4 = Cde_Ent_Px_4;
    this.Cde_Ent_Qte_4 = Cde_Ent_Qte_4;
    this.Cde_Ent_Mt_4 = Cde_Ent_Mt_4;
    this.Cde_Ent_Net_4 = Cde_Ent_Net_4;
    this.Cde_Ent_Px_5 = Cde_Ent_Px_5;
    this.Cde_Ent_Qte_5 = Cde_Ent_Qte_5;
    this.Cde_Ent_Mt_5 = Cde_Ent_Mt_5;
    this.Cde_Ent_Net_5 = Cde_Ent_Net_5;

    this.Cde_Ent_Lib_1 = Cde_Ent_Lib_1;
    this.Cde_Ent_Lib_2 = Cde_Ent_Lib_2;
    this.Cde_Ent_Lib_3 = Cde_Ent_Lib_3;
    this.Cde_Ent_Lib_4 = Cde_Ent_Lib_4;
    this.Cde_Ent_Lib_5 = Cde_Ent_Lib_5;

    this.Cde_Ent_Rep_Lib = Cde_Ent_Rep_Lib;
    this.Cde_Ent_Rem_Lib = Cde_Ent_Rem_Lib;
    this.Cde_Ent_indexDevis = Cde_Ent_indexDevis;
    this.Cde_Ent_indexFacture = Cde_Ent_indexFacture;
  }

  factory Cde_Ent.fromJson(Map<String, dynamic> json) {
    int iCde_Ent_Fact = int.parse(json['Cde_Ent_Fact']);
    bool bCde_Ent_Fact = (iCde_Ent_Fact == 1);

    int iCde_Ent_Annul = int.parse(json['Cde_Ent_Annul']);
    bool bCde_Ent_Annul = (iCde_Ent_Annul == 1);


    int iCde_Ent_EDT = int.parse(json['Cde_Ent_EDT']);
    bool bCde_Ent_EDT = (iCde_Ent_EDT == 1);



    Cde_Ent wCde_Ent = Cde_Ent(
      int.parse(json['Cde_Entid']),
      int.parse(json['Cde_Ent_Invid']),
        json['Cde_Ent_DF'],

        bCde_Ent_EDT,


      double.parse(json['Cde_Ent_Tx_Tks']),
      json['Cde_Ent_Date'],
      json['Cde_Ent_Remarque'],
      double.parse(json['Cde_Ent_Tot_HT']),
      double.parse(json['Cde_Ent_Tot_TVA']),
      double.parse(json['Cde_Ent_Tot_TTC']),
      double.parse(json['Cde_Ent_Tot_CLIENT']),
      bCde_Ent_Fact,
      bCde_Ent_Annul,
      double.parse(json['Cde_Ent_Rep_Net']),
      double.parse(json['Cde_Ent_Rem_Net']),
      double.parse(json['Cde_Ent_Px_1']),
      double.parse(json['Cde_Ent_Qte_1']),
      double.parse(json['Cde_Ent_Mt_1']),
      double.parse(json['Cde_Ent_Net_1']),
      double.parse(json['Cde_Ent_Px_2']),
      double.parse(json['Cde_Ent_Qte_2']),
      double.parse(json['Cde_Ent_Mt_2']),
      double.parse(json['Cde_Ent_Net_2']),
      double.parse(json['Cde_Ent_Px_3']),
      double.parse(json['Cde_Ent_Qte_3']),
      double.parse(json['Cde_Ent_Mt_3']),
      double.parse(json['Cde_Ent_Net_3']),
      double.parse(json['Cde_Ent_Px_4']),
      double.parse(json['Cde_Ent_Qte_4']),
      double.parse(json['Cde_Ent_Mt_4']),
      double.parse(json['Cde_Ent_Net_4']),
      double.parse(json['Cde_Ent_Px_5']),
      double.parse(json['Cde_Ent_Qte_5']),
      double.parse(json['Cde_Ent_Mt_5']),
      double.parse(json['Cde_Ent_Net_5']),
      json['Cde_Ent_Lib_1'],
      json['Cde_Ent_Lib_2'],
      json['Cde_Ent_Lib_3'],
      json['Cde_Ent_Lib_4'],
      json['Cde_Ent_Lib_5'],
      json['Cde_Ent_Rep_Lib'],
      json['Cde_Ent_Rem_Lib'],
      int.parse(json['Cde_Ent_indexDevis']),
      int.parse(json['Cde_Ent_indexFacture']),
    );

    return wCde_Ent;
  }
}
