import 'dart:math';

import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/save_file_web.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:flutter/material.dart';

class Excel {
  static Future<void> CrtExcelPat(
      String filepath, int wMonth, int wYear , int EtabId) async {
    final Workbook workbook = Workbook();

    print("filepath ${filepath}");
    DateTime DateDeb = DateTime.now();
    DateTime DateFin = DateTime.now();
    if (wYear >0)
      {
         DateDeb = DateTime(wYear, wMonth, 1);
         DateFin = DateTime(wYear, wMonth + 1, 1);
        DateFin = DateFin.add(Duration(days: -1));
      }


//    await DbTools.ListEtablissementAll.forEach((etab) async {

    int nSheet = 0;

    int tCpt0 = 0;
    int tCpt1 = 0;
    int tCpt2 = 0;
    int tCpt3 = 0;
    int tCpt4 = 0;

    int tMT = 0;
    int tRow = 6;


    Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;
    sheet.name = "TK Debarras";

    for (var etab in DbTools.ListEtablissementAll) {

      if (EtabId >= 0 && etab.id != EtabId)
        continue;


      if (etab.IsNewCT == 1) {
        print("Etab ${etab.id} ${etab.Libelle}");

        await DbTools.getInventairesEtabID_NewCT(etab.id);

        print("Etab A");
        int cpt = 0;
        DbTools.ListInventaire.forEach((inv) {
          if (inv.AffDem != 99) {
            cpt++;
          }
        });

        print("Etab B ${nSheet}");


        //********************************
        //********************************
        //********************************

        sheet.enableSheetCalculations();

        sheet.getRangeByName('A1').setText('Tk Débarras');
        sheet
            .getRangeByName('A2')
            .setText('Liste Affaires : Commission 50/100');
        sheet.getRangeByName('A3').setText('Période : ${wMonth}/${wYear}');
        sheet.getRangeByName('L1').setText(
            'Date : ${DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.now())}');
        sheet.getRangeByName('L1').cellStyle.hAlign =
            HAlignType.right;

        sheet.getRangeByName('A1:J1').merge();
        sheet.getRangeByName('A2:J2').merge();
        sheet.getRangeByName('A3:J3').merge();


        sheet.getRangeByName('A5').setText('Etablissement');
        sheet.getRangeByName('B5').setText('Non lu');
        sheet.getRangeByName('C5').setText('Reffusé');
        sheet.getRangeByName('D5').setText('Acc. 1€');
        sheet.getRangeByName('E5').setText('Acc. 50€');
        sheet.getRangeByName('F5').setText('Acc. 100€');
        sheet.getRangeByName('G5').setText('Comm. HT');
        sheet.getRangeByName('H5').setText('Comm. TTC');

        sheet.getRangeByName('A1:T5').cellStyle.bold = true;
        sheet.getRangeByName('A1:T5').columnWidth = 15;



        sheet.getRangeByName('A1:T100').cellStyle.fontSize = 14;


        sheet.getRangeByName('A1:T5').columnWidth = 15;
        sheet.getRangeByName('A1').columnWidth = 30;
        sheet.getRangeByName('B1:F1').columnWidth = 12;


        workbook.worksheets.add();
        nSheet++;


//        if (cpt > 0)
        {
          Worksheet sheet = workbook.worksheets[nSheet];
          sheet.showGridlines = true;
          sheet.name = etab.Libelle;

          //********************************
          //********************************
          //********************************

          sheet.enableSheetCalculations();

          sheet.getRangeByName('A1').setText('[${etab.id}] Tk Débarras ${etab.Libelle}');
          sheet
              .getRangeByName('A2')
              .setText('Liste Affaires : Commission 50/100');
          sheet.getRangeByName('A3').setText('Période : ${wMonth}/${wYear}');
          sheet.getRangeByName('L1').setText(
              'Date : ${DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.now())}');
          sheet.getRangeByName('L1').cellStyle.hAlign =
              HAlignType.right;


          sheet.getRangeByName('A1:J1').merge();
          sheet.getRangeByName('A2:J2').merge();
          sheet.getRangeByName('A3:J3').merge();

          sheet.getRangeByName('A5').setText('N°');
          sheet.getRangeByName('B5').setText('Création');
          sheet.getRangeByName('C5').setText('Acceptation');
          sheet.getRangeByName('D5').setText('Nom');
          sheet.getRangeByName('E5').setText('Ville');
          sheet.getRangeByName('F5').setText('Non lu');
          sheet.getRangeByName('G5').setText('Reffusé');
          sheet.getRangeByName('H5').setText('Acc. 1€');
          sheet.getRangeByName('I5').setText('Acc. 50€');
          sheet.getRangeByName('J5').setText('Acc. 100€');
          sheet.getRangeByName('K5').setText('Comm. HT');
          sheet.getRangeByName('L5').setText('Comm. TTC');

          sheet.getRangeByName('A1:T5').cellStyle.bold = true;

          sheet.getRangeByName('A1:T5').columnWidth = 15;

          sheet.getRangeByName('D1:E1').columnWidth = 30;
          sheet.getRangeByName('F1:J1').columnWidth =          sheet.getRangeByName('A1').columnWidth = 9;
          sheet.getRangeByName('B1').columnWidth = 11;
          sheet.getRangeByName('C1').columnWidth = 18;
          12;

          //********************************
          //********************************
          //********************************

          int Cpt0 = 0;
          int Cpt1 = 0;
          int Cpt2 = 0;
          int Cpt3 = 0;
          int Cpt4 = 0;

          int MT = 0;

          int wRow = 6;


          DbTools.ListInventaire.forEach((inv) {
            //if (inv.AffDem != 99)
            {
              DateTime wdt = DateTime.parse(inv.Date_Accept_Date);
              DateTime DateCrt = DateTime.parse(inv.DateCrt);
              if (wYear < 0 || wdt.isAfter(DateDeb) && wdt.isBefore(DateFin))
              {
                print(
                    "inv  IIIIIFFFFF ${inv.AffDem} ${inv.AffAccept} ${inv.NomReduit} ${inv.Date_Accept_Date} ");

                Cpt0 += inv.AffAccept == 0 ? 1 : 0;
                Cpt1 += inv.AffAccept == 1 ? 1 : 0;
                Cpt2 += inv.AffAccept == 2 ? 1 : 0;
                Cpt3 += inv.AffAccept == 3 ? 1 : 0;
                Cpt4 += inv.AffAccept == 4 ? 1 : 0;

                int MTL = 0;

                MTL += inv.AffAccept == 2 ? 1 : 0;
                MTL += inv.AffAccept == 3 ? 50 : 0;
                MTL += inv.AffAccept == 4 ? 100 : 0;

                MT += MTL;

                double MTL_TTC = MTL * 1.2;

                sheet.getRangeByName('A${wRow}').setValue(inv.id);
                sheet
                    .getRangeByName('B${wRow}')
                    .setText("${DateFormat('dd/MM/yyyy').format(DateCrt)}");
                sheet
                    .getRangeByName('C${wRow}')
                    .setText("${DateFormat('dd/MM/yyyy  kk:mm').format(wdt)}");

                sheet.getRangeByName('D${wRow}').setText("${inv.nom}");
                sheet.getRangeByName('E${wRow}').setText("${inv.ville}");

                sheet
                    .getRangeByName('F${wRow}')
                    .setText("${inv.AffAccept == 0 ? 'X' : ''}");

                sheet
                    .getRangeByName('G${wRow}')
                    .setText("${inv.AffAccept == 1 ? 'X' : ''}");
                sheet
                    .getRangeByName('H${wRow}')
                    .setText("${inv.AffAccept == 2 ? 'X' : ''}");
                sheet
                    .getRangeByName('I${wRow}')
                    .setText("${inv.AffAccept == 3 ? 'X' : ''}");
                sheet
                    .getRangeByName('J${wRow}')
                    .setText("${inv.AffAccept == 4 ? 'X' : ''}");

                sheet.getRangeByName('K${wRow}').setValue(MTL);
                sheet.getRangeByName('L${wRow}').setValue(MTL_TTC);

//                  sheet.getRangeByName('M${wRow}').setValue(inv.AffDem);
                //                sheet.getRangeByName('N${wRow}').setValue(inv.AffAccept);

                wRow++;
              }
            }
          });

          tCpt0 += Cpt0;
          tCpt1 += Cpt1;
          tCpt2 += Cpt2;
          tCpt3 += Cpt3;
          tCpt4 += Cpt4;
          tMT   += MT;

          double MT_TTC = MT * 1.2;

           sheet = workbook.worksheets[0];


          sheet.getRangeByName('A${tRow}').setText(etab.Libelle);
          sheet.getRangeByName('B${tRow}').setValue(Cpt0);
          sheet.getRangeByName('C${tRow}').setValue(Cpt1);
          sheet.getRangeByName('D${tRow}').setValue(Cpt2);
          sheet.getRangeByName('E${tRow}').setValue(Cpt3);
          sheet.getRangeByName('F${tRow}').setValue(Cpt4);
          sheet.getRangeByName('G${tRow}').setValue(MT);
          sheet.getRangeByName('H${tRow}').setValue(MT_TTC);

          tRow++;

           sheet = workbook.worksheets[nSheet];

          sheet.getRangeByName('E${wRow}').setText("Total");

          sheet.getRangeByName('F${wRow}').setValue(Cpt0);
          sheet.getRangeByName('G${wRow}').setValue(Cpt1);
          sheet.getRangeByName('H${wRow}').setValue(Cpt2);
          sheet.getRangeByName('I${wRow}').setValue(Cpt3);
          sheet.getRangeByName('J${wRow}').setValue(Cpt4);

          sheet.getRangeByName('K${wRow}').setValue(MT);
          sheet.getRangeByName('L${wRow}').setValue(MT_TTC);

          print("Etab C ${workbook.worksheets.count}");

          sheet.getRangeByName('B5:C${wRow}').cellStyle.hAlign =
              HAlignType.center;
          sheet.getRangeByName('F5:J${wRow}').cellStyle.hAlign =
              HAlignType.center;

          sheet.getRangeByName('K5:L${wRow}').cellStyle.hAlign =
              HAlignType.right;


          sheet.getRangeByName('K5:L${wRow}').numberFormat = "0.00";


          sheet.getRangeByName('A1:T${wRow}').cellStyle.fontSize = 14;

          sheet.getRangeByName('E${wRow}:T${wRow}').cellStyle.bold = true;

          sheet.getRangeByName('A5:l${wRow}').cellStyle.borders.all.lineStyle = LineStyle.thin;


        }
      }
    }


    double MT_TTC = tMT * 1.2;

    sheet = workbook.worksheets[0];

    sheet.getRangeByName('A${tRow}').setText("Total");
    sheet.getRangeByName('B${tRow}').setValue(tCpt0);
    sheet.getRangeByName('C${tRow}').setValue(tCpt1);
    sheet.getRangeByName('D${tRow}').setValue(tCpt2);
    sheet.getRangeByName('E${tRow}').setValue(tCpt3);
    sheet.getRangeByName('F${tRow}').setValue(tCpt4);
    sheet.getRangeByName('G${tRow}').setValue(tMT);
    sheet.getRangeByName('H${tRow}').setValue(MT_TTC);


    tRow++;

    sheet.getRangeByName('C${tRow}').setText("Total Mt");

    sheet.getRangeByName('D${tRow}').setValue(tCpt2);
    sheet.getRangeByName('E${tRow}').setValue(tCpt3*50);
    sheet.getRangeByName('F${tRow}').setValue(tCpt4*100);

    sheet.getRangeByName('B5:L${tRow}').cellStyle.hAlign = HAlignType.right;
    sheet.getRangeByName('G6:L${tRow}').numberFormat = "0.00";
    sheet.getRangeByName('A${tRow-1}:H${tRow}').cellStyle.bold = true;

    sheet.getRangeByName('A5:H${tRow}').cellStyle.borders.all.lineStyle = LineStyle.thin;




    //********************************
    //********************************
    //********************************

    //          workbook.worksheets.add();
    //        nSheet++;




    print("workbook FIN $filepath");

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    await FileSaveHelper.saveAndLaunchFile(bytes, filepath);





    return;


  }
}
