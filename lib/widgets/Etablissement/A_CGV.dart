
import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:flutter/material.dart';

class A_CGV extends StatefulWidget {



  @override
  A_CGVState createState() => A_CGVState();
}

class A_CGVState extends State<A_CGV> {
  final tecCGV = TextEditingController();



  void initLib() async {
    tecCGV.text = DbTools.gEtablissement.CGV;
  }


  @override
  void initState() {
    initLib();

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var gColors;
    return AlertDialog(
      title: Container(
        width: 600,
        color: Colors.black,
        child: Text("CGV",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              onChanged: (text) {

              },
              controller: tecCGV,
              style: TextStyle(
                fontSize: 14,
              ),
              minLines: 40,
              maxLines: 40,

              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                contentPadding:
                new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                labelText: "CGV",
                hintText: "CGV",
              ),
            ),

          ],
        ),
      ),
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
          child: Text("Save",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          onPressed: () async {
            DbTools.gEtablissement.CGV = tecCGV.text;

            await DbTools.setEtablissement();

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }



}