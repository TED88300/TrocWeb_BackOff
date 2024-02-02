import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/Inventaire.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:TrocWeb_BackOff/widgets/Agence/A_Affaires.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Liste_Inventaire extends StatefulWidget {
  @override
  Liste_InventaireState createState() => Liste_InventaireState();
}

class Liste_InventaireState extends State<Liste_Inventaire> {
  late InventaireDataSource inventaireDataSource;
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

    await DbTools.getActions();

    if (DbTools.gEtablissement.IsPT == 0 && DbTools.gEtablissement.IsNewCT == 1)
    {
      await DbTools.getInventairesNewCT();
    }
else
    {
      await DbTools.getInventaires();
    }


    Filtre();
    print("Reload lenght ${DbTools.lInventaire.length}");
    CountTot = CountSel = DbTools.lInventaire.length;
    setState(() {});

  }

  void Filtre() {

    if (filterText.isEmpty && Status_id == 99) {
      print("A");
      DbTools.lInventaire.clear();
      DbTools.ListInventaire.forEach((element) async {
        int Stat = element.Status;
        if (Stat != 7 && Stat != 8) DbTools.lInventaire.add(element);
      });
    } else if (filterText.isEmpty) {
      print("B");
      DbTools.lInventaire.clear();
      DbTools.ListInventaire.forEach((element) async {
        int Stat = element.Status;
        if (Stat == Status_id) DbTools.lInventaire.add(element);
      });
    } else if (Status_id == 99) {
      print("C");
      DbTools.lInventaire.clear();
      DbTools.ListInventaire.forEach((element) async {
        int Stat = element.Status;
        if (Stat != 7 && Stat != 8)
        {
          String nom = element.nom == null ? "" : element.nom;
          String adresse1 = element.adresse1 == null ? "" : element.adresse1;
          String adresse2 = element.adresse2 == null ? "" : element.adresse2;
          String cp = element.cp == null ? "" : element.cp;
          String ville = element.ville == null ? "" : element.ville;
          String id = element.id.toString();
          if (nom.toUpperCase().contains(filterText.toUpperCase()))
            DbTools.lInventaire.add(element);
          else if (adresse1.toUpperCase().contains(filterText.toUpperCase()))
            DbTools.lInventaire.add(element);
          else if (adresse2.toUpperCase().contains(filterText.toUpperCase()))
            DbTools.lInventaire.add(element);
          else if (cp.toUpperCase().contains(filterText.toUpperCase()))
            DbTools.lInventaire.add(element);
          else if (ville.toUpperCase().contains(filterText.toUpperCase()))
            DbTools.lInventaire.add(element);
          else if (id.toUpperCase().contains(filterText.toUpperCase()))
            DbTools.lInventaire.add(element);
        }
      });
    } else {
      print("D $Status_id");
      DbTools.lInventaire.clear();
      DbTools.ListInventaire.forEach((element) async {


        int Stat = element.Status;
        if (Stat == Status_id) {
          String nom = element.nom == null ? "" : element.nom;
          String adresse1 = element.adresse1 == null ? "" : element.adresse1;
          String adresse2 = element.adresse2 == null ? "" : element.adresse2;
          String cp = element.cp == null ? "" : element.cp;
          String ville = element.ville == null ? "" : element.ville;
          String id = element.id.toString();
          if (nom.toUpperCase().contains(filterText.toUpperCase()))
            DbTools.lInventaire.add(element);
          else if (adresse1.toUpperCase().contains(filterText.toUpperCase()))
            DbTools.lInventaire.add(element);
          else if (adresse2.toUpperCase().contains(filterText.toUpperCase()))
            DbTools.lInventaire.add(element);
          else if (cp.toUpperCase().contains(filterText.toUpperCase()))
            DbTools.lInventaire.add(element);
          else if (ville.toUpperCase().contains(filterText.toUpperCase()))
            DbTools.lInventaire.add(element);
          else if (id.toUpperCase().contains(filterText.toUpperCase()))
            DbTools.lInventaire.add(element);
        }
      });
    }
    CountSel = DbTools.lInventaire.length;

    print("FILTRE FIN");

    setState(() {});
  }

  void initLib() async {
    DbTools.selectedEtablissement = DbTools.gEtablissement;

    Reload();
  }

  void initState() {
    super.initState();
    initLib();
    ctrlFilter.text = "";
    print("initState FIN");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 2,
                ),
                Expanded(
                  child: statusFilterWidget(),
                ),
                Container(
                  width: 25,
                ),
                Text("$CountSel / $CountTot"),
                Container(
                  width: 25,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 2,
                ),
                Expanded(
                  child: EdtFilterWidget(),
                ),
                Container(
                  width: 25,
                ),
              ],
            ),
            Expanded(
              child: InventaireGridWidget(),
            ),
          ],
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add),
            backgroundColor: gColors.primary,
            onPressed: () async {
              await DbTools.addInventaires();
              print("addInventaires ${DbTools.gLastID}");


              SelCol = -1;
              onCellTap = false;

              await DbTools.getInventaire(DbTools.gLastID);
              print("onSelectionChanged ${DbTools.gInventaire.id}");
              SelID = DbTools.gInventaire.id;


              await Navigator.push(context, MaterialPageRoute(builder: (context) => A_Inventaire()));
              Reload();



/*
              await DbTools.getInventaires();
              DbTools.lInventaire.clear();
              DbTools.lInventaire.addAll(DbTools.ListInventaire);
              print("DbTools.lInventaire lenght ${DbTools.lInventaire.length}");
              CountTot = CountSel = DbTools.lInventaire.length;
*/

//              gLastID


              setState(() {});
            }));
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

  Widget statusFilterText(int St) {
    return Container(
//      width: 90,
      padding: const EdgeInsets.fromLTRB(2,2,2,2),
      color: DbTools.StatusColorArray[St],
      child: Text(
        DbTools.LibStatus(St),
        style: new TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget statusFilterWidget() {
    return Row(
//      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 99,
          groupValue: Status_id,
          onChanged: (val) {
            setState(() {
              radioButtonItem = 'Actifs';
              Status_id = 99;
              Filtre();
            });
          },
        ),
        Container(
          width: 100,
          child: Text(
            'Actifs',
            style: new TextStyle(fontSize: textSize,fontWeight: FontWeight.bold),
          ),
        ),
        Radio(
          value: 0,
          groupValue: Status_id,
          onChanged: (val) {
            setState(() {
              radioButtonItem = DbTools.LibStatus(0);
              Status_id = 0;
              Filtre();
            });
          },
        ),
        statusFilterText(0),
        Radio(
          value: 1,
          groupValue: Status_id,
          onChanged: (val) {
            setState(() {
              radioButtonItem = DbTools.LibStatus(1);
              Status_id = 1;
              Filtre();
            });
          },
        ),
        statusFilterText(1),
        Radio(
          value: 2,
          groupValue: Status_id,
          onChanged: (val) {
            setState(() {
              radioButtonItem = DbTools.LibStatus(2);
              Status_id = 2;
              Filtre();
            });
          },
        ),
        statusFilterText(2),
        Radio(
          value: 3,
          groupValue: Status_id,
          onChanged: (val) {
            setState(() {
              radioButtonItem = DbTools.LibStatus(3);
              Status_id = 3;
              Filtre();
            });
          },
        ),
        statusFilterText(3),
        Radio(
          value: 4,
          groupValue: Status_id,
          onChanged: (val) {
            setState(() {
              radioButtonItem = DbTools.LibStatus(4);
              Status_id = 4;
              Filtre();
            });
          },
        ),
        statusFilterText(4),
        Radio(
          value: 5,
          groupValue: Status_id,
          onChanged: (val) {
            setState(() {
              radioButtonItem = DbTools.LibStatus(5);
              Status_id = 5;
              Filtre();
            });
          },
        ),
        statusFilterText(5),
        Radio(
          value: 6,
          groupValue: Status_id,
          onChanged: (val) {
            setState(() {
              radioButtonItem = DbTools.LibStatus(6);
              Status_id = 6;
              Filtre();
            });
          },
        ),
        statusFilterText(6),
        Radio(
          value: 7,
          groupValue: Status_id,
          onChanged: (val) {
            setState(() {
              radioButtonItem = DbTools.LibStatus(7);
              Status_id = 7;
              Filtre();
            });
          },
        ),
        statusFilterText(7),
        Radio(
          value: 8,
          groupValue: Status_id,
          onChanged: (val) {
            setState(() {
              radioButtonItem = DbTools.LibStatus(7);
              Status_id = 8;
              Filtre();
            });
          },
        ),
        statusFilterText(8),
      ],
    );
  }

  Widget InventaireGridWidget() {
    inventaireDataSource = InventaireDataSource(DbTools.lInventaire);
    print("DbTools.lInventaire lenght ${DbTools.lInventaire.length}");

    return (DbTools.lInventaire.length == 0)
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
                  source: inventaireDataSource,
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
                        columnName: 'OR',

                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Origine',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'NAME',

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
                        columnName: 'DATE',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Date',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'ADR1',
                        columnWidthMode: ColumnWidthMode.lastColumnFill,
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Adresse',
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
                    GridColumn(
                        columnName: 'STATUS',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              '  Statuts',
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

                    DbTools.gInventaire =
                        DbTools.lInventaire[selDataGridRow.getCells()[0].value];

                    print("onSelectionChanged ${DbTools.gInventaire.id}");
                    SelID = DbTools.gInventaire.id;
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => A_Inventaire()));
                    Reload();
                  },
                  onCurrentCellActivated: (RowColumnIndex currentRowColumnIndex,
                      RowColumnIndex previousRowColumnIndex) async {
//                    print("onCurrentCellActivated ${SelCol}");
                    SelCol = currentRowColumnIndex.columnIndex;
                    if (!onCellTap &&
                        currentRowColumnIndex.rowIndex ==
                            previousRowColumnIndex.rowIndex) {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => A_Inventaire()));
                      Reload();
                    }
                    onCellTap = false;
                  },

                  onCellTap: (DataGridCellTapDetails details) async {
                    print(
                        "onCellTap ${SelCol} ${SelID} ${DbTools.gInventaire.id} $details");
                    if (SelCol != -1 && SelID == DbTools.gInventaire.id) {
                      onCellTap = true;
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => A_Inventaire()));
                      Reload();
                    }
                  },
                ),
              ),
            ),
          );
  }
}

class InventaireDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  int i = 0;

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
  int iCol = 0;

  if (sortColumn.name == "ID") iCol = 1;
  if (sortColumn.name == "OR") iCol = 2;
  if (sortColumn.name == "NAME") iCol = 3;
  if (sortColumn.name == "DATE") iCol = 4;
  if (sortColumn.name == "ADR1") iCol = 5;
  if (sortColumn.name == "CP") iCol = 6;
  if (sortColumn.name == "VILLE") iCol = 7;
  if (sortColumn.name == "STATUS") iCol = 8;

  print("print Col $iCol");



  if (iCol == 0) {
  return 0;
  }
  int wret = 0;

  if (iCol == 1) {
  int value1 = 0;
  int value2 = 0;
  if (sortColumn.sortDirection == DataGridSortDirection.ascending) {
  value1 = a!.getCells()[iCol].value;
  value2 = b!.getCells()[iCol].value;
  } else {
  value1 = b!.getCells()[iCol].value;
  value2 = a!.getCells()[iCol].value;
  }
  if (value1 > value2)
  wret = 1;
  else if (value1 < value2)
  wret = -1;
  else
  wret = 0;
  return wret;
  }


  String value1 = a!.getCells()[iCol].value.toString().trim().toUpperCase();
  String value2 = b!.getCells()[iCol].value.toString().trim().toUpperCase();

  if (sortColumn.sortDirection == DataGridSortDirection.descending) {
  value1 = b.getCells()[iCol].value.toString().trim().toUpperCase();
  value2 = a.getCells()[iCol].value.toString().trim().toUpperCase();
  }

  if (iCol == 4) {
  value1 = value1.substring(6, 10) +"/" + value1.substring(3, 5) +"/" + value1.substring(0, 2);
  value2 = value2.substring(6, 10) +"/" + value2.substring(3, 5) +"/" + value2.substring(0, 2);
  }

  print("value ${value1} ${value2}");

  int? aLength = value1.length;
  int? bLength = value2.length;

  if (aLength == null || bLength == null) {
  print("null");
  return 0;
  }

  if (value1.compareTo(value2) > 0) {
  wret = 1;
  } else if (value1.compareTo(value2) < 0) {
  wret = -1;
  } else {
  wret = 0;
  }

  print("wret ${wret}");

  return wret;
  }

  InventaireDataSource(List<Inventaire> Inventaires) {
    print("InventaireDataSource selectedEtablissement ${DbTools.selectedEtablissement.Libelle} ${DbTools.selectedEtablissement.IsPT}");

    dataGridRows =
        Inventaires.map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'CID', value: i++),
              DataGridCell<int>(columnName: 'ID', value: dataGridRow.id),
              DataGridCell<String>(columnName: 'OR', value: DbTools.getEtablissementsbyInvID(dataGridRow)),
              DataGridCell<String>(columnName: 'NAME', value: "${dataGridRow.nom}"),
              DataGridCell<String>(
                  columnName: 'DATE',
                  value: DateFormat('dd-MM-yyyy')
                      .format(DateTime.parse(dataGridRow.DateCrt))),
              DataGridCell<String>(
                  columnName: 'ADR1', value: dataGridRow.adresse1),
              DataGridCell<String>(columnName: 'CP', value: dataGridRow.cp.toString()),
              DataGridCell<String>(
                  columnName: 'VILLE', value: dataGridRow.ville.toString()),
              DataGridCell<String>(
                  columnName: 'STATUS',
                  value: DbTools.LibStatus(dataGridRow.Status)),
            ])).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    var i = 0;
    int wCID = 0;
    int wSat = 0;

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      Color bColor = Color(0xFFFFFFFF);
      Color tColor = Color(0xFF000000);

      if ((dataGridCell.columnName == 'CID')) {
        wCID = dataGridCell.value;
        wSat = DbTools.lInventaire[wCID].Status;

      }

      if ((dataGridCell.columnName == 'STATUS')) {

        tColor = Color(0xFF000000);
         bColor = DbTools.StatusColorArray[wSat];
      }



      if ((dataGridCell.columnName == 'ID') && DbTools.getEtablissementsbyInvID2_NexCT(DbTools.lInventaire[wCID]) == 1)
      {
        if (DbTools.lInventaire[wCID].AffAccept == 0 && DbTools.lInventaire[wCID].etabid != DbTools.lInventaire[wCID].etabidOrigine)
          {
            bColor = Colors.purple;
            tColor = Color(0xFFFFFFFF);
          }
        else if (DbTools.lInventaire[wCID].AffAccept == 1)
          bColor = Colors.red;
        else if (DbTools.lInventaire[wCID].AffAccept == 2)
          bColor = Colors.orangeAccent;
        else if (DbTools.lInventaire[wCID].AffAccept == 3)
          bColor = Colors.green;
        else if (DbTools.lInventaire[wCID].AffAccept == 4)
          bColor = Colors.greenAccent;
      }




      return Container(
          color: bColor,
          alignment: (dataGridCell.columnName == 'STATUS')
              ? Alignment.center
              : Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: tColor),
          ));
    }).toList());
  }
}
