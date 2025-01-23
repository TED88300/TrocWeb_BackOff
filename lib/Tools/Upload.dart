import 'dart:convert';
import 'dart:typed_data';

import 'package:TrocWeb_BackOff/Tools/DbTools.dart';

import 'package:TrocWeb_BackOff/Tools/InventaireDet.dart';
import 'package:TrocWeb_BackOff/Tools/save_file_web.dart';
import 'package:TrocWeb_BackOff/stub_file_picking/platform_file_picker.dart';
import 'package:TrocWeb_BackOff/stub_file_picking/web_file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class Upload {


  static Future<void> UploadFilePickerMulti(int Consumer, int iIndex) async {
    int aIndex = iIndex;
    FilePickerResult? result;
    print("pick files");
    result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png'], allowMultiple: true, withReadStream: true, withData: false);
    if (result != null) {
      DbTools.setSrvToken();
      String wPath = DbTools.SrvUrl;
      var uri = Uri.parse(wPath.toString());

      List? files = result.files;
      print("adding files selected with file picker");
      for (PlatformFile file in files) {
        print("file " + file.name);

        String imagepath = "Photo_${DbTools.gInventaireDet.id}_" + aIndex.toString() + ".jpg";
        print("imagepath " + imagepath);

        var request = new http.MultipartRequest("POST", uri);
        request.fields.addAll({
          'tic12z': DbTools.SrvToken,
          'zasq': 'uploadphotosize',
          'imagepath': imagepath,
        });



        var multipartFile = new http.MultipartFile('uploadfile',  file.readStream!, file.size, filename: file.name);
        request.files.add(multipartFile);
        var response = await request.send();
        print(response.statusCode);
        await response.stream.transform(utf8.decoder).listen((value) async {

//            value {"success":1,"name":"Photo_62973_1.jpg","uploadfilename":"\/var\/www\/clients\/client0\/web2\/tmp\/phpmQfloJ","is_uploaded_file":"OK","size":32105,"mime":"image\/jpeg","mimetype":"jpg","mimecompress":"60","werror":"Move  OK = "}
//            value {"success":1,"name":"Photo_62973_1.jpg","uploadfilename":"\/var\/www\/clients\/client0\/web2\/tmp\/phpygit7w","is_uploaded_file":"OK","size":32105,"mime":"image\/jpeg","mimetype":"jpg","mimecompress":"60","werror":"Move  OK = "}

          print("value " + value);
          print("Fin $aIndex");
          if (Consumer == 99) return;

          await DbTools.addInventaireDetPhotos(aIndex++);


          if (Consumer == 0) {
            consumerA_Inventaire.setState((state) async {
              state.picList.add(file.bytes!);
            });


          }
        });
      }
        }
    if (Consumer == 0) {
      consumerB_Inventaire.setState((state) async {
        state.isVisibleObj = true;
        state.isVisiblePhoto = true;
        state.isVisiblePhoto0 = true;
      });
      DbTools.notif.BroadCast();
    }
  }

  static Future<void> UploadFilePicker(String imagepath, int Consumer, int aIndex) async {
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

      var multipartFile = new http.MultipartFile.fromBytes('uploadfile', stream, filename: basename("xxx.jpg"));
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print("value " + value);
        print("Fin");
        if (Consumer == 99) return;
        DbTools.addInventaireDetPhotos(aIndex);
        if (Consumer == 0) {
          consumerA_Inventaire.setState((state) async {
            print("consumerA_Inventaire setState > ${state.picList.length}");
            state.picList.add(Uint8List.fromList(stream));
            print("consumerA_Inventaire setState <  ${state.picList.length}");
//            return;
          });
          consumerB_Inventaire.setState((state) async {
            state.isVisibleObj = true;
            state.isVisiblePhoto = true;
            state.isVisiblePhoto0 = true;
          });
          DbTools.notif.BroadCast();
        }
      }



      );
    });
  }

  static Future<void> SaveFilePicker(int Doc) async {
    print("SaveFilePicker");

    switch (Doc) {
      case 0:
        await CrtExcell("TK_Debarras_${DbTools.gInventaire.nom}.xlsx");
        break;
      case 1:
        await CrtPdf("TK_Debarras_${DbTools.gInventaire.nom}.pdf");
        break;
      case 2:
        await CrtPdfPhoto("TK_Debarras_Photo_${DbTools.gInventaire.nom}.pdf");
        break;
      case 3:
        await CrtPdfPhoto("TK_Debarras_Fin_Chantier_${DbTools.gInventaire.nom}.pdf");
        break;
    }
  }

  static Future<void> CrtExcell(String filepath) async {
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    //Set data in the worksheet.
    sheet.getRangeByName('A1').columnWidth = 2;
    sheet.getRangeByName('B1:C1').columnWidth = 10;

    sheet.getRangeByName('D1:E1').columnWidth = 30;
    sheet.getRangeByName('F1').columnWidth = 3;
    sheet.getRangeByName('G1:H1').columnWidth = 10;

    sheet.getRangeByName('I1:S1').columnWidth = 7;
    sheet.getRangeByName('T1').columnWidth = 20;

    sheet.getRangeByName('A1:T1').cellStyle.backColor = '#333F4F';
    sheet.getRangeByName('A1:T1').merge();

    sheet.getRangeByName('B3').setText('TK débarras');
    sheet.getRangeByName('B3').cellStyle.fontSize = 32;
    sheet.getRangeByName('B3:D5').merge();

    sheet.getRangeByName('B8').setText('Client:');
    sheet.getRangeByName('B8').cellStyle.fontSize = 12;
    sheet.getRangeByName('B8').cellStyle.bold = true;

    sheet.getRangeByName('B9').setText(DbTools.gInventaire.nom);
    sheet.getRangeByName('B9').cellStyle.fontSize = 12;

    sheet.getRangeByName('B10').setText(DbTools.gInventaire.adresse1);
    sheet.getRangeByName('B10').cellStyle.fontSize = 12;

    sheet.getRangeByName('B11').setText(DbTools.gInventaire.adresse2);
    sheet.getRangeByName('B11').cellStyle.fontSize = 12;

    sheet.getRangeByName('B12').setText("${DbTools.gInventaire.cp} ${DbTools.gInventaire.ville}");
    sheet.getRangeByName('B12').cellStyle.fontSize = 12;

    sheet.getRangeByName('D9').setText(DbTools.gInventaire.mail);
    sheet.getRangeByName('D9').cellStyle.fontSize = 12;

    sheet.getRangeByName('D10').setText(DbTools.gInventaire.tel);
    sheet.getRangeByName('D10').cellStyle.fontSize = 12;

    sheet.getRangeByName('E12').dateTime = DateTime.now();
    sheet.getRangeByName('E12').numberFormat = r'[$-x-sysdate]dddd, mmmm dd, yyyy';
    sheet.getRangeByName('E12')..cellStyle.fontSize = 12;
    sheet.getRangeByName('E12')..cellStyle.hAlign = HAlignType.right;

    final Range range6 = sheet.getRangeByName('B15:T15');
    range6.cellStyle.fontSize = 12;
    range6.cellStyle.bold = true;

    sheet.getRangeByIndex(15, 2).setText('ID');
    sheet.getRangeByIndex(15, 3).setText('inv');
    sheet.getRangeByIndex(15, 4).setText('Pièce');
    sheet.getRangeByIndex(15, 5).setText('Objet');

    sheet.getRangeByIndex(15, 6).setText('CDE');
    sheet.getRangeByIndex(15, 7).setText('PV');
    sheet.getRangeByIndex(15, 8).setText('PA');

    sheet.getRangeByIndex(15, 9).setText('Tps');
    sheet.getRangeByIndex(15, 10).setText('T C');
    sheet.getRangeByIndex(15, 11).setText('T D');
    sheet.getRangeByIndex(15, 12).setText('T E');

    sheet.getRangeByIndex(15, 13).setText('M3');
    sheet.getRangeByIndex(15, 14).setText('M3 C');
    sheet.getRangeByIndex(15, 15).setText('M3 D');
    sheet.getRangeByIndex(15, 16).setText('M3 E');

    sheet.getRangeByIndex(15, 17).setText('TRI');
    sheet.getRangeByIndex(15, 18).setText('DEM');
    sheet.getRangeByIndex(15, 19).setText('MAN');
    sheet.getRangeByIndex(15, 20).setText('AUTRE');

    int row = 16;
    DbTools.ListInventaireDet.forEach((element) async {
      if (element.libelle != "--- Fin de Chantier ---") {
        sheet.getRangeByIndex(row, 2).setText('${element.id}');
        sheet.getRangeByIndex(row, 3).setText('${element.invid}');
        sheet.getRangeByIndex(row, 4).setText('${element.piece}');
        sheet.getRangeByIndex(row, 5).setText('${element.libelle}');
        sheet.getRangeByIndex(row, 6).setText('${element.CDE}');

        sheet.getRangeByIndex(row, 7).setNumber(double.parse('${element.Px_Vente}'));
        sheet.getRangeByIndex(row, 8).setNumber(double.parse('${element.Px_Achat}'));
        sheet.getRangeByIndex(row, 9).setNumber(double.parse('${element.Temps}'));
        if (element.CDE == "C") sheet.getRangeByIndex(row, 10).setNumber(double.parse('${element.Temps}'));
        if (element.CDE == "D") sheet.getRangeByIndex(row, 11).setNumber(double.parse('${element.Temps}'));
        if (element.CDE == "E") sheet.getRangeByIndex(row, 12).setNumber(double.parse('${element.Temps}'));
        sheet.getRangeByIndex(row, 13).setNumber(double.parse('${element.M3}'));
        if (element.CDE == "C") sheet.getRangeByIndex(row, 14).setNumber(double.parse('${element.M3}'));
        if (element.CDE == "D") sheet.getRangeByIndex(row, 15).setNumber(double.parse('${element.M3}'));
        if (element.CDE == "E") sheet.getRangeByIndex(row, 16).setNumber(double.parse('${element.M3}'));

        sheet.getRangeByIndex(row, 17).setText('${element.Tri}');
        sheet.getRangeByIndex(row, 18).setText('${element.Demontage}');
        sheet.getRangeByIndex(row, 19).setText('${element.Manip_Delicate}');
        sheet.getRangeByIndex(row, 20).setText('${element.Autre}');

        row++;
      }
    });

    //Set data in the worksheet.
    sheet.getRangeByName('A1').columnWidth = 2;
    sheet.getRangeByName('B1:C1').columnWidth = 10;

    sheet.getRangeByName('D1:E1').columnWidth = 30;
    sheet.getRangeByName('F1').columnWidth = 4;
    sheet.getRangeByName('F16:F${row}').cellStyle.hAlign = HAlignType.center;

    sheet.getRangeByName('G1:H1').columnWidth = 10;

    sheet.getRangeByName('I1:S1').columnWidth = 7;
    sheet.getRangeByName('G16:S${row}').cellStyle.hAlign = HAlignType.right;
    sheet.getRangeByName('G16:S${row}').numberFormat = r'#,##0.0';

    sheet.getRangeByName('T1').columnWidth = 20;

    sheet.getRangeByIndex(row, 5).setText('Total');
    sheet.getRangeByIndex(row, 7).setFormula('=SUM(G16:G${row - 1})');
    sheet.getRangeByIndex(row, 8).setFormula('=SUM(H16:H${row - 1})');
    sheet.getRangeByIndex(row, 9).setFormula('=SUM(I16:I${row - 1})');
    sheet.getRangeByIndex(row, 10).setFormula('=SUM(J16:J${row - 1})');
    sheet.getRangeByIndex(row, 11).setFormula('=SUM(K16:K${row - 1})');
    sheet.getRangeByIndex(row, 12).setFormula('=SUM(L16:L${row - 1})');
    sheet.getRangeByIndex(row, 13).setFormula('=SUM(M16:M${row - 1})');
    sheet.getRangeByIndex(row, 14).setFormula('=SUM(N16:N${row - 1})');
    sheet.getRangeByIndex(row, 15).setFormula('=SUM(O16:O${row - 1})');
    sheet.getRangeByIndex(row, 16).setFormula('=SUM(P16:P${row - 1})');

    int rowVal = row + 2;

    double MtDechM3 = DbTools.gEtablissement.MtDechM3;

    sheet.getRangeByIndex(rowVal, 5).setText('Valorisation');
    sheet.getRangeByIndex(rowVal, 7).setText('Reprise');
    sheet.getRangeByIndex(rowVal, 8).setFormula('=SUM(H16:H${row - 1})');

    sheet.getRangeByIndex(rowVal, 11).setText('Décheterie');
    sheet.getRangeByIndex(rowVal, 11, rowVal, 13).merge();
    sheet.getRangeByIndex(rowVal, 14).setFormula('=SUM(O16:O${row - 1})');
    sheet.getRangeByIndex(rowVal, 14, rowVal, 15).merge();

    int rowVal1 = rowVal + 1;
    sheet.getRangeByIndex(rowVal1, 11).setText('Mt / M3');
    sheet.getRangeByIndex(rowVal1, 11, rowVal, 13).merge();
    sheet.getRangeByIndex(rowVal1, 14).setValue(MtDechM3);
    sheet.getRangeByIndex(rowVal1, 14, rowVal, 15).merge();

    int rowVal2 = rowVal + 2;
    sheet.getRangeByIndex(rowVal2, 11).setText('Mt décheterie');
    sheet.getRangeByIndex(rowVal2, 11, rowVal, 13).merge();
    sheet.getRangeByIndex(rowVal2, 14).setFormula('=N${rowVal} * N${rowVal1}');
    sheet.getRangeByIndex(rowVal2, 14, rowVal, 15).merge();

    int rowVal3 = rowVal + 3;
    sheet.getRangeByIndex(rowVal3, 11).setText('Reprise');
    sheet.getRangeByIndex(rowVal3, 11, rowVal, 13).merge();
    sheet.getRangeByIndex(rowVal3, 14).setFormula('=H${rowVal}');
    sheet.getRangeByIndex(rowVal3, 14, rowVal, 15).merge();

    int rowVal4 = rowVal + 4;
/*
    sheet.getRangeByIndex(rowVal4, 11).setText('Total client');
    sheet.getRangeByIndex(rowVal4, 11, rowVal, 13).merge();
    sheet.getRangeByIndex(rowVal4, 14).setFormula('=N${rowVal2} - H${rowVal}');
    sheet.getRangeByIndex(rowVal4, 14, rowVal, 15).merge();
*/

    final Range rangeTot = sheet.getRangeByName('B${row}:T${row}');
    rangeTot.cellStyle.fontSize = 12;
    rangeTot.cellStyle.bold = true;

    final Range rangeVal = sheet.getRangeByName('B${rowVal}:T${rowVal4}');
    rangeVal.cellStyle.fontSize = 15;
    rangeVal.cellStyle.bold = true;

    rangeVal.cellStyle.hAlign = HAlignType.right;
    rangeVal.numberFormat = r'#,##0.0';

    final Range rangeTab = sheet.getRangeByName('B15:T${row}');
    rangeTab.cellStyle.borders.all.lineStyle = LineStyle.thin;

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    //Save and launch the file.
    await FileSaveHelper.saveAndLaunchFile(bytes, filepath);
  }

  //***************************************************

  static Future<void> CrtPdf(String filepath) async {
    print("CrtPdf >");

    final PdfDocument document = PdfDocument();

    document.pageSettings.size = PdfPageSize.a4;
    document.pageSettings.orientation = PdfPageOrientation.landscape;
    print("CrtPdf A");

    final PdfPage page = document.pages.add();
    print("CrtPdf B");

    final Size pageSize = page.getClientSize();
    print("CrtPdf C");

    final PdfGrid grid = getGrid();
    print("CrtPdf D");

    final PdfLayoutResult result = drawHeader(document, page, pageSize);
    print("CrtPdf E");

    drawGrid(page, grid, result);
    //Add invoice footer

    final List<int> bytes = await document.save();
    document.dispose();
    await FileSaveHelper.saveAndLaunchFile(bytes, filepath);

    print("CrtPdf <");
  }

  //***************************************************

  static List<String> imgList = [];

  static Future<void> CrtPdfPhoto(String filepath) async {
    print("CrtPdfPhoto > ${DbTools.ListInventaireDetPhotoAll.length}");

    final PdfDocument document = PdfDocument();

    document.pageSettings.size = PdfPageSize.a4;
    document.pageSettings.orientation = PdfPageOrientation.portrait;

    final PdfPage page = document.pages.add();

    final Size pageSize = page.getClientSize();

    print("CrtPdfPhoto getGridPhoto>");
    PdfGrid grid = PdfGrid();
    await getGridPhoto(grid);
    print("CrtPdfPhoto getGridPhoto<");

    print("CrtPdfPhoto drawHeader €");
    final PdfLayoutResult result = drawHeader(document, page, pageSize);

    print("CrtPdfPhoto drawGrid>");
    drawGrid(page, grid, result);
    //Add invoice footer

    print("CrtPdfPhoto drawGrid<");

    final List<int> bytes = await document.save();
    print("CrtPdfPhoto Fa ${bytes.length}");
    document.dispose();
    print("CrtPdfPhoto Fb");
    await FileSaveHelper.saveAndLaunchFile(bytes, filepath);

    print("CrtPdfPhoto <");
  }

  //***************************************************

  static PdfLayoutResult drawHeader(PdfDocument document, PdfPage page, Size pageSize) {
    //Draw rectangle
    //document.compressionLevel = PdfCompressionLevel.best;

    final PdfBitmap image = PdfBitmap(DbTools.LogoimageData.buffer.asUint8List());

    page.graphics.drawImage(image, const Rect.fromLTWH(0, 0, 200, 70));
    String wDate = 'Le ${DateFormat('dd-MM-yyyy').format(DateTime.now())}';

    page.graphics.drawString(wDate, PdfStandardFont(PdfFontFamily.helvetica, 12), bounds: Rect.fromLTWH(10, 70, pageSize.width - 115, 90), format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    if (DbTools.CD_FdC == "I") {
      page.graphics.drawString('Inventaire', PdfStandardFont(PdfFontFamily.helvetica, 30), bounds: Rect.fromLTWH(10, 40, pageSize.width - 115, 90), format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
    } else {
      page.graphics.drawString('Fin de chantier', PdfStandardFont(PdfFontFamily.helvetica, 30), bounds: Rect.fromLTWH(10, 40, pageSize.width - 115, 90), format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

      double LP = 130;
      if (DbTools.gInventaire.FinCh_Opt_1) {
        page.graphics.drawString("[X] L'intervention a été réalisée dans son intégralité", PdfStandardFont(PdfFontFamily.helvetica, 12), bounds: Rect.fromLTWH(10, LP, pageSize.width - 15, 20), format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      }

      LP += 16;
      if (DbTools.gInventaire.FinCh_Opt_2) {
        page.graphics.drawString("[X] Absence de dommages (casse, objets manquants pris par erreur, fuite d'eau...)", PdfStandardFont(PdfFontFamily.helvetica, 12), bounds: Rect.fromLTWH(10, LP, pageSize.width - 15, 20), format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      }

      LP += 16;
      if (DbTools.gInventaire.FinCh_Opt_3) {
        page.graphics.drawString("[X] Clés remises", PdfStandardFont(PdfFontFamily.helvetica, 12), bounds: Rect.fromLTWH(10, LP, pageSize.width - 15, 20), format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      }

      LP += 16;
      if (DbTools.gInventaire.FinCh_Opt_4) {
        page.graphics.drawString("[X] Balayage de fin de chantier réalisé", PdfStandardFont(PdfFontFamily.helvetica, 12), bounds: Rect.fromLTWH(10, LP, pageSize.width - 15, 20), format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      }

      if (DbTools.PdfBitmapSign.isNotEmpty) page.graphics.drawImage(DbTools.PdfBitmapSign[0], const Rect.fromLTWH(350, 170, 100, 100));
      page.graphics.drawRectangle(pen: PdfPen(PdfColor(0, 0, 0)), bounds: const Rect.fromLTWH(345, 175, 110, 100));
    }

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 12);

    //***************************************************

    page.graphics.drawString('Amount', contentFont, brush: PdfBrushes.white, bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33), format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.bottom));

    final DateFormat format = DateFormat.yMMMMd('en_US');

    String address = '\n${DbTools.gInventaire.nom}\n${DbTools.gInventaire.adresse1}\n${DbTools.gInventaire.adresse2}\n';
    address += "${DbTools.gInventaire.cp} ${DbTools.gInventaire.ville}\n\n";
    address += "Tel : ${DbTools.gInventaire.tel}";

    return PdfTextElement(text: address, font: contentFont).draw(page: page, bounds: Rect.fromLTWH(pageSize.width - 200, 10, 200, pageSize.height - 120))!;
  }

  static void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };

    int hent = 50;

    if (DbTools.CD_FdC == "F") hent = 200;
    //Draw the PDF grid and get the result.
    result = grid.draw(page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + hent, 0, 0))!;
  }

  static PdfGrid getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();

    int nbCol = 0;
    for (int i = 0; i < 17; ++i) {
      if (DbTools.isVisChamps[i]) {
        print("$i");
        nbCol++;
      }
    }

    grid.columns.add(count: nbCol);
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 68, 68));
    headerRow.style.textBrush = PdfBrushes.white;

    int colidx = 0;
    int col = 0;
    if (DbTools.isVisChamps[colidx++]) headerRow.cells[col++].value = "Pièce";
    if (DbTools.isVisChamps[colidx++]) headerRow.cells[col++].value = "Objet";
    if (DbTools.isVisChamps[colidx++]) headerRow.cells[col++].value = "CDE  ";
    if (DbTools.isVisChamps[colidx++]) headerRow.cells[col++].value = "Prix vente";
    if (DbTools.isVisChamps[colidx++]) headerRow.cells[col++].value = "Prix achat";
    if (DbTools.isVisChamps[colidx++]) headerRow.cells[col++].value = "Tps  ";
    if (DbTools.isVisChamps[colidx++]) headerRow.cells[col++].value = "Tps C  ";
    if (DbTools.isVisChamps[colidx++]) headerRow.cells[col++].value = "Tps D  ";
    if (DbTools.isVisChamps[colidx++]) headerRow.cells[col++].value = "Tps E  ";
    if (DbTools.isVisChamps[colidx++]) headerRow.cells[col++].value = "M3   ";
    if (DbTools.isVisChamps[colidx++]) headerRow.cells[col++].value = "M3 C ";
    if (DbTools.isVisChamps[colidx++]) headerRow.cells[col++].value = "M3 D ";
    if (DbTools.isVisChamps[colidx++]) headerRow.cells[col++].value = "M3 E ";
    if (DbTools.isVisChamps[colidx++]) {
      headerRow.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      headerRow.cells[col++].value = "TRI  ";
    }
    if (DbTools.isVisChamps[colidx++]) {
      headerRow.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      headerRow.cells[col++].value = "DEM  ";
    }
    if (DbTools.isVisChamps[colidx++]) {
      headerRow.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      headerRow.cells[col++].value = "MAN  ";
    }
    if (DbTools.isVisChamps[colidx++]) {
      headerRow.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      grid.columns[col].width = 100;
      headerRow.cells[col++].value = "AUTRE";
    }

    DbTools.ListInventaireDet.forEach((element) async {
      if (element.libelle != "--- Fin de Chantier ---") {
        addProducts(element, grid);
      }
    });
