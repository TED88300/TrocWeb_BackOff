import 'package:TrocWeb_BackOff/Tools/save_file_web.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'DbTools.dart';

class Devis_FactImp {
  Devis_FactImp();
  static PdfColor PDF_primary = PdfColor(141, 198, 63, 255);
  static PdfColor PDF_white = PdfColor(255, 255, 255, 255);
  static String address = "";
  static String addressLib = "";
  static String faddress = "";
  static String eaddress1 = "";
  static String eaddress2 = "";
  static String pp = "";
  static String No = "";
  static String Ref = "";
  static String Rib = "";
  static String Rglt = "";
  static String Ass_RC = "";

  static String DF = "D";
  static String DFLib = "D";

  static double tot_Client = 0.0;

  static int BaseMargeHaut = 30;
  static String Rem = "";

  static bool isRem = false;
  static bool isAcompte = false;

  static Future<List<int>> _readData(String name) async {
    final ByteData data = await rootBundle.load('fonts/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  static Future GenDevis() async {
    DF = "${DbTools.gCde_Ent.Cde_Ent_DF}";

    if (DF == "D")
      DFLib = "Devis";
    else {
      DFLib = "Facture";

      if (DbTools.gCde_Ent.Cde_Ent_EDT) DFLib = "Facture\nDuplicata";
    }

    faddress =
        "${DbTools.gInventaire.fnom}\n${DbTools.gInventaire.fadresse1}\n${DbTools.gInventaire.fadresse2}\n${DbTools.gInventaire.fcp} ${DbTools.gInventaire.fville}\n";

    if (DbTools.gInventaire.Origine == "HEXA")
      faddress =
          "${DbTools.Hexa_nom}\n${DbTools.Hexa_adresse1}\n${DbTools.Hexa_adresse2}\n${DbTools.Hexa_cp} ${DbTools.Hexa_ville}\n";

    addressLib = "Adresse du débarras :";
    address =
        "${DbTools.gInventaire.nom}\n${DbTools.gInventaire.adresse1}\n${DbTools.gInventaire.adresse2}\n${DbTools.gInventaire.cp} ${DbTools.gInventaire.ville}\n";

    String wAdr2 = DbTools.gEtablissement.adresse2.isEmpty
        ? ""
        : "${DbTools.gEtablissement.adresse2}\n";

    eaddress1 = "${DbTools.gEtablissement.Libelle}";
    eaddress2 = "${DbTools.gEtablissement.adresse1}\n${wAdr2}"
        "${DbTools.gEtablissement.cp} ${DbTools.gEtablissement.ville}\n"
        "Tel : ${DbTools.gEtablissement.tel}\n"
        "Mail :${DbTools.gEtablissement.mail}\n";

    pp = "${DbTools.gEtablissement.No_TVA}";

    String index = (DF == "D")
        ? DbTools.gEtablissement.indexDevis.toString()
        : DbTools.gEtablissement.indexFacture.toString();

    No = DbTools.gInventaire.DateCrt +
        "-" +
        DbTools.gInventaire.etabid.toString() +
        "-" +
        DbTools.gInventaire.id.toString() +
        "-" +
        index;

    tot_Client = DbTools.gCde_Ent.Cde_Ent_Tot_TTC -
        DbTools.gCde_Ent.Cde_Ent_Rep_Net -
        DbTools.gCde_Ent.Cde_Ent_Rem_Net ;

    if (DF == "D")
      DbTools.gEtablissement.indexDevis++;
    else
      DbTools.gEtablissement.indexFacture++;

    await DbTools.setEtablissement();

    Ref = "Agence : " +
        DbTools.gInventaire.etabid.toString() +
        "- Affaire : " +
        DbTools.gInventaire.id.toString();

    Rib = "${DbTools.gEtablissement.RIB}";

    Rglt = "${DbTools.gEtablissement.RGLT}";

    Ass_RC = "${DbTools.gEtablissement.Ass_RC}";

    Rem = "${DbTools.gCde_Ent.Cde_Ent_Remarque}";

    final PdfDocument document = PdfDocument();
    document.pageSettings.margins.all = 10;

//    document.compressionLevel = PdfCompressionLevel.best;

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    page.graphics.drawRectangle(
        pen: PdfPen(PdfColor(255, 255, 255)),
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height));

    final PdfGrid grid = await getGrid();
    final PdfGrid gridTot = await getGridTot();
    final PdfGrid gridRep = await getGridRep();
    final PdfGrid gridNet = await getGridNet();
    final PdfGrid gridHT_TV = await getGridHT_TV();

    final PdfLayoutResult result = await drawHeader(page, pageSize, grid);

    drawGrid(page, grid, result);
    drawGridTot(page, gridTot, result);
    drawGridRep(page, gridRep, result);
    drawGridNet(page, gridNet, result);
    drawGridHT_TV(page, gridHT_TV, result);

    drawFooter(page, pageSize);

//    ByteData imageData = await rootBundle.load('assets/images/Euro.png');
//    final PdfBitmap image = PdfBitmap(imageData.buffer.asUint8List());
/*
    const double wL = 20.5;
    const double wbt = 275.0;

    page.graphics.drawImage(image, const Rect.fromLTWH(387, wbt, 8, 8));
    page.graphics.drawImage(image, const Rect.fromLTWH(387, wbt + wL, 8, 8));
    page.graphics.drawImage(image, const Rect.fromLTWH(387, wbt + wL * 2, 8, 8));
    page.graphics.drawImage(image, const Rect.fromLTWH(387, wbt + wL * 3, 8, 8));
    page.graphics.drawImage(image, const Rect.fromLTWH(387, wbt + wL * 4, 8, 8));

    page.graphics.drawImage(image, const Rect.fromLTWH(387 + 175, wbt, 8, 8));
    page.graphics.drawImage(image, const Rect.fromLTWH(387 + 175, wbt + wL, 8, 8));
    page.graphics.drawImage(image, const Rect.fromLTWH(387 + 175, wbt + wL * 2, 8, 8));
    page.graphics.drawImage(image, const Rect.fromLTWH(387 + 175, wbt + wL * 3, 8, 8));
    page.graphics.drawImage(image, const Rect.fromLTWH(387 + 175, wbt + wL * 4, 8, 8));

    const double wbt2 = 385;

    page.graphics.drawImage(image, const Rect.fromLTWH(387 + 175, wbt2, 8, 8));
    page.graphics.drawImage(image, const Rect.fromLTWH(387 + 175, wbt2 + wL, 8, 8));
    page.graphics.drawImage(image, const Rect.fromLTWH(387 + 175, wbt2 + wL * 2, 8, 8));
    page.graphics.drawImage(image, const Rect.fromLTWH(387 + 175, 454, 8, 8));
    page.graphics.drawImage(image, const Rect.fromLTWH(387 + 175, 492, 8, 8));
*/

    if (DF == "D") {
      final PdfPage page2 = document.pages.add();

      final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 10,
          style: PdfFontStyle.regular);

      PdfTextElement(text: DbTools.gEtablissement.CGV, font: contentFont).draw(
          page: page2,
          bounds: Rect.fromLTWH(10, 10, pageSize.width - 20, pageSize.height))!;
    }

//    page.graphics.drawImage(image, const Rect.fromLTWH(387 + 175, 545 + wL, 8, 8));
//    page.graphics.drawImage(image, const Rect.fromLTWH(387 + 175, 545 + wL*2, 8, 8));

