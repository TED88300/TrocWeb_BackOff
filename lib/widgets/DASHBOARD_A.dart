import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/widgets/Dashboard/data_widget.dart';

import 'package:dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class DASHBOARD_A extends StatefulWidget {
  @override
  _DASHBOARD_AState createState() => _DASHBOARD_AState();
}

class _DASHBOARD_AState extends State<DASHBOARD_A> {
  final ScrollController scrollController = ScrollController();

  late var itemController = DashboardItemController(items: [
    DashboardItem(width: 2, height: 2, identifier: "PieAgPl"),
    DashboardItem(startX: 0, startY: 2, width: 3, height: 2, identifier: "chartDate"),
  ]);

  bool refreshing = false;

  void initLib() async {
    await DbTools.getInventairesActif();

    PieAgPl.pieData.clear();

    int tot = 0;


    DbTools.ListInventaire.forEach((elt_Inv) {
      bool Add = true;
      tot++;
      try {
        PieAgPl.pieData.forEach((elt_Pie) {
          if (elt_Pie.xData == elt_Inv.Origine) {
            Add = false;
            elt_Pie.yData++;
            throw "";
          }
        });
      } catch (e) {}
      if (Add)
        {
          PieAgPl.pieData.add(PieData("", elt_Inv.Origine, 1));
        }
    });


    int wAgt = 0;
    int wPt = 0;
    PieAgPl.pieData.forEach((elt_Pie) {
      if (elt_Pie.xData == "Agence")
        wAgt = elt_Pie.yData;
      else
        wPt += elt_Pie.yData;


      double p = elt_Pie.yData/tot*100;
      elt_Pie.text = "${elt_Pie.xData}\n${p.toStringAsFixed(0)}%";
      print("${elt_Pie.text}");
    });

    double pA = wAgt/tot*100;
    double pP = wPt/tot*100;

    PieAgPl.wTitle = "Affaires Agence / Plateforme\n          ${pA.toStringAsFixed(0)}%   /   ${pP.toStringAsFixed(0)}%";

    setState(() {

    });


//    LineCA.pieData.clear();

    chartDate.wTitle = 'Devis / Facture';




  }

  @override
  void initState() {
    super.initState();

    initLib();
  }

  @override
  Widget build(BuildContext context) {
    return Dashboard(
      slideToTop: false,
      padding: const EdgeInsets.all(8),
      itemStyle: ItemStyle(
        elevation: 10,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      dashboardItemController: itemController,
      itemBuilder: (DashboardItem item) {
        print("item ${item.identifier}");

        switch (item.identifier) {
          case ("PieAgPl"):
            {
              return PieAgPl();
            }

          case ("chartDate"):
            {
              return chartDate();
            }
          default:
            {
              return Container(
                padding: const EdgeInsets.all(8),
                child: Text("${item.identifier}"),
              );
            }
        }
      },
    );
  }
}
