import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/Etablissement.dart';
import 'package:TrocWeb_BackOff/Tools/ParamNotif.dart';
import 'package:TrocWeb_BackOff/Tools/Upload.dart';
import 'package:TrocWeb_BackOff/stub_file_picking/platform_file_picker.dart';
import 'package:TrocWeb_BackOff/stub_file_picking/web_file_picker.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart';

import 'package:intl/intl.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';

class A_Dialog_PT_50_100 extends StatefulWidget {
  @override
  A_Dialog_PT_50_100State createState() => A_Dialog_PT_50_100State();
}

class A_Dialog_PT_50_100State extends State<A_Dialog_PT_50_100> {
  final tecNomReduit = TextEditingController();
  final tecRemarque = TextEditingController();
  static bool isUpdate = false;

  bool isVisiblePhoto = false;
  bool isVisiblePhoto0 = false;

  final CarouselController cC = CarouselController();
  late List<Widget> imgSlider;
  List<Uint8List> picList = [];
  int pageIndex = 0;

  List<int> imgidList = [];

  int AffDem = 0;


  void initLib() async {
    tecNomReduit.text = DbTools.gInventaire.NomReduit;
    tecRemarque.text = DbTools.gInventaire.Remarque;

    AffDem = DbTools.gInventaire.AffDem;

    print(">>>>> AffDem  >>>>>>>>>>>>>>>~~~~~~~~~~~~~~~~~~~~ ${AffDem} ${DbTools.gInventaire.AffDem}");


    LoadImg();
  }

  void setStateCall(int count) {
    setState(() {});
  }

  Future LoadImg() async {
    imgidList.clear();
    picList.clear();

    Random random = new Random();
    int V = random.nextInt(10444) + 1;

    picList.clear();
    for (int i = 1; i < 100; ++i) {
      String wTmp =
          "${DbTools.SrvImg}Qualif_${DbTools.gInventaire.id}_$i.jpg" + "?v=$V";

      //    print(">>>>>>>>>>>> wTmp ${wTmp}");

      Uint8List pic = await DbTools.networkImageToByte(wTmp);
      if (pic.length > 1) {
        print(">>>>>>>>>>>> OK ${pic.length}");
        picList.add(pic);
        imgidList.add(i);
      } else {
//        print(">>>>>>>>>>>> PB");
//        break;
      }
    }

    isVisiblePhoto = true;
    if (picList.length > 0) {
      pageIndex = 0;
      isVisiblePhoto0 = true;
    }
    print("imgidList.length ${imgidList.length}");
    setState(() {});
  }

  @override
  void initState() {
    initLib();

    super.initState();
  }

