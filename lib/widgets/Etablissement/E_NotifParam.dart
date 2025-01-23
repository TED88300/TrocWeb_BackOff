import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:flutter/material.dart';

class E_NotifParam extends StatefulWidget {
  @override
  E_NotifParamState createState() => E_NotifParamState();
}

class E_NotifParamState extends State<E_NotifParam> {
  final tecPushTitle = TextEditingController();
  final tecPushBody = TextEditingController();
  final tecMailSubject = TextEditingController();
  final tecMailMessage = TextEditingController();

  static bool isUpdate = false;

  int SelCol = -1;
  int SelID = -1;

  double textSize = 14.0;
  bool onCellTap = false;
  bool isLoadUser = false;

  void Reload() async {
    isLoadUser = false;

    isLoadUser = true;
    setState(() {});
  }

  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    super.initState();
    initLib();

    tecPushTitle.text = DbTools.gParamNotif.PushTitle;
    tecPushBody.text = DbTools.gParamNotif.PushBody;
    tecMailSubject.text = DbTools.gParamNotif.MailSubject;
    tecMailMessage.text = DbTools.gParamNotif.MailMessage;

    isUpdateAdr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: gColors.secondary,
        title: Container(
          color: gColors.secondary,
          child: Text("Trokeur débarras : ParamNotif",
              style: TextStyle(
                fontSize: 14,
                color: gColors.white,
              )),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 520,
            child: Row(children: [
              Flexible(
                flex: 5,
                child: buildAdr(context),
              ),
            ]),
          ),
          Container(
            height: 20,
          ),
        ],
      ),
    );
  }

  void isUpdateAdr() {
    isUpdate = tecPushTitle.text != DbTools.gParamNotif.PushTitle ||
        tecPushBody.text != DbTools.gParamNotif.PushBody ||
        tecMailSubject.text != DbTools.gParamNotif.MailSubject ||
        tecMailMessage.text != DbTools.gParamNotif.MailMessage;

    print("isUpdateAdr ${isUpdate}");
    setState(() {});
  }

  Widget buildAdr(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 0),
        child: Form(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10, bottom: 0),
                    child: Row(children: [
                      tecPushTitle.text.isEmpty ? Container() :
                      Flexible(
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tecPushTitle,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            labelText: "Push Title",
                          ),
                        ),
                      ),
                      Container(
                        width: 20,
                      ),


                      Flexible(
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tecMailSubject,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            labelText: "Mail Subject",
                          ),
                        ),
                      ),

                    ])),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10, bottom: 0),
                    child: Row(children: [
                      tecPushTitle.text.isEmpty ? Container() :
                      Flexible(
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tecPushBody,
                          minLines: 15,
                          maxLines: 15,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            labelText: "Push Body",
                          ),
                        ),
                      ),
                      Container(
                        width: 20,
                      ),

                      Flexible(
                        child: TextFormField(
                          onChanged: (text) {
                            isUpdateAdr();
                          },
                          controller: tecMailMessage,
                          minLines: 15,
                          maxLines: 15,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            labelText: "MailMessage",
                          ),
                        ),
                      ),


                    ])),



                Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10, bottom: 0),
                    child: Row(children: [

                      Text("#ID# = Id Affaire",style: TextStyle(fontSize: 14, color: Colors.deepPurpleAccent),),
                      Container(width: 30,),
                      Text("#Nom# = Nom Affaire",style: TextStyle(fontSize: 14, color: Colors.deepPurpleAccent),),
                      Container(width: 30,),



                      Text("#Date# = Date Action",style: TextStyle(fontSize: 14, color: Colors.deepPurpleAccent),),
                      Container(width: 30,),
                      Text("#Now# = Date du jour",style: TextStyle(fontSize: 14, color: Colors.deepPurpleAccent),),
                      Container(width: 30,),
                      Text("#Agence# = Agence",style: TextStyle(fontSize: 14, color: Colors.deepPurpleAccent),),
                      Container(width: 30,),
                      Text("#Signature# = Nom Agence",style: TextStyle(fontSize: 14, color: Colors.deepPurpleAccent),),
                      Container(width: 30,),




                      Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          DbTools.gParamNotif.PushTitle = tecPushTitle.text;
                          DbTools.gParamNotif.PushBody = tecPushBody.text;
                          DbTools.gParamNotif.MailSubject = tecMailSubject.text;

                          DbTools.gParamNotif.MailMessage = tecMailMessage.text;

                            await DbTools.setParamNotif();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.all(12.0),),
                        child: Text('Save',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ])),

        Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10, bottom: 0),
          child: Row(children: [
            Text("#Ville# = Ville Affaire",style: TextStyle(fontSize: 14, color: Colors.deepPurpleAccent),),
            Container(width: 30,),

            Text("#Nature# = Type d'Affaire",style: TextStyle(fontSize: 14, color: Colors.deepPurpleAccent),),
            Container(width: 30,),

            Text("#50/100# = MT COM",style: TextStyle(fontSize: 14, color: Colors.deepPurpleAccent),),
            Container(width: 30,),


            Text("#Avis# = Url Avis Google",style: TextStyle(fontSize: 14, color: Colors.deepPurpleAccent),),
            Container(width: 30,),

            Text("#Réduit# = Nom Réduit",style: TextStyle(fontSize: 14, color: Colors.deepPurpleAccent),),
            Container(width: 30,),


          ])),

              ]),
        ));
  }
}