    final List<int> bytes = await document.save();
    //Dispose the document.
    document.dispose();
    //Save and launch the file.

    if (DbTools.gCde_Ent.Cde_Ent_EDT) DFLib = "Facture\nDuplicata";

    if (DF == "D")
      await FileSaveHelper.saveAndLaunchFile(
          bytes, 'TK_Debarras_Devis_${DbTools.gInventaire.nom}.pdf');
    else {
      String wFileName = "TK_Debarras_Facture_";
      if (DbTools.gCde_Ent.Cde_Ent_EDT) wFileName += "Duplicata_";

      await FileSaveHelper.saveAndLaunchFile(
          bytes, '$wFileName${DbTools.gInventaire.nom}.pdf');
    }
  }

//*****************************************************************

  static Future<PdfLayoutResult> drawHeader(
      PdfPage page, Size pageSize, PdfGrid grid) async {
    print("A");

    ByteData imageData = await rootBundle.load('assets/images/Logo.png');
    final PdfBitmap image = PdfBitmap(imageData.buffer.asUint8List());
    page.graphics.drawImage(image, const Rect.fromLTWH(0, 0, 200, 70));

    final PdfFont contentFontLarge =
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
    final PdfFont contentFontBold =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 10,
        style: PdfFontStyle.regular);

    page.graphics.drawString(
        "${DFLib}", PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfSolidBrush(PdfColor(88, 88, 90)),
        bounds: Rect.fromLTWH(350, 0, 200, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    final DateFormat format = DateFormat.yMMMMd('fr_FR');

    final String invoiceNumber =
        '${eaddress2}\n\n\n\n$DFLib N° ${No}\n${DbTools.gEtablissement.ville}, le ${DateFormat('dd-MM-yyyy').format(DateTime.parse(DbTools.gCde_Ent.Cde_Ent_Date))}';

    PdfTextElement(text: eaddress1, font: contentFontLarge).draw(
        page: page,
        bounds: Rect.fromLTWH(10, 80, pageSize.width, pageSize.height))!;
    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(10, 100, pageSize.width, pageSize.height))!;
    PdfTextElement(text: addressLib, font: contentFontBold).draw(
        page: page,
        bounds: Rect.fromLTWH(10, 420, pageSize.width, pageSize.height))!;

    PdfTextElement(text: Rem, font: contentFontBold).draw(
        page: page,
        bounds:
            Rect.fromLTWH(10, 500, pageSize.width / 2 - 20, pageSize.height))!;

    PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(10, 435, pageSize.width, pageSize.height))!;

    return PdfTextElement(text: faddress, font: contentFontBold).draw(
        page: page,
        bounds: Rect.fromLTWH(280, 130, pageSize.width, pageSize.height))!;
  }

  static void drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen = PdfPen(PDF_primary);
    int margeH = 30;

    if (tot_Client > 0) {
      page.graphics.drawString(
          "$Ass_RC",
          PdfStandardFont(
            PdfFontFamily.helvetica,
            10,
          ),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          format: PdfStringFormat(alignment: PdfTextAlignment.center),
          bounds: Rect.fromLTWH(10, pageSize.height - 225 + margeH, 560, 50));

      page.graphics.drawString(
          "$Rglt",
          PdfStandardFont(
            PdfFontFamily.helvetica,
            10,
          ),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          format: PdfStringFormat(alignment: PdfTextAlignment.center),
          bounds: Rect.fromLTWH(10, pageSize.height - 210 + margeH, 560, 50));

      page.graphics.drawRectangle(
          pen: PdfPen(PdfColor(0, 0, 0)),
          brush: PdfSolidBrush(PdfColor(170, 170, 170)),
          bounds: Rect.fromLTWH(10, pageSize.height - 170 + margeH, 560, 20));
      page.graphics.drawString(
          "RELEVÉ D'IDENTITÉ BANCAIRE CI-DESSOUS POUR RÈGLEMENT PAR VIREMENT BANCAIRE",
          PdfStandardFont(PdfFontFamily.helvetica, 10),
          brush: PdfSolidBrush(PdfColor(255, 255, 255)),
          format: PdfStringFormat(alignment: PdfTextAlignment.center),
          bounds: Rect.fromLTWH(10, pageSize.height - 166 + margeH, 560, 20));
      page.graphics.drawRectangle(
          pen: PdfPen(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(10, pageSize.height - 150 + margeH, 560, 50));
      page.graphics.drawString(
          "$Rib", PdfStandardFont(PdfFontFamily.helvetica, 10),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          format: PdfStringFormat(alignment: PdfTextAlignment.center),
          bounds: Rect.fromLTWH(10, pageSize.height - 143 + margeH, 550, 50));
    }

    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 60),
        Offset(pageSize.width, pageSize.height - 60));
    String footerContent = pp;
    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 10),
        brush: PdfSolidBrush(PdfColor(141, 198, 63)),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
        bounds: Rect.fromLTWH(
            10, pageSize.height - 52, pageSize.width - 20, pageSize.height));
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
    result = grid.draw(
        page: page,
        bounds:
            Rect.fromLTWH(0, result.bounds.bottom + BaseMargeHaut + 40, 0, 0))!;
  }

  //Create PDF grid and return
  static Future<PdfGrid> getGrid() async {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 4);
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PDF_primary);
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Libellé';
    headerRow.cells[1].value = 'Prix Unitaire HT';
    headerRow.cells[2].value = 'Qte';
    headerRow.cells[3].value = 'Montant HT';
    //Add rows

    double wPx1 = 0.0;
    if (DbTools.gCde_Ent.Cde_Ent_Qte_1 > 0)
      wPx1 = DbTools.gCde_Ent.Cde_Ent_Net_1 / DbTools.gCde_Ent.Cde_Ent_Qte_1;
    double wMT1 = wPx1 * DbTools.gCde_Ent.Cde_Ent_Qte_1;
    addProducts(DbTools.gCde_Ent.Cde_Ent_Lib_1, wPx1,
        DbTools.gCde_Ent.Cde_Ent_Qte_1, wMT1, grid);

    double wPx2 = 0.0;
    if (DbTools.gCde_Ent.Cde_Ent_Qte_2 > 0)
      wPx2 = DbTools.gCde_Ent.Cde_Ent_Net_2 / DbTools.gCde_Ent.Cde_Ent_Qte_2;
    double wMT2 = wPx2 * DbTools.gCde_Ent.Cde_Ent_Qte_2;
    addProducts(DbTools.gCde_Ent.Cde_Ent_Lib_2, wPx2,
        DbTools.gCde_Ent.Cde_Ent_Qte_2, wMT2, grid);

    double wPx3 = 0.0;
    if (DbTools.gCde_Ent.Cde_Ent_Qte_3 > 0)
      wPx3 = DbTools.gCde_Ent.Cde_Ent_Net_3 / DbTools.gCde_Ent.Cde_Ent_Qte_3;
    double wMT3 = wPx3 * DbTools.gCde_Ent.Cde_Ent_Qte_3;
    addProducts(DbTools.gCde_Ent.Cde_Ent_Lib_3, wPx3,
        DbTools.gCde_Ent.Cde_Ent_Qte_3, wMT3, grid);

    double wPx4 = 0.0;
    if (DbTools.gCde_Ent.Cde_Ent_Qte_4 > 0)
      wPx4 = DbTools.gCde_Ent.Cde_Ent_Net_4 / DbTools.gCde_Ent.Cde_Ent_Qte_4;
    double wMT4 = wPx4 * DbTools.gCde_Ent.Cde_Ent_Qte_4;
    addProducts(DbTools.gCde_Ent.Cde_Ent_Lib_4, wPx4,
        DbTools.gCde_Ent.Cde_Ent_Qte_4, wMT4, grid);

    double wPx5 = 0.0;
    if (DbTools.gCde_Ent.Cde_Ent_Qte_5 > 0)
      wPx5 = DbTools.gCde_Ent.Cde_Ent_Net_5 / DbTools.gCde_Ent.Cde_Ent_Qte_5;
    double wMT5 = wPx5 * DbTools.gCde_Ent.Cde_Ent_Qte_5;
    addProducts(DbTools.gCde_Ent.Cde_Ent_Lib_5, wPx5,
        DbTools.gCde_Ent.Cde_Ent_Qte_5, wMT5, grid);

