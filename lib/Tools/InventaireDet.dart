
 class InventaireDet {

   int id = 0;
   int invid = 0;
   String piece = "";
   String libelle = "";
   String CDE = "";

   double Px_Vente = 0.0;
   double Px_Achat = 0.0;
   double Temps = 0.0;
   double M3 = 0.0;
   String Tri = "";
   String Demontage = "";
   String Manip_Delicate = "";
   String Autre = "";


   InventaireDet(
       int id,
       int invid,
       String piece,
       String libelle,
       String CDE,
       double Px_Vente,
       double Px_Achat,
       double Temps,
       double M3,
       String Tri,
       String Demontage,
       String Manip_Delicate,
       String Autre) {
     this.id = id;
     this.invid = invid;
     this.piece = piece;
     this.libelle = libelle;
     this.CDE = CDE;
     this.Px_Vente = Px_Vente;
     this.Px_Achat = Px_Achat;
     this.Temps = Temps;
     this.M3 = M3;
     this.Tri = Tri;
     this.Demontage = Demontage;
     this.Manip_Delicate = Manip_Delicate;
     this.Autre = Autre;
   }

   factory InventaireDet.fromJson(Map<String, dynamic> json) {
     InventaireDet wInventaireDet = InventaireDet(
       int.parse(json['id']),
       int.parse(json['invid']),
       json['Piece'],
       json['Libelle'],
       json['CDE'],
       double.parse(json['Px_Vente']),
       double.parse(json['Px_Achat']),
       double.parse(json['Temps']),
       double.parse(json['M3']),
       json['Tri'],
       json['Demontage'],
       json['Manip_Delicate'],
       json['Autre'],
     );


     return wInventaireDet;
   }

   void Purge()
   {
     this.piece = this.piece.replaceAll("'", "\'");
     this.libelle = this.libelle.replaceAll("'", "\'");
     this.CDE = this.CDE.replaceAll("'", "\'");
     this.Tri = this.Tri.replaceAll("'", "\'");
     this.Demontage = this.Demontage.replaceAll("'", "\'");
     this.Manip_Delicate = this.Manip_Delicate.replaceAll("'", "\'");
     this.Autre = this.Autre.replaceAll("'", "\'");
   }



 }