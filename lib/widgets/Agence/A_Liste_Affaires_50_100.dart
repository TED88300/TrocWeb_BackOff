import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/Etablissement.dart';
import 'package:TrocWeb_BackOff/Tools/Inventaire.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:TrocWeb_BackOff/widgets/Agence/A_Dialog_50_100.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class A_Liste_Affaires_50_100 extends StatefulWidget {
  @override
  A_Liste_Affaires_50_100State createState() => A_Liste_Affaires_50_100State();
}

class A_Liste_Affaires_50_100State extends State<A_Liste_Affaires_50_100> {
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
  bool isChecked = false;

  void Reload() async {
    await DbTools.getActions();

    print("DbTools.SelEtabID ${DbTools.SelEtabID}");

    if (DbTools.SelEtabID >= 0) {
      await DbTools.getInventairesNewCT_Encours();
      print("Reload lenght ${DbTools.lInventaire.length}");
      print("Reload lenght ${DbTools.ListInventaire.length}");
      Filtre();
      print("Reload lenght ${DbTools.lInventaire.length}");
      CountTot = CountSel = DbTools.lInventaire.length;
      setState(() {});
    }
  }

  void Filtre() {
    if (filterText.isEmpty && Status_id == 99) {
      print("Filtre A");
      DbTools.lInventaire.clear();
      DbTools.ListInventaire.forEach((element) async {
        DbTools.lInventaire.add(element);
      });
    } else if (filterText.isEmpty) {
      print("B $Status_id");
      DbTools.lInventaire.clear();
      DbTools.ListInventaire.forEach((element) async {
        DbTools.lInventaire.add(element);
      });
    } else if (Status_id == 99) {
      print("C");
      DbTools.lInventaire.clear();
      DbTools.ListInventaire.forEach((element) async {
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
          else if (id.toUpperCase().contains(filterText.toUpperCase())) DbTools.lInventaire.add(element);
        }
      });
    } else {
      print("D $Status_id");
      DbTools.lInventaire.clear();
      DbTools.ListInventaire.forEach((element) async {
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
          else if (id.toUpperCase().contains(filterText.toUpperCase())) DbTools.lInventaire.add(element);
        }
      });
    }
    CountSel = DbTools.lInventaire.length;
    setState(() {});
  }

  void initLib() async {
    print("A_Liste_Affaires_50_100 initLib DbTools.gEtablissement.id ${DbTools.gEtablissement.id}");

    int i = 0;

    DbTools.ListEtablissementAll.forEach((element) async {
      if (element.id == DbTools.gEtablissement.id) {
        DbTools.SelEtabIDi = i;
        DbTools.selectedEtablissement = element;
        DbTools.SelEtabID = element.id;
      }
      i++;
    });

    Reload();
  }

  void initState() {
    filterText = "";
    super.initState();
    initLib();
    ctrlFilter.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.red,
      body: Column(
        children: [
          Container(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: 10,
              ),
              Expanded(
                child: EdtFilterWidget(),
              ),
              Container(
                width: 25,
              ),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => Liste_dialog(context),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: gColors.push,
                  padding: const EdgeInsets.all(12.0),
                ),
                child: Text('Liste', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
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
    );
  }

  Widget Liste_dialog(BuildContext context) {
    return AlertDialog(
      title: Container(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        color: gColors.secondary,
        child: Text(
          "Affaires Nouveaux contrats",
          style: TextStyle(
            color: gColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      content: Container(
        height: 300,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text("Toutes les agences",
                      style: TextStyle(
                        fontSize: 16,
                      )),
                ),
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                    Reload();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: gColors.primary,
          ),
          child: const Text('Annuler', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: gColors.primary,
          ),
          child: const Text('Imprimer', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
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

  Widget statusFilterText(int St) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      color: DbTools.StatusColorArray[St],
      child: Text(
        DbTools.LibStatus(St),
        style: new TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
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
            style: new TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
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

  Widget buildDropDownRowEtab(Etablissement etablissement) {
    return Text(etablissement.Libelle);
  }

  Widget InventaireGridWidget() {
    inventaireDataSource = InventaireDataSource(DbTools.lInventaire);
    print("DbTools.lInventaire lenght ${DbTools.lInventaire.length}");

    return (DbTools.lInventaire.length == 0)
        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
              headerColor: gColors.tks,
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
                              style: TextStyle(fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'AG',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "  Agence",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'OR',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Origine',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: textSize, color: Colors.white),
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
                              style: TextStyle(fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'DATE',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Date',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'COM',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Commission',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'VILLE',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Ville',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: textSize, color: Colors.white),
                            ))),
                    GridColumn(
                        columnName: 'STATUS',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              '  Statuts',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: textSize, color: Colors.white),
                            ))),
                  ],
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  selectionMode: SelectionMode.single,
                  navigationMode: GridNavigationMode.cell,

                  onSelectionChanged: (List<Object> addedRows, List<Object> removedRows) async {
                    DataGridRow selDataGridRow = (addedRows.last as DataGridRow);

                    SelCol = -1;
                    onCellTap = false;

                    DbTools.gInventaire = DbTools.lInventaire[selDataGridRow.getCells()[0].value];

                    print("onSelectionChanged ${DbTools.gInventaire.id}");
                    SelID = DbTools.gInventaire.id;
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => A_Dialog_50_100(false),
                    );
                    Reload();
                  },
                  onCurrentCellActivated: (RowColumnIndex currentRowColumnIndex, RowColumnIndex previousRowColumnIndex) async {
//                    print("onCurrentCellActivated ${SelCol}");
                    SelCol = currentRowColumnIndex.columnIndex;
                    if (!onCellTap && currentRowColumnIndex.rowIndex == previousRowColumnIndex.rowIndex) {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) => A_Dialog_50_100(false),
                      );
                      Reload();
                    }
                    onCellTap = false;
                  },

                  onCellTap: (DataGridCellTapDetails details) async {
                    print("onCellTap ${SelCol} ${SelID} ${DbTools.gInventaire.id} $details");
                    if (SelCol != -1 && SelID == DbTools.gInventaire.id) {
                      onCellTap = true;
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) => A_Dialog_50_100(false),
                      );
                      Reload();
                    }
                  },
                ),
              ),
            ),
          );
  }
}