  void isUpdateAdr() {
    isUpdate = tecNomReduit.text != DbTools.gInventaire.NomReduit ||
        tecRemarque.text != DbTools.gInventaire.Remarque;
    ;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var gColors;
    return AlertDialog(
      title: Container(
        width: 600,
        color: Colors.black,
        child: Text("Qualification 50/100",
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
                isUpdateAdr();
              },
              controller: tecNomReduit,
              style: TextStyle(
                fontSize: 14,
              ),
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                labelText: "Nom réduit",
                hintText: "Entrez le nom réduit du client",
              ),
            ),
            Container(
              height: 10,
            ),
            TextFormField(
              onChanged: (text) {
                isUpdateAdr();
              },
              controller: tecRemarque,
              minLines: 10,
              maxLines: 50,
              style: TextStyle(
                fontSize: 14,
              ),
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                labelText: "Remarque",
              ),
            ),
            Container(
              height: 10,
            ),
            buildPhotoFdC(),
          ],
        ),
      ),
      actions: [

        ToggleSwitch(
            minWidth: 90.0,
            activeBgColors: [

              [Colors.orangeAccent],
              [Colors.green],
              [Colors.greenAccent],
            ],
            customWidths: [

              90,
              110,
              110,
            ],
            initialLabelIndex: AffDem,
            customTextStyles : [TextStyle(color: Colors.white,),],
            totalSwitches: 3,
            labels: [

              'Comm. 1€',
              'Comm. 50€',
              'Comm. 100€'
            ],
            onToggle: (index) {
              print('switched to A : $index');
              AffDem = index!;
              print('switched to B : $index');
              isUpdateAdr();
            }),


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

            tecNomReduit.text = tecNomReduit.text.replaceAll("'", "‘");
            tecRemarque.text = tecRemarque.text.replaceAll("'", "‘");

            DbTools.gInventaire.NomReduit = tecNomReduit.text;
            DbTools.gInventaire.Remarque = tecRemarque.text;
            DbTools.gInventaire.AffDem = AffDem;


            await DbTools.setInventaire();
            await DbTools.RemQualInventaireActions(tecRemarque.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget buildPhotoFdC() {
    return !isVisiblePhoto
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                SpinKitThreeBounce(
                  color: gColors.secondary,
                  size: 100.0,
                ),
                Container(
                  height: 10,
                ),
                Text(
                  "Lecture des Photos ...",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ])
        : Column(
            children: [
              !isVisiblePhoto0
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            cC.animateToPage(0);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                          ),
                          child: Text('<<',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            cC.previousPage();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                          ),
                          child: Text('<',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          width: 10,
                        ),
                        Text("${pageIndex + 1}/${picList.length}",
                            style: TextStyle(
                              fontSize: 14,
                            )),
                        Container(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            cC.nextPage();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                          ),
                          child: Text('>',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            cC.animateToPage(picList.length - 1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                          ),
                          child: Text('>>',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
              Container(
                width: 10,
              ),
              isVisiblePhoto0 ? BlockCarousel() : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      LoadImg();
                    },
                    child: Icon(Icons.refresh),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.deepPurpleAccent), // <-- Button color
                      overlayColor:
                          MaterialStateProperty.resolveWith<Color?>((states) {
                        if (states.contains(MaterialState.pressed))
                          return gColors.primary; // <-- Splash color
                      }),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await getImage();
                    },
                    child: Icon(Icons.add),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.green), // <-- Button color
                      overlayColor:
                          MaterialStateProperty.resolveWith<Color?>((states) {
                        if (states.contains(MaterialState.pressed))
                          return gColors.primary; // <-- Splash color
                      }),
                    ),
                  ),
                  !isVisiblePhoto0
                      ? Container()
                      : ElevatedButton(
                          onPressed: () async {
                            print(
                                "delete ${pageIndex} ${imgidList[pageIndex]}");
                            await DbTools.removephotoQualif_API_Post(
                                imgidList[pageIndex]);
                            await LoadImg();

                            setState(() {});
                          },
                          child: Icon(Icons.delete),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(CircleBorder()),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(20)),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.red), // <-- Button color
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                              if (states.contains(MaterialState.pressed))
                                return gColors.primary; // <-- Splash color
                            }),
                          ),
                        ),
                ],
              ),
            ],
          );
  }

  @override
  Widget BlockCarousel() {
    imgSlider = picList
        .map(
          (pic) => Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    /*AspectRatio(
                          aspectRatio: 1920 / 1080,
                          child:
                        */
                    pic == null
                        ? Container()
                        : Image.memory(
                            pic,
                            fit: BoxFit.fitWidth,
                          ),
                    //),
                  ],
                )),
          ),
        )
        .toList();

    return Container(
        width: 600,
        height: 300,
        child: CarouselSlider(
          carouselController: cC,
          options: CarouselOptions(
              autoPlay: false,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                pageIndex = index;
                print("onPageChanged");
                setState(() {});
              }),
          items: imgSlider,
        ));
  }

  //**************************************************

  Future getImage() async {
    int wIndex = picList.length + 1;
    print("pageIndex $wIndex");

    await _startFilePicker(wIndex);
  }

  _startFilePicker(int aIndex) async {
    print("UploadFilePicker > Qualif_${DbTools.gInventaire.id}_" +
        aIndex.toString() +
        ".jpg");
    await UploadFilePicker("Qualif_${DbTools.gInventaire.id}_" + aIndex.toString() + ".jpg", 99, aIndex);
    print("UploadFilePicker <");
    print("UploadFilePicker <<");
  }

  Future UploadFilePicker(String imagepath, int Consumer, int aIndex) async {
    print("UploadFilePicker");

    String wImgPath = DbTools.SrvImg + imagepath;
    PaintingBinding.instance.imageCache.clear();
    imageCache.clear();
    imageCache.clearLiveImages();
    await DefaultCacheManager().emptyCache(); //clears all data in cache.
    await DefaultCacheManager().removeFile(wImgPath);

    PlatformFilePicker().startWebFilePicker((files) async {
      DbTools.setSrvToken();
      print("Deb");
      print("imagepath $imagepath");
      FlutterWebFile file = files[0];
      print("file " + file.file.name);
      var stream = file.fileBytes;

      String wPath = DbTools.SrvUrl;
      var uri = Uri.parse(wPath.toString());
      var request = new http.MultipartRequest("POST", uri);
      request.fields.addAll({
        'tic12z': DbTools.SrvToken,
        'zasq': 'uploadphotosize',
        'imagepath': imagepath,
      });

      var multipartFile = new http.MultipartFile.fromBytes('uploadfile', stream,
          filename: basename("xxx.jpg"));
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print("value " + value);
        print("Fin");
        LoadImg();
      });
    });
  }
}
