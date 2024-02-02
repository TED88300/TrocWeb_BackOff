
class ParamNotif {
  int id = 0;
  String Nom = "";
  String PushTitle = "";
  String PushBody = "";
  String MailSubject = "";
  String MailMessage = "";


  ParamNotif(
    int id,
      String Nom,
      String PushTitle,
      String PushBody,
      String MailSubject,
      String MailMessage,

      ) {
    this.id = id;
    this.Nom = Nom;
    this.PushTitle = PushTitle;
    this.PushBody = PushBody;
    this.MailSubject = MailSubject;
    this.MailMessage = MailMessage;

  }

  factory ParamNotif.fromJson(Map<String, dynamic> json) {
    ParamNotif wParamNotif = ParamNotif(
      int.parse(json['id']),
      json['Nom'],
      json['PushTitle'],
      json['PushBody'],
      json['MailSubject'],
      json['MailMessage'],
    );
    return wParamNotif;
  }
}
