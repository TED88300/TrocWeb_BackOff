import 'package:TrocWeb_BackOff/Tools/DbTools.dart';

import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:TrocWeb_BackOff/Tools/shared_Cookies.dart';
import 'package:TrocWeb_BackOff/widgets/3-dashboard.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
//  Login({required Key key, required this.title}) : super(key: key);
  final String title = "";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isChecked = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final KeyIdController = TextEditingController();

  //****************************************
  //****************************************
  //****************************************

  late final FocusNode focus;
  late final FocusAttachment _nodeAttachment;

  bool isShiftPressed = false;
  bool isAltPressed = false;

  List<bool> checkboxStates = List.filled(5, false);

  int lastClicked = -1;

  int wSelAffAdmin = 0;
  bool AffAdmin = false;

  final List<String> itemsEtab = [];
  final List<int> itemsEtabId = [];
  String? selectedValueEtab = "";
  //****************************************
  //****************************************
  //****************************************

  void initLib() async {
    await DbTools.getUtilisateurs();

    await DbTools.getEtablissements();
    selectedValueEtab = "";

    DbTools.ListEtablissement.forEach((element) {
      if (selectedValueEtab == "") selectedValueEtab = element.Libelle;
      print("${element.Libelle} ${element.id}");

      itemsEtab.add("${element.Libelle}");
      itemsEtabId.add(element.id);
    });
  }

  @override
  void initState() {
    super.initState();

    initLib();
    if (DbTools.gTED) {
//      emailController.text = "TED";
//      passwordController.text = "DET*";
      isChecked = true;
    }

    super.initState();
    focus = FocusNode(debugLabel: 'Button');
    _nodeAttachment = focus.attach(context, onKey: (node, event) {
      isShiftPressed = event.isShiftPressed;
      isAltPressed = event.isAltPressed;
      return KeyEventResult.ignored;
    });
    focus.requestFocus();
  }

  @override
  void dispose() {
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _nodeAttachment.reparent();

    return buildLogin();
  }

  Widget buildTedLogin() {
    AffAdmin = (wSelAffAdmin == 14);
    print("buildTedLogin ${AffAdmin} ${wSelAffAdmin}");
    return AffAdmin
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await login("PI 50", "PI50");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: gColors.primary,
                  padding: const EdgeInsets.all(12.0),
                ),
                child: Text('SA', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Container(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await login("TED", "DET*");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: gColors.primary,
                  padding: const EdgeInsets.all(12.0),
                ),
                child: Text('SVP', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Container(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await login("Pierre", "PI50");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: gColors.primary,
                  padding: const EdgeInsets.all(12.0),
                ),
                child: Text('US 35', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Container(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await login("TK MA", "0327");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: gColors.primary,
                  padding: const EdgeInsets.all(12.0),
                ),
                child: Text('TKS+', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Container(
                width: 20,
              ),
            ],
          )
        : Container();
  }

  Widget buildTedLogin2() {
    return AffAdmin
        ? DropdownButtonHideUnderline(
            child: DropdownButton2(
              items: itemsEtab
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          "  ${item}",
                        ),
                      ))
                  .toList(),
              value: selectedValueEtab,
              onChanged: (value) async {
                selectedValueEtab = value as String;
                for (int i = 0; i < itemsEtab.length; i++) {
                  if (itemsEtab[i] == selectedValueEtab) {
                    print("i ${i}");
                    print("id ${itemsEtabId[i]} ${DbTools.ListUtilisateur.length}");

                    for (int j = 0; j < DbTools.ListUtilisateur.length; j++) {
                      print("Motdepasse ${DbTools.ListUtilisateur[j].User} ${DbTools.ListUtilisateur[j].Motdepasse}      ${DbTools.ListUtilisateur[j].id} ${selectedValueEtab}");

                      if (DbTools.ListUtilisateur[j].etabid == itemsEtabId[i]) {
                        print("Motdepasse $j");

                        await login(DbTools.ListUtilisateur[j].User, DbTools.ListUtilisateur[j].Motdepasse);
                      }
                    }
                  }
                }

                ;
              },

              buttonStyleData: const ButtonStyleData(
                height: 30,
                width: 300
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 32,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
              ),


            ),
          )
        : Container();
  }

  Future<void> login(String emailController_text, String passwordController_text) async {
    if (await DbTools.getUtilisateur(emailController_text, passwordController_text)) {
      print("User OK");
      CookieManager cm = CookieManager.getInstance();
      if (isChecked) {
        cm.addToCookie("emailLogin", emailController_text);
        cm.addToCookie("passwordLogin", passwordController_text);
        cm.addToCookie("IsRememberLogin", "X");
      } else {
        cm.addToCookie("emailLogin", "");
        cm.addToCookie("passwordLogin", "");
        cm.addToCookie("IsRememberLogin", "");
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashboardWidget()));
    }
  }

  Widget buildLogin() {
    final email = TextField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Utilisateur',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final password = TextField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Mot de passe',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final loginButton = Container(
      width: MediaQuery.of(context).size.width / 2.5,
      child: ElevatedButton(
        onPressed: () async {
          wSelAffAdmin = 0;
          await login(emailController.text, passwordController.text);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: gColors.primary,
          padding: const EdgeInsets.all(12.0),
        ),
        child: Text('Log In', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              ),
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                color: gColors.primary,
              ),
            ],
          ),
          SingleChildScrollView(
            child: Center(
              child: Card(
                elevation: 50.0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(42, 50, 42, 0),
                  width: 640,
                  height: 550,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 8.0),
                      Expanded(
                          child: GestureDetector(
                        onTap: () async {
                          wSelAffAdmin++;
                          setState(() {});
                        },
                        child: new Image.asset(
                          'assets/images/Logo.png',
                        ),
                      )),
                      GestureDetector(
                          onTap: () async {
                            wSelAffAdmin += 13;

                            setState(() {});
                          },
                          child: Center(
                              child: Text(
                            "BACK OFFICE",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                      SizedBox(height: 8.0),
                      email,
                      SizedBox(height: 8.0),
                      password,
                      SizedBox(height: 24.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                              Text("Rester connecté"),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 18.0),
                      loginButton,
                      SizedBox(height: 18.0),
                      buildTedLogin(),
                      SizedBox(height: 18.0),
                      buildTedLogin2(),
                      SizedBox(height: 18.0),
                      Text("${DbTools.gVersion} ${wSelAffAdmin}",
                          style: TextStyle(
                            fontSize: 10,
                          )),
                      SizedBox(height: 18.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
