class Utilisateur {
  int id = 0;
  int etabid = 0;
  String User= "";
  String Motdepasse= "";
  String Role= "";
  int Actif = 0;

  Utilisateur(int id, int etabid, String User, String Motdepasse, String Role, int Actif) {
    this.id = id;
    this.etabid = etabid;
    this.User = User;
    this.Motdepasse = Motdepasse;
    this.Role = Role;
    this.Actif = Actif;
  }

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    Utilisateur wUtilisateur = Utilisateur(
      int.parse(json['id']),
      int.parse(json['etabid']),
      json['Utilisateur'],
      json['Motdepasse'],
      json['Role'],
      int.parse(json['Actif']),

    );

    if (wUtilisateur.User == null) wUtilisateur.User = "";
    if (wUtilisateur.Motdepasse == null) wUtilisateur.Motdepasse = "";



    return wUtilisateur;
  }
  
  
  
}