void ImpNewCT() {}

class InventaireDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  int i = 0;

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    int iCol = 0;

    if (sortColumn.name == "ID") iCol = 1;
    if (sortColumn.name == "AG") iCol = 2;
    if (sortColumn.name == "OR") iCol = 3;
    if (sortColumn.name == "NAME") iCol = 4;
    if (sortColumn.name == "DATE") iCol = 5;

    if (sortColumn.name == "COM") iCol = 7;
    if (sortColumn.name == "VILLE") iCol = 8;
    if (sortColumn.name == "STATUS") iCol = 9;

    if (iCol == 0) {
      print("Col == 0");
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

    if (iCol == 5) {
      value1 = value1.substring(6, 10) + "/" + value1.substring(3, 5) + "/" + value1.substring(0, 2);
      value2 = value2.substring(6, 10) + "/" + value2.substring(3, 5) + "/" + value2.substring(0, 2);
    }

    print("value ${value1} ${value2}");

    int? aLength = value1.length;
    int? bLength = value2.length;

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
    dataGridRows = Inventaires.map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
          DataGridCell<int>(columnName: 'CID', value: i++),
          DataGridCell<int>(columnName: 'ID', value: dataGridRow.id),
          DataGridCell<String>(columnName: 'AG', value: "${DbTools.getEtablissementsbyInvID2(dataGridRow)}"),
          DataGridCell<String>(columnName: 'OR', value: "${DbTools.getEtablissementsbyInvID3(dataGridRow)}"),
          DataGridCell<String>(columnName: 'NAME', value: "${dataGridRow.NomReduit}"),
          DataGridCell<String>(columnName: 'DATE', value: DateFormat('dd-MM-yyyy').format(DateTime.parse(dataGridRow.DateCrt))),
          DataGridCell<String>(
              columnName: 'COM',
              value: dataGridRow.AffDem == 1
                  ? "50€"
                  : dataGridRow.AffDem == 2
                      ? "100€"
                      : "0€"),
          DataGridCell<String>(columnName: 'VILLE', value: dataGridRow.ville),
          DataGridCell<String>(columnName: 'STATUS', value: DbTools.LibStatus(dataGridRow.Status)),
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

      if ((dataGridCell.columnName == 'AG') && DbTools.getEtablissementsbyInvID2_NexCT(DbTools.lInventaire[wCID]) == 1) {
        bColor = Color(0xFFEEEEEE);
        tColor = Color(0xFF000000);
      }

      if ((dataGridCell.columnName == 'ID') && DbTools.getEtablissementsbyInvID2_NexCT(DbTools.lInventaire[wCID]) == 1) {
        if (DbTools.lInventaire[wCID].AffAccept == 0 && DbTools.lInventaire[wCID].etabid != DbTools.lInventaire[wCID].etabidOrigine) {
          bColor = Colors.purple;
          tColor = Color(0xFFFFFFFF);
        } else if (DbTools.lInventaire[wCID].AffAccept == 1)
          bColor = Colors.red;
        else if (DbTools.lInventaire[wCID].AffAccept == 2)
          bColor = Colors.orangeAccent;
        else if (DbTools.lInventaire[wCID].AffAccept == 3)
          bColor = Colors.green;
        else if (DbTools.lInventaire[wCID].AffAccept == 4) bColor = Colors.greenAccent;
      }

      return Container(
          color: bColor,
          alignment: (dataGridCell.columnName == 'STATUS') ? Alignment.center : Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: tColor),
          ));
    }).toList());
  }
}
