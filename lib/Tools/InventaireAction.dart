class InventaireAction {
  int id = 0;
  int invid = 0;
  int Actionid = 0;

  String Action = "";
  int OK = 0;
  String Date = "";
  String Remarque = "";




  InventaireAction(
    int id,
    int invid,
    int Actionid,
    String Action,
      int OK,
    String Date,
    String Remarque,
  ) {
    this.id = id;
    this.invid = invid;
    this.Actionid = Actionid;
    this.Action = Action;
    this.OK = OK;
    this.Date = Date;
    this.Remarque = Remarque;
  }

  factory InventaireAction.fromJson(Map<String, dynamic> json) {


    String wDate = "";
    if (json['Date'] != null) wDate = json['Date'];

    InventaireAction wInventaireAction = InventaireAction(
      int.parse(json['id']),
      int.parse(json['invid']),
      int.parse(json['Actionid']),
      json['Action'],
      int.parse(json['OK']),
      wDate,
      json['Remarque'],
    );
    return wInventaireAction;
  }
}