//    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.regular);
    //  final PdfFont contentFontBold = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

    PdfTrueTypeFont contentFont = PdfTrueTypeFont(
        await _readData('arial.ttf'), 10,
        style: PdfFontStyle.regular);
    PdfTrueTypeFont contentFontBold = PdfTrueTypeFont(
        await _readData('arial.ttf'), 10,
        style: PdfFontStyle.bold);

//    grid.applyBuiltInStyle(PdfGridBuiltInStyle.);

    grid.columns[0].width = 300;
    grid.columns[1].width = 100;
    grid.columns[2].width = 75;
    grid.columns[3].width = 100;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 0, left: 5, right: 10, top: 5);

      if (i > 0) {
        headerRow.cells[i].style.stringFormat = new PdfStringFormat();
        headerRow.cells[i].style.stringFormat!.alignment =
            PdfTextAlignment.right;
      }

      headerRow.style.font = contentFontBold;
    }

    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j > 0) {
          cell.stringFormat.alignment = PdfTextAlignment.right;
        }

        cell.style.cellPadding =
            PdfPaddings(bottom: 0, left: 5, right: 5, top: 5);

        if (j == 1 || j == 3) {
          cell.style.cellPadding =
              PdfPaddings(bottom: 0, left: 5, right: 15, top: 5);
        }

        cell.style.backgroundBrush = PdfBrushes.white;
        cell.style.font = contentFont;
      }
    }
    return grid;
  }

  static void drawGridTot(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
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
    result = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            300, result.bounds.bottom + BaseMargeHaut + 170, 0, 0))!;
  }

  static Future<PdfGrid> getGridTot() async {
    print("getGridTot ");

    final PdfGrid grid = PdfGrid();

    grid.columns.add(count: 2);

    double txTVA = DbTools.gEtablissement.TxTVA;

    addTots("Total HT", DbTools.gCde_Ent.Cde_Ent_Tot_HT, grid);
    addTots("Total TVA à $txTVA%", DbTools.gCde_Ent.Cde_Ent_Tot_TVA, grid);
    addTots("Total TTC", DbTools.gCde_Ent.Cde_Ent_Tot_TTC, grid);

    grid.columns[0].width = 175;
    grid.columns[1].width = 100;

//    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.regular);
    PdfTrueTypeFont contentFont = PdfTrueTypeFont(
        await _readData('arial.ttf'), 10,
        style: PdfFontStyle.regular);
    print("grid.rows.count ${grid.rows.count}");

    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j > 0) {
          cell.stringFormat.alignment = PdfTextAlignment.right;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 0, left: 5, right: 15, top: 5);
        cell.style.backgroundBrush = PdfBrushes.white;
        cell.style.font = contentFont;
      }
    }
    return grid;
  }