//    addTotal(grid);

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable1Light);
    grid.columns[0].width = 50;
    grid.columns[1].width = 100;

    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding = PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      if (i > 2) headerRow.cells[i].stringFormat.alignment = PdfTextAlignment.right;
    }

    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];

        cell.style.cellPadding = PdfPaddings(bottom: 2, left: 2, right: 2, top: 2);
      }
    }

    return grid;
  }

  static Future<void> getGridPhoto(PdfGrid grid) async {
    grid.columns.add(count: 6);
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 68, 68));
    headerRow.style.textBrush = PdfBrushes.white;

    int col = 0;
    headerRow.cells[col++].value = "Pièce";
    headerRow.cells[col++].value = "Objet";
    headerRow.cells[col].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[col++].value = "CDE  ";
    headerRow.cells[col++].value = "Photos";
    headerRow.cells[col++].value = "b";
    headerRow.cells[col++].value = "c";

    DbTools.ListInventaireDet.forEach((element) async {
      print("addProductsPhoto >>");

      if (DbTools.CD_FdC == "I" && element.libelle != "--- Fin de Chantier ---") {
        await addProductsPhoto(element, grid);
      }
      if (DbTools.CD_FdC == "F" && element.libelle == "--- Fin de Chantier ---") {
        await addProductsPhoto(element, grid);
      }
      print("addProductsPhoto <<");
    });

