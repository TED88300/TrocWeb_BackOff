class InventaireDetPhoto {
  int id = 0;
  int invdetid = 0;
  int photo = 0;


  InventaireDetPhoto(int id,
      int invdetid,
      int photo
      )
  {
    this.id             = id;
    this.invdetid       = invdetid;
    this.photo          = photo;
  }


  factory InventaireDetPhoto.fromJson(Map<String, dynamic> json) {
    InventaireDetPhoto wInventaireDet = InventaireDetPhoto(
      int.parse(json['id']),
      int.parse(json['invdetid']),
      int.parse(json['photo']),

    );
    return wInventaireDet;
  }

}