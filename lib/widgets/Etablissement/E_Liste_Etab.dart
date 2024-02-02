import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/Etablissement.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:TrocWeb_BackOff/widgets/Etablissement/E_Etab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class E_Liste_Etab extends StatefulWidget {
  @override
  E_Liste_EtabState createState() => E_Liste_EtabState();
}

class E_Liste_EtabState extends State<E_Liste_Etab> {
  static List<Etablissement> lEtablissement = [];

  late EtablissementDataSource etablissementDataSource;
  double textSize = 14.0;

  TextEditingController ctrlFilter = new TextEditingController();
  String filterText = '';

  int Status_id = 99;
  String radioButtonItem = 'Actifs';
  int CountTot = 0;
  int CountSel = 0;
  int SelCol = -1;
  int SelID = -1;

  bool onCellTap = false;

  void Reload() async {
    await DbTools.getEtablissements();

    Filtre();
    print("Reload lenght ${lEtablissement.length}");
    CountTot = CountSel = lEtablissement.length;
    setState(() {});
  }

  void Filtre() {
    lEtablissement.clear();
    lEtablissement.addAll(DbTools.ListEtablissement);

    CountSel = lEtablissement.length;

    setState(() {});
  }

  void initLib() async {
    Reload();
  }

  void initState() {
    super.initState();
    initLib();
    ctrlFilter.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: gColors.secondary,
          title: Container(
            color: gColors.secondary,
            child: Text("Trokeur débarras : Etablissements",
                style: TextStyle(
                  color: gColors.white,
                  fontSize: 14,
                )),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(),
                ),
                Container(
                  width: 2,
                ),
                Text("$CountSel / $CountTot"),
                Container(
                  width: 10,
                ),
              ],
            ),
            Container(
              height: 10,
            ),
            Expanded(
              child: EtablissementGridWidget(),
            ),
          ],
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add),
            backgroundColor: gColors.primary,
            onPressed: () async {

              DbTools.gEtablissement = Etablissement(-1, "", "", "", "", "", "", "", "", "", "","", "","", "","", 0,0,"",0,0,0,"","","","","","","","", "","","", 90,"");
              print("add ${DbTools.gEtablissement.id}");

              await Navigator.push(context, MaterialPageRoute(builder: (context) => E_Etab()));
              Reload();
            })
    );
  }

  Widget EdtFilterWidget() {
    return TextField(
      onChanged: (text) {
        filterText = text;

        Filtre();
      },
      controller: ctrlFilter,
      decoration: InputDecoration(
        icon: Icon(Icons.chevron_right),
        labelText: 'Filtre',
        suffixIcon: IconButton(
          onPressed: () {
            ctrlFilter.clear();
            filterText = "";
            Filtre();
          },
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }

  Widget EtablissementGridWidget() {
    etablissementDataSource = EtablissementDataSource(lEtablissement);
    print("lEtablissement lenght ${lEtablissement.length}");

    return (lEtablissement.length == 0)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                SpinKitThreeBounce(
                  color: gColors.primary,
                  size: 100.0,
                ),
                Container(
                  height: 10,
                ),
                Text(
                  "Liste vide ...",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ])
        : SfDataGridTheme(
            data: SfDataGridThemeData(
              headerColor: gColors.primary,
            ),
            child: Center(
              child: Container(
//            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: SfDataGrid(
                  isScrollbarAlwaysShown: true,
                  source: etablissementDataSource,
                  frozenColumnsCount: 1,
//              frozenRowsCount: 1,
                  onQueryRowHeight: (details) {
                    return details.rowIndex == 0 ? 40.0 : 40.0;
                  },
                  allowSorting: true,
                  allowMultiColumnSorting: true,
                  allowTriStateSorting: true,
                  showSortNumbers: true,
                  columnWidthMode: ColumnWidthMode.auto,
                  columns: <GridColumn>[
                    GridColumn(
                      columnName: 'CID',
                      visible: false,
                      label: Container(),
                    ),
                    GridColumn(
                        columnName: 'ID',
                        columnWidthMode: ColumnWidthMode.lastColumnFill,
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Id',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'NAME',
                        columnWidthMode: ColumnWidthMode.lastColumnFill,
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Nom',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'CP',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  CP',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'VILLE',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Ville',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                  ],
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  selectionMode: SelectionMode.single,
                  navigationMode: GridNavigationMode.cell,

                  onSelectionChanged:
                      (List<Object> addedRows, List<Object> removedRows) async {
                    DataGridRow selDataGridRow =
                        (addedRows.last as DataGridRow);

                    SelCol = -1;
                    onCellTap = false;

                    DbTools.gEtablissement =
                        lEtablissement[selDataGridRow.getCells()[0].value];

                    print("onSelectionChanged ${DbTools.gEtablissement.id}");
                    SelID = DbTools.gEtablissement.id;
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => E_Etab()));
                    Reload();
                  },
                  onCurrentCellActivated: (RowColumnIndex currentRowColumnIndex,
                      RowColumnIndex previousRowColumnIndex) async {
                    print("onCurrentCellActivated ${SelCol}");
                    SelCol = currentRowColumnIndex.columnIndex;
                    if (!onCellTap &&
                        currentRowColumnIndex.rowIndex ==
                            previousRowColumnIndex.rowIndex) {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => E_Etab()));
                      Reload();
                    }
                    onCellTap = false;
                  },

                  onCellTap: (DataGridCellTapDetails details) async {
                    print(
                        "onCellTap ${SelCol} ${SelID} ${DbTools.gEtablissement.id} $details");
                    if (SelCol != -1 && SelID == DbTools.gEtablissement.id) {
                      onCellTap = true;
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => E_Etab()));
                      Reload();
                    }
                  },
                ),
              ),
            ),
          );
  }
}

class EtablissementDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  int i = 0;

  EtablissementDataSource(List<Etablissement> Etablissements) {
    dataGridRows =
        Etablissements.map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'CID', value: i++),
              DataGridCell<int>(columnName: 'ID', value: dataGridRow.id),
              DataGridCell<String>(
                  columnName: 'NAME', value: dataGridRow.Libelle),
              DataGridCell<String>(columnName: 'CP', value: dataGridRow.cp),
              DataGridCell<String>(
                  columnName: 'VILLE', value: dataGridRow.ville),
            ])).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    var P = 0.0;

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          ));
    }).toList());
  }
}