//*******************************

  static void drawGridRep(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;

    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };

    print("drawGridRep ${grid.rows.count}");

    result = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            300, result.bounds.bottom + BaseMargeHaut + 240, 0, 0))!;
  }

  static Future<PdfGrid> getGridRep() async {
    print("getGridRep ");

    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 2);
    addTots(DbTools.gCde_Ent.Cde_Ent_Rep_Lib, DbTools.gCde_Ent.Cde_Ent_Rep_Net,
        grid);

    isRem = false;
    if (DbTools.gCde_Ent.Cde_Ent_Rem_Net > 0) {
      addTots(DbTools.gCde_Ent.Cde_Ent_Rem_Lib,
          DbTools.gCde_Ent.Cde_Ent_Rem_Net, grid);
      isRem = true;
    }

    isAcompte = false;
    if (DbTools.gCde_Ent.Cde_Ent_Acompte > 0) {
      addTots("Acompte", DbTools.gCde_Ent.Cde_Ent_Acompte, grid);
      isAcompte = true;
    }

    grid.columns[0].width = 175;
    grid.columns[1].width = 100;

    PdfTrueTypeFont contentFont = PdfTrueTypeFont(
        await _readData('arial.ttf'), 10,
        style: PdfFontStyle.regular);
    print("getGridRep grid.rows.count ${grid.rows.count}");

    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j > 0) {
          cell.stringFormat.alignment = PdfTextAlignment.right;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 0, left: 5, right: 15, top: 5);
        cell.style.backgroundBrush = PdfBrushes.white;
        cell.style.font = contentFont;
      }
    }
    return grid;
  }

  static Future<PdfGrid> getGridHT_TV() async {
    print("getGridHT_TV ");

    final PdfGrid grid = PdfGrid();

    grid.columns.add(count: 1);

    double txTVA = DbTools.gEtablissement.TxTVA;
    double HT = tot_Client / (1 + DbTools.gEtablissement.TxTVA / 100);
    double dontTVA = tot_Client - HT;

    if (tot_Client > 0) {
      addTotsHT_TVA(
          "TOTAL HT : ${HT.toStringAsFixed(2)} euros    TVA à $txTVA% : ${dontTVA.toStringAsFixed(2)} euros",
          grid);
    } else {
      addTotsHT_TVA(
          "TOTAL HT : -${HT.toStringAsFixed(2)} euros    TVA à $txTVA% : -${dontTVA.toStringAsFixed(2)} euros",
          grid);
    }

    grid.columns[0].width = 275;

    PdfTrueTypeFont contentFont = PdfTrueTypeFont(
        await _readData('arial.ttf'), 10,
        style: PdfFontStyle.regular);
    print("grid.rows.count ${grid.rows.count}");

    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j > 0) {
          cell.stringFormat.alignment = PdfTextAlignment.right;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 0, left: 5, right: 15, top: 5);
        cell.style.backgroundBrush = PdfBrushes.white;
        cell.style.font = contentFont;
      }
    }
    return grid;
  }