//    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable1Light);
    grid.columns[0].width = 50;
    grid.columns[1].width = 100;
    grid.columns[2].width = 30;
    grid.columns[3].width = 100;
    grid.columns[4].width = 100;
    grid.columns[5].width = 100;

    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding = PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }

    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];

        cell.style.cellPadding = PdfPaddings(bottom: 2, left: 2, right: 2, top: 2);
      }
    }
  }

  static Future<void> addProductsPhoto(InventaireDet element, PdfGrid grid) async {
    print("addProductsPhoto >");

    int lig = 0;
    int col = 0;
    PdfGridRow row = grid.rows.add();
    row.cells[col++].value = element.piece;
    row.cells[col++].value = element.libelle;
    row.cells[col].stringFormat.alignment = PdfTextAlignment.center;
    row.cells[col++].value = element.CDE;

    for (int i = 0; i < DbTools.PdfBitmapNameList.length; ++i) {
      //  print("w $i $lig ${DbTools.PdfBitmapNameList.length} ${DbTools.PdfBitmapList.length}");
      String wTmp = DbTools.PdfBitmapNameList[i];

      if (wTmp.contains("${element.id}")) {
/*
        if (lig > 0) {
          col = 0;
          row = grid.rows.add();
          row.cells[col++].value = "";
          row.cells[col++].value = "";
          row.cells[col++].value = "";
        }
        lig++;
*/

        if (col > 5) {
          lig++;
          col = 0;
          row = grid.rows.add();
          row.cells[col++].value = "";
          row.cells[col++].value = "";
          row.cells[col++].value = "";
        }

        double w = DbTools.PdfBitmapList[i].width / 1;
        double rat = w / 100;
        double h = DbTools.PdfBitmapList[i].height / rat;

        h = 110;
        print("bck $lig $col h $h w ${w}");
        row.cells[col].style.backgroundImage = DbTools.PdfBitmapList[i];
        row.height = h;
        row.cells[col++].value = "";
      }
    }
    print("addProductsPhoto <");
  }

  static double tPx_Vente = 0.0;
  static double tPx_Achat = 0.0;

  static double tTps = 0;
  static double tTpsC = 0;
  static double tTpsD = 0;
  static double tTpsE = 0;

  static double tM3 = 0.0;
  static double tM3C = 0.0;
  static double tM3D = 0.0;
  static double tM3E = 0.0;

  static void addProducts(InventaireDet element, PdfGrid grid) {
    NumberFormat numberFormat = NumberFormat.currency(locale: 'eu', symbol: '');


//    print("element ${element.Desc()}");

    int col = 0;
    int colidx = 0;




    tPx_Vente += double.parse(element.Px_Vente.toString().replaceAll(",", "."));
    tPx_Achat += double.parse(element.Px_Achat.toString().replaceAll(",", "."));
    tTps += double.parse(element.Temps.toString().replaceAll(",", "."));
    tTpsC += element.CDE == "C" ? double.parse(element.Temps.toString().replaceAll(",", ".")) : 0;
    tTpsD += element.CDE == "D" ? double.parse(element.Temps.toString().replaceAll(",", ".")) : 0;
    tTpsE += element.CDE == "E" ? double.parse(element.Temps.toString().replaceAll(",", ".")) : 0;

    tM3 += double.parse(element.M3.toString());
    tM3C += element.CDE == "C" ? double.parse(element.M3.toString()) : 0;
    tM3D += element.CDE == "D" ? double.parse(element.M3.toString()) : 0;
    tM3E += element.CDE == "E" ? double.parse(element.M3.toString()) : 0;

    final PdfGridRow row = grid.rows.add();
    if (DbTools.isVisChamps[colidx++]) row.cells[col++].value = element.piece;
    if (DbTools.isVisChamps[colidx++]) row.cells[col++].value = element.libelle;
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.left;
      row.cells[col++].value = element.CDE;
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = numberFormat.format(double.parse(element.Px_Vente.toString()));
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = numberFormat.format(double.parse(element.Px_Achat.toString()));
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = element.Temps.toString();
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = element.CDE == "C" ? element.Temps.toString() : "";
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = element.CDE == "D" ? element.Temps.toString() : "";
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = element.CDE == "E" ? element.Temps.toString() : "";
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = numberFormat.format(double.parse(element.M3.toString()));
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = element.CDE == "C" ? numberFormat.format(double.parse(element.M3.toString())) : "";
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = element.CDE == "D" ? numberFormat.format(double.parse(element.M3.toString())) : "";
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = element.CDE == "E" ? numberFormat.format(double.parse(element.M3.toString())) : "";
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = element.Tri;
    }

    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = element.Demontage;
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = element.Manip_Delicate;
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = element.Autre;
    }
  }

  static void addTotal(PdfGrid grid) {
    NumberFormat numberFormat = NumberFormat.currency(locale: 'eu', symbol: '');
    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold);

    PdfGridRow row = grid.rows.add();
    row.style.font = contentFont;

    int colPA = 0;
    int colM3D = 0;

    int col = 0;
    int colidx = 0;

    if (DbTools.isVisChamps[colidx++]) row.cells[col++].value = "";
    if (DbTools.isVisChamps[colidx++]) row.cells[col++].value = "TOTAL";
    if (DbTools.isVisChamps[colidx++]) row.cells[col++].value = "";
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = numberFormat.format(tPx_Vente);
    }
    if (DbTools.isVisChamps[colidx++]) {
      colPA = col;

      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = numberFormat.format(tPx_Achat);
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = "${tTps}";
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = "${tTpsC}";
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = "${tTpsD}";
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = "${tTpsE}";
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = numberFormat.format(tM3);
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = numberFormat.format(tM3C);
    }
    if (DbTools.isVisChamps[colidx++]) {
      colM3D = col;

      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = numberFormat.format(tM3D);
    }
    if (DbTools.isVisChamps[colidx++]) {
      row.cells[col].stringFormat.alignment = PdfTextAlignment.right;
      row.cells[col++].value = numberFormat.format(tM3E);
    }
    if (DbTools.isVisChamps[colidx++]) row.cells[col++].value = "";
    if (DbTools.isVisChamps[colidx++]) row.cells[col++].value = "";
    if (DbTools.isVisChamps[colidx++]) row.cells[col++].value = "";
    if (DbTools.isVisChamps[colidx++]) row.cells[col++].value = "";

    row = grid.rows.add();
    row.style.font = contentFont;

    row.cells[colPA].stringFormat.alignment = PdfTextAlignment.right;
    row.cells[colPA].value = numberFormat.format(tPx_Achat);

    row.cells[colM3D].stringFormat.alignment = PdfTextAlignment.right;
    row.cells[colM3D].value = numberFormat.format(tM3D);
  }
}
