import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:TrocWeb_BackOff/stub_file_picking/platform_file_picker.dart';
import 'package:TrocWeb_BackOff/stub_file_picking/web_file_picker.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';

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