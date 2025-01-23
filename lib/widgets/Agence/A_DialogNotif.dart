import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/Etablissement.dart';
import 'package:TrocWeb_BackOff/Tools/ParamNotif.dart';
import 'package:TrocWeb_BackOff/Tools/Push.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';


class DialogNotif extends StatefulWidget {
  final DateTime DateTime_Action;
  final bool Action;
  final String Notif;


  DialogNotif(this.DateTime_Action, this.Action, this.Notif);


  @override
  DialogNotifState createState() => DialogNotifState();
}



class DialogNotifState extends State<DialogNotif> {
  String aNotif = "";
  String aDate = "";
  late ParamNotif wParamNotif;

  final tecTilte = TextEditingController();
  final tecBody = TextEditingController();

  final tecSubject = TextEditingController();
  final tecMessage = TextEditingController();

  String sFrom = "";
  String sMail = "";
  late Etablissement wEtablissementFrom ;
  String sEtablissementFrom = "";
  late Etablissement wEtablissementTo ;
  String sEtablissementTo = "";



  void initLib() async {}

  @override
  void initState() {

    if (DbTools.gUtilisateurLogin.Role.contains("Plateforme"))
      {
        wEtablissementFrom = DbTools.getEtablissementsbyID(DbTools.gInventaire.etabidOrigine);
        sEtablissementFrom = "TKS+";
        sFrom = wEtablissementFrom.mail;
        wEtablissementTo =  DbTools.getEtablissementsbyID(DbTools.gInventaire.etabid) ;
        sEtablissementTo =  wEtablissementTo.Libelle ;
        sMail = wEtablissementTo.mail;
      }
else
  {
    wEtablissementFrom = DbTools.getEtablissementsbyID(DbTools.gInventaire.etabid);
    sEtablissementFrom = wEtablissementFrom.Libelle;
    sFrom = wEtablissementFrom.mail;
    wEtablissementTo =  DbTools.getEtablissementsbyID(DbTools.gInventaire.etabidOrigine) ;
    sEtablissementTo =  wEtablissementTo.Libelle ;
    sMail = wEtablissementTo.mail;

  }



    if (!widget.Action) {
      aNotif = widget.Notif;

      print ("ETABLISSEMENT >>> ${DbTools.gInventaire.etabid} ${DbTools.gInventaire.etabidOrigine} ${aNotif}");


      if (aNotif == "MsgClient")
        sMail =  DbTools.gInventaire.mail;
    }
    else
    {
      sMail = DbTools.gInventaire.mail;

    if (DbTools.gInventaireAction.Actionid == 50)
      aNotif = "Rdv_Devis";
    else if (DbTools.gInventaireAction.Actionid == 120)
      aNotif = "Rdv_Debarras";
    else if (DbTools.gInventaireAction.Actionid == 130)
      aNotif = "avis";
  }

    aDate = DateFormat('dd-MM-yyyy à HH:mm').format(widget.DateTime_Action);
    wParamNotif = ParamNotif(0, "", "", "", "", "");
    DbTools.ListParamNotif.forEach((element) {
      if (element.Nom == aNotif) {
        wParamNotif = element;
      }
    });


    tecSubject.text = DbTools.ReplaceWord(wParamNotif.MailSubject, aDate, sEtablissementTo);
    tecMessage.text = DbTools.ReplaceWord(wParamNotif.MailMessage, aDate, sEtablissementTo);

    tecTilte.text = DbTools.ReplaceWord(wParamNotif.PushTitle, aDate, sEtablissementTo);
    tecBody.text = DbTools.ReplaceWord(wParamNotif.PushBody, aDate, sEtablissementTo);

    initLib();

    super.initState();
  }

  @override
  Widget contentPush() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child:
        Text("PUSH vers ${DbTools.gUtilisateurLogin.Role.contains("Plateforme") ?  wEtablissementTo.Libelle : "TKS+"}",
            style: TextStyle(
                fontSize: 22,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold
            )),
        ),

        Center(child:
        Text("${ wEtablissementTo.Libelle}",
            style: TextStyle(
                fontSize: 10,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold
            )),
        ),

        Text("Titre : ",
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        TextFormField(
          onChanged: (text) {},
          controller: tecTilte,
          maxLines: 1,
        ),

        Text("Corps : ",
            style: TextStyle(
                fontWeight: FontWeight.bold
            )),
        TextFormField(
          onChanged: (text) {},
          controller: tecBody,
          maxLines: 10,
        ),
      ],
    );
  }

  @override
  Widget contentMail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Center(child:
        Text("Mail",
            style: TextStyle(
              fontSize: 22,
              decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold
            )),
            ),
        Center(child:
            Text("${sFrom} to ${sMail}",
            style: TextStyle(
            fontSize: 10,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold
            )),
            ),


            Text("Sujet : ",
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        TextFormField(
          onChanged: (text) {},
          controller: tecSubject,
          maxLines: 1,
        ),

        Text("Message : ",
            style: TextStyle(
                fontWeight: FontWeight.bold
            )),
        TextFormField(
          onChanged: (text) {},
          controller: tecMessage,
          maxLines: 10,
        ),


      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    var gColors;
    return AlertDialog(
      title: Container(
        color: Colors.black,
        child: Text("Notification : Push - Mail",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      content: SingleChildScrollView(child:
    Container(

        width: MediaQuery.of(context).size.width / 2 + 100,
        child: Column(
          children: [
            wParamNotif.PushTitle.length == 0 ? Container() : contentPush(),
            wParamNotif.MailSubject.length == 0 ? Container() : contentMail(),
          ],
        ),
      ),),
      actions: [
        ElevatedButton(
          child: Text("Annuler",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text("Continuer",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          onPressed: () async{

            if (tecTilte.text.length > 0)
              {
//                print("SrvSendPushNotifications");
//                await DbTools.SrvSendPushNotifications(tecTilte.text,tecBody.text, aDate);
              print("SendPushNotifications");
              await Push.SendPushNotifications(tecTilte.text,tecBody.text, aDate);
              }

            if (tecSubject.text.length > 0)
              {
                print(">>>>> SrvSendMail");
                await DbTools.SrvSendMail(tecSubject.text,tecMessage.text, aDate, sFrom, sMail);
              }

            if (aNotif.contains("Affectation"))
              {
                print(">>>>> Date_Push");
                DbTools.gInventaire.Date_Push = "Push envoyé le ${DateFormat('dd-MM-yyyy à HH:mm').format(DateTime.now())} ";
                await DbTools.setInventaire();


              }
            
            await _showMyDialog();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification : Push - Mail'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Push Envoyé'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
