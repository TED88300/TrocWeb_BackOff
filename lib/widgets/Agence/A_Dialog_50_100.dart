import 'dart:convert';
import 'dart:math';

import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:TrocWeb_BackOff/stub_file_picking/platform_file_picker.dart';
import 'package:TrocWeb_BackOff/stub_file_picking/web_file_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class A_Dialog_50_100 extends StatefulWidget {
  final bool Visue;
  A_Dialog_50_100(this.Visue);

  @override
  A_Dialog_50_100State createState() => A_Dialog_50_100State();
}

class A_Dialog_50_100State extends State<A_Dialog_50_100> {
  bool isVisiblePhoto = false;
  bool isVisiblePhoto0 = false;

  final CarouselController cC = CarouselController();
  late List<Widget> imgSlider;
  List<Uint8List> picList = [];
  int pageIndex = 0;

  List<int> imgidList = [];

  String Titre = "";
  String Mt = "";

  String Txt = "";

  int AffAcept = 2;

  void initLib() async {
    LoadImg();
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
    Titre = "";

    if (DbTools.gInventaire.AffDem == 0) {
      AffAcept = 2;
      Titre = "Affaire à 1€";
      Mt = "1€";
    }
    if (DbTools.gInventaire.AffDem == 1) {
      AffAcept = 3;
      Titre = "Affaire à 50€";
      Mt = "50€";
    } else if (DbTools.gInventaire.AffDem == 2) {
      AffAcept = 4;
      Titre = "Affaire à 100€";
      Mt = "100€";
    }
    Txt =
        "Pour visualiser ce contact vous devez cliquer sur Accepter. Si vous acceptez cette adresse elle vous sera facturée ${Mt}\nSinon cliquez sur Refuser.";

    initLib();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gColors;
    return AlertDialog(
      title: Container(
        width: 900,
        color: Color(0xFF8dc63f),
        child: Text("${Titre}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      content:


      SingleChildScrollView(

          child:

        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nom : ${DbTools.gInventaire.NomReduit}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            Container(margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0), height: 1, color: Color(0xFF8dc63f),),
            Text("Ville : ${DbTools.gInventaire.ville}",
              style: TextStyle(
                fontSize: 18,
                  fontWeight: FontWeight.bold

              ),
            ),
            Container(margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0), height: 1, color: Color(0xFF8dc63f),),
            Text("Nature : ${DbTools.gInventaire.NatureBien}",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold

              ),
            ),

            Container(margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0), height: 1, color: Color(0xFF8dc63f),),

            Text("${DbTools.gInventaire.Remarque}",
              style: TextStyle(
                fontSize: 18,
              ),
            ),


            Container(margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0), height: 1, color: Color(0xFF8dc63f),),


            buildPhotoFdC(),

            Container(margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0), height: 1, color: Color(0xFF8dc63f),),

            Container(
              height: 10,
            ),
            Text("${Txt}",
              style: TextStyle(
                fontSize: 18,
                  fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,

            ),


            ],
          ),
        ),

      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        ElevatedButton(
          child: Text("Annuler",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Container(width: 100,),
        widget.Visue
            ? Container()
            : ElevatedButton(
                child: Text("Refuser",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  DbTools.gInventaire.AffAccept = 1;
                  DbTools.gInventaire.Date_Accept =
                      "Affaire refusée le ${DateFormat('dd-MM-yyyy à HH:mm').format(DateTime.now())} Comm. ${Mt}";

                  await DbTools.setInventaire();

                  Navigator.of(context).pop();
                },
              ),
        widget.Visue
            ? Container()
            : ElevatedButton(
                child: Text("Accepter",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () async {
                  DbTools.gInventaire.AffAccept = AffAcept;
                  DbTools.gInventaire.Date_Accept = "Affaire acceptée le ${DateFormat('dd-MM-yyyy à HH:mm').format(DateTime.now())} ";

                  await DbTools.setInventaire();

                  Navigator.of(context).pop();
                }),
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
              isVisiblePhoto0 ? BlockCarousel() : Container(),
              Container(
                width: 10,
              ),
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
    await UploadFilePicker(
        "Qualif_${DbTools.gInventaire.id}_" + aIndex.toString() + ".jpg",
        99,
        aIndex);
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