//*******************************

  static void drawGridNet(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
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
    int h = 308;
    if (isRem) {
      result = grid.draw(
          page: page,
          bounds: Rect.fromLTWH(
              300, result.bounds.bottom + BaseMargeHaut + h, 0, 0))!;
      h += 30;
    } else if (isAcompte) {
      result = grid.draw(
          page: page,
          bounds: Rect.fromLTWH(
              300, result.bounds.bottom + BaseMargeHaut + h, 0, 0))!;
      h += 30;
    } else
      result = grid.draw(
          page: page,
          bounds: Rect.fromLTWH(
              300, result.bounds.bottom + BaseMargeHaut + 278, 0, 0))!;
  }

  //*******************************

  static void drawGridHT_TV(
      PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };

    int h = 335;

    if (isRem) {
      result = grid.draw(
          page: page,
          bounds: Rect.fromLTWH(
              300, result.bounds.bottom + BaseMargeHaut + h, 0, 0))!;
      h += 30;
    } else if (isAcompte) {
      result = grid.draw(
          page: page,
          bounds: Rect.fromLTWH(
              300, result.bounds.bottom + BaseMargeHaut + h, 0, 0))!;
    } else
      result = grid.draw(
          page: page,
          bounds: Rect.fromLTWH(
              300, result.bounds.bottom + BaseMargeHaut + 305, 0, 0))!;
  }

  static Future<PdfGrid> getGridNet() async {
    print("getGridNet ");

    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 2);

    double wtot_Client = tot_Client - DbTools.gCde_Ent.Cde_Ent_Acompte;


    if (wtot_Client >= 0) {
      addTots("TOTAL NET A PAYER", wtot_Client, grid);

    } else {
      addTots("SOLDE EN VOTRE FAVEUR", -wtot_Client, grid);

    }

    grid.columns[0].width = 175;
    grid.columns[1].width = 100;

    PdfTrueTypeFont contentFontBold = PdfTrueTypeFont(
        await _readData('arial.ttf'), 10,
        style: PdfFontStyle.bold);
    print("grid.rows.count ${grid.rows.count}");

    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j > 0) {
          cell.stringFormat.alignment = PdfTextAlignment.right;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 0, left: 5, right: 15, top: 5);
        cell.style.backgroundBrush = PdfBrushes.white;
        cell.style.font = contentFontBold;
      }
    }
    return grid;
  }

  //Create and row for the grid.
  static void addProducts(String productName, double price, double quantity,
      double total, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();

    row.cells[0].value = productName;
    row.cells[1].value = price.toStringAsFixed(2) + " ";
    row.cells[2].value = quantity.toStringAsFixed(2);
    row.cells[3].value = total.toStringAsFixed(2) + " €";
  }

  static void addTots(String TotName, double total, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = TotName;
    row.cells[1].value = total.toStringAsFixed(2) + " €";
  }

  static void addTotsHT_TVA(String TotName, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = TotName;
  }

  //Get the total amount.
  static double getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
          grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += double.parse(value);
    }
    return total;
  }
}
