import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:TrocWeb_BackOff/Tools/Etablissement.dart';
import 'package:TrocWeb_BackOff/Tools/Inventaire.dart';
import 'package:TrocWeb_BackOff/widgets/Agence/A_Affaires.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class A_Calendrier extends StatefulWidget {
  @override
  _A_CalendrierState createState() => _A_CalendrierState();
}

class _A_CalendrierState extends State<A_Calendrier> {
  final String title = "";

  String? _subjectText = '',
  _startTimeText = '',
  _endTimeText = '',
  _dateText = '',
  _timeDetails = '';
  Color? _headerColor, _viewHeaderColor, _calendarColor;

  Future Reload() async {
    setState(() {

    });

  }

  void initLib() async {
    await Reload();
  }

  @override
  void initState() {
    print("initState");
//    initLib();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    print ("DbTools.gUtilisateurLogin.Role ${DbTools.gUtilisateurLogin.Role }");

    return Scaffold(
        body:

        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
          DbTools.gUtilisateurLogin.Role != "Plateforme" ? Container() : DD_Etabs(),

          Expanded(child: SfCalendar(
            firstDayOfWeek: 1,
            view: CalendarView.month,
            dataSource: MeetingDataSource(_getDataSource()),
            monthViewSettings: const MonthViewSettings(appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),


            onTap: calendarTapped,

          )),


        ],)



    );
  }

  Widget buildDropDownRowEtab(Etablissement etablissement) {
    return Text(etablissement.Libelle);
  }


  @override
  Widget DD_Etabs() {
    print(
        ">>>>>>>> DbTools.ListEtablissementAll.length ${DbTools.ListEtablissementAll.length}");

    print(
        ">>>>>>>> DbTools.ListEtablissementAll[0] ${DbTools.ListEtablissementAll[0].Libelle}");

    print(
        ">>>>>>>> DbTools.selectedEtablissement ${DbTools.selectedEtablissement.Libelle}");

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
            padding:
            const EdgeInsets.only(left: 10.0, right: 5.0, top: 15, bottom: 0),
            child: Text(
              "Etablissement :",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),

        DropDown<Etablissement>(
          items: DbTools.ListEtablissementAll,
          initialValue: DbTools.ListEtablissementAll[DbTools.SelEtabIDi],
          icon: Icon(
            Icons.expand_more,
            color: gColors.secondary,
          ),
          onChanged: (newValue) async {
            Etablissement wEtablissement = newValue!;
            DbTools.SelEtabID = wEtablissement.id;
            DbTools.selectedEtablissement = wEtablissement;
            await DbTools.getInventaires_Calendar(DbTools.SelEtabID);
            print(
            "DD_Etabs selectedEtablissement ${DbTools.selectedEtablissement.Libelle} ${DbTools.selectedEtablissement.IsPT}");

            Reload();
          },
          customWidgets:
          DbTools.ListEtablissementAll.map((z) => buildDropDownRowEtab(z)).toList(),
          isExpanded: false,
        ),
      ],
    );
  }


  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];


    DbTools.ListInventaireCalendar.forEach((element) async {


      print ("element ${element.nom} ${element.DateInv}  ${element.DateDeb}");

      if (element.DateInv.toString() != "") {
        var wDateI = new DateFormat('yyyy-MM-dd hh:mm').parse(element.DateInv);
        var wDatehhmm = DateFormat('HH:mm').format(wDateI);

        print ("DateInv meetings.add ${wDatehhmm} : ${element.nom}  ${wDateI}");


        meetings.add(Meeting("${wDatehhmm} : ${element.nom}", wDateI, wDateI, Color(0xFF006197), false, element ));
      }

      if (element.DateDeb.toString() != "") {
        var wDateD = new DateFormat('yyyy-MM-dd hh:mm').parse(element.DateDeb);
        var wDatehhmm = DateFormat('HH:mm').format(wDateD);

        print ("DateDeb meetings.add ${wDatehhmm} : ${element.nom}  ${wDateD}");


        meetings.add(Meeting("${wDatehhmm} : ${element.nom}", wDateD, wDateD, Color(0xFFb2a600), false, element));
      }


    });


    return meetings;
  }


  void calendarTapped(CalendarTapDetails details) {

    print("calendarTapped");


    if (details.targetElement == CalendarElement.appointment || details.targetElement == CalendarElement.agenda) {


      final Meeting appointmentDetails = details.appointments![0];
      print("calendarTapped B");

      DbTools.gInventaire = appointmentDetails.inventaire;


       Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => A_Inventaire()));

    }
  }

}


class MeetingDataSource extends CalendarDataSource {

  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay, this.inventaire);
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  Inventaire inventaire;
}
