class pActions {
  int Actionid = 0;
  String Action = "";
  int PTF_Only = 0;
  int Agence = 0;

  pActions(
    int Actionid,
    String Action,
      int PTF_Only,
      int Agence,
      ) {
    this.Actionid = Actionid;
    this.Action = Action;
    this.PTF_Only = PTF_Only;
    this.Agence = Agence;
  }

  factory pActions.fromJson(Map<String, dynamic> json) {
    pActions wAction = pActions(
      int.parse(json['Actionid']),
      json['Action'],
      int.parse(json['PTF_Only']),
      int.parse(json['Agence']),
    );
    return wAction;
  }
}
