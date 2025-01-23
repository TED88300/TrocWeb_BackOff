

import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

//*************************************
//*************************************
//*************************************

class PieAgPl extends StatelessWidget {

  static List<PieData> pieData = [
    PieData('Agence\n55%', "pd1", 55),
    PieData('Plateforme\n45%', "pd2", 45),

  ];
  static String wTitle = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            SfCircularChart(
                title: ChartTitle(text: wTitle,
                    textStyle : TextStyle(color: Colors.blue, fontSize: 16),
                ),
                legend: Legend(isVisible: false),
                series: <PieSeries<PieData, String>>[
                  PieSeries<PieData, String>(
                      explode: true,
                      explodeIndex: 0,
                      dataSource: pieData,
                      xValueMapper: (PieData data, _) => data.xData,
                      yValueMapper: (PieData data, _) => data.yData,
                      dataLabelMapper: (PieData data, _) => data.text,
                      dataLabelSettings: DataLabelSettings(isVisible: true)),
                ]
            )


          ],
        ));
  }
}

class PieData {
  PieData(this.text,this.xData, this.yData, );
   String text;
   String xData;
   int yData;
}

//*************************************
//*************************************
//*************************************



class chartDate extends StatelessWidget {

  static String wTitle = "";
  final List<ChartData> chartData = [
    ChartData(DateTime(2022, 5, 1), 35),
    ChartData(DateTime(2022, 5, 3), 31),
    ChartData(DateTime(2022, 5, 5), 34),
    ChartData(DateTime(2022, 5, 26), 32),
    ChartData(DateTime(2022, 5, 27), 38),
    ChartData(DateTime(2022, 6, 1), 135),
    ChartData(DateTime(2022, 6, 6), 131),
    ChartData(DateTime(2022, 6, 10), 134),
    ChartData(DateTime(2022, 6, 16), 132),
    ChartData(DateTime(2022, 6, 27), 138),
  ];

  final List<ChartData> chartData2 = [
    ChartData(DateTime(2022, 5, 1), 135),
    ChartData(DateTime(2022, 5, 6), 131),
    ChartData(DateTime(2022, 5, 10), 134),
    ChartData(DateTime(2022, 5, 16), 132),
    ChartData(DateTime(2022, 5, 27), 138),
    ChartData(DateTime(2022, 6, 1), 35),
    ChartData(DateTime(2022, 6, 3), 31),
    ChartData(DateTime(2022, 6, 5), 34),
    ChartData(DateTime(2022, 6, 26), 32),
    ChartData(DateTime(2022, 6, 27), 38),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
/*
                child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(
//                      interval: 1,
                        labelRotation : -45,
                        dateFormat: DateFormat('dd/MM/yy'),
                    ),

                    title: ChartTitle(text: wTitle,
                      textStyle : TextStyle(color: Colors.blue, fontSize: 16),
                    ),

                    series: <ChartSeries<ChartData, DateTime>>[
                      // Renders line chart
                      SplineSeries<ChartData, DateTime>(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          xAxisName : "Date",
                        yAxisName : "Val",
                        ),

                      SplineSeries<ChartData, DateTime>(
                          dataSource: chartData2,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                        xAxisName : "Date",
                        yAxisName : "Resp",
                      )
                    ]
                )
*/
            )
        )
    );
  }


}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
