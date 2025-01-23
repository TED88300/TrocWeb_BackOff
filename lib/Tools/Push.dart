import 'dart:convert';

import 'package:TrocWeb_BackOff/Tools/DbTools.dart';
import 'package:TrocWeb_BackOff/Tools/Etablissement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:intl/intl.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart' as auth;



import 'package:http/http.dart' as http;

class Messaging {
  // region Singleton
  static final Messaging _instance = Messaging._internal();

  Messaging._internal();

  static Messaging get instance => _instance;

//endregion

  static final String projectId = 'thierrydaudierdecassini';
  static final String fcmUri = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
  static final String messagingScope = 'https://www.googleapis.com/auth/firebase.messaging';

  /// Credentials used to authenticate the http calls.
  /// If it is null, at the first time, it will be created.
  /// After that, we will check if the access token is valid.
  /// If it is expired, we are going to refresh it.
  /// We also need the client to refresh the token.
  AccessCredentials? _credentials;

  FirebaseMessaging get fcmInstance => FirebaseMessaging.instance;

  /// Sends a message to a topic or specific device
  /// [topic] might be a topic itself or a registered fcm token (the device token)
  Future<String> sendMessage({
    required String title,
    required String message,
    required String topic,
  }) async {
    Map<String, dynamic> notification = Map();
    notification['title'] = title;
    notification['body'] = message;

    Map<String, dynamic> body = Map();
    body["message"] = {
      'topic': topic,
      'notification': notification,
    };

    return _post(body);
  }

  /// Send data to the informed destionation
  /// [data] must have a maximum 3kb
  Future<String> sendData({
    required String topic,
    required Map<String, String> data,
  }) async {
    debugPrint('Send data to topic $topic: ');

    Map<String, dynamic> body = Map();
    body['message'] = {
      'topic': topic,
      'data': data,
    };

    return _post(body);
  }

  /// Posts the message
  Future<String> _post(Map<String, dynamic> body) async {
    Map<String, String> headers = await _buildHeaders();
    return http
        .post(
      Uri.parse(fcmUri),
      headers: headers,
      body: json.encode(body),
    )
        .then((http.Response response) {
      debugPrint(response.body);
      return response.body;
    });
  }

  /// Builds default header
  Future<Map<String, String>> _buildHeaders() async {
    await _autoRefreshCredentialsInitialize();
    String token = _credentials!.accessToken.data;
    Map<String, String> headers = Map();
    headers["Authorization"] = 'Bearer $token';
    headers["Content-Type"] = 'application/json';
    return headers;
  }

  /// Use service account credentials to obtain oauth credentials.
  /// Whenever new credentials are available, [_credentials] is updated automatically
  Future<void> _autoRefreshCredentialsInitialize() async {
    if (_credentials != null) {
      return;
    }

    // [Assets.files.serviceAccount] is the path to the json created on Services Account
    // Assets is a class that I created to access easily files on assets folder.
    String source = "";// await Assets.readString(Assets.files.serviceAccount);
    final serviceAccount = jsonDecode(source);
    var accountCredentials = ServiceAccountCredentials.fromJson(serviceAccount);

    AutoRefreshingAuthClient autoRefreshingAuthClient =
    await clientViaServiceAccount(
      accountCredentials,
      [messagingScope],
    );

    /// initialization
    _credentials = autoRefreshingAuthClient.credentials;

    // when new credetials are available, _credentials will be updated
    // (it checks if the current credentials is expired)
    autoRefreshingAuthClient.credentialUpdates.listen((credentials) {
      _credentials = credentials;
    });
  }

  //region Registered Token

  Future<void> requestMessagingToken() async {
    // Get the token each time the application loads
    String? token = await fcmInstance.getToken();

    // Save the initial token to the database
    await _saveTokenToSharedPreference(token!);

    // Any time the token refreshes, store this in the database too.
    fcmInstance.onTokenRefresh.listen(_saveTokenToSharedPreference);
  }


  Future<void> _saveTokenToSharedPreference(String token) async {
    FlutterSecureStorage prefs = FlutterSecureStorage();

    // verifica se é igual ao anterior
    String? prev = await prefs.read(key: 'tokenMessaging');

    if (prev == token) {
      debugPrint('Device registered!');
      return;
    }

    try {
      await prefs.write(key: "tokenMessaging", value: token);
      debugPrint('Firebase token saved!');
    } catch (e) {
      print(e);
    }
  }

  Future<String?> get firebaseToken {
    FlutterSecureStorage prefs = FlutterSecureStorage();
    return prefs.read(key: 'tokenMessaging');
  }

//endregion
}

class Push {
  static Future<String?> getAuthToken() async {
    try {
      // Sign in anonymously or use another method if required
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: "ted88300@gmail.com", password: "Zzt7713*");
      String? token = await userCredential.user?.getIdToken();
      return token;
    } catch (e) {
      print('Error retrieving auth token: $e');
      return null;
    }
  }

  static Future<bool> SendPush(String authToken, String atoken, String aTitle, String aBody, String aDate) async {
    try {
      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/thierrydaudierdecassini/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authToken}'
        },
        body: json.encode({

          'message': {
            'token': atoken,
            'notification': {
              'title': '${aTitle}',
              'body': '${aBody}',
            },
            'android': {
// Required for background/terminated app state messages on Android
              'priority': "high",
              'notification': {
                'sound': "default",
                'click_action': "FLUTTER_NOTIFICATION_CLICK",
                'channel_id': "tiktoknotification"
              },
            },
            'apns': {
              'payload': {
                'aps': {
                  'contentAvailable': true,
                  'badge': 1,
                  'sound': "default"
                },
              },
            },
          }
        }),

/*
        body: json.encode({
          'to': atoken,
          'message': {
            'token': atoken,
          },
          "notification": {
            "title": "${aTitle}",
            "body": "${aBody}"
          }
        }),

*/

      ).then((value) => print(value.body));
      print('FCM request for web sent!');
    } catch (e) {
      print(e);
    }
    return true;

  }

    static Future<bool> SendPushNotifications(String aTitle, String aBody, String aDate) async {

    aTitle = ReplaceWord(aTitle, aDate, "");
    aBody = ReplaceWord(aBody, aDate, "");

    Etablissement wEtablissement = DbTools.getEtablissementsbyID(DbTools.gInventaire.etabid);

    aTitle = aTitle.replaceAll("'", "`");
    aBody = aBody.replaceAll("'", "`");

    print(" aTitle ${aTitle}");
    print(" aBody ${aBody}");



    final _scopes = ["https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    final serviceAccountData = await rootBundle.loadString('assets/service_account_key.json');
//  print("serviceAccountData ${serviceAccountData}");
      final serviceAccountJson = json.decode(serviceAccountData);
//  print("serviceAccountJson ${serviceAccountJson}");
      final credentials = auth.ServiceAccountCredentials.fromJson(serviceAccountJson);
      print("credentials ${credentials.email}");
      final client = await auth.clientViaServiceAccount(credentials, _scopes);
      print(" client ${client.credentials.accessToken}");

      String authToken = client.credentials.accessToken.data;
//    String authToken = "ya29.a0AcM612zhNwjrrlyfZzJHqYPD14JbmCPW95bYTgAnQ7nyXM6vHDBNrShTsrolWQUMgpwQVMsOPVgh1OeH-zA0e3-Th6ELZ8LefmzyhFYDHHjqdqyuaCOi5tu1lOPPe5aNs-1OQlraiQIyVc__n3q8cQZBvLpBmWQhnvrAb9L3aCgYKAeoSARMSFQHGX2Mi_NK7jfj3bVTPimnpOZpqCA0175";


      String wSlq = "INSERT INTO Notif (ID, etabid, invid, date_notif, title, body) VALUES (NULL, ${DbTools.gInventaire.etabid}, ${DbTools.gInventaire.id} , current_timestamp(), '$aTitle', '$aBody')";
      print("INSERT INTO Notif " + wSlq);
      bool ret = await DbTools.add_API_Post("insert", wSlq);

      print("wEtablissement.AppToken_1 ${wEtablissement.AppToken_1}");

      if (wEtablissement.AppToken_1.isNotEmpty) SendPush( authToken,  wEtablissement.AppToken_1,  aTitle,  aBody,  aDate);
      if (wEtablissement.AppToken_2.isNotEmpty) SendPush( authToken,  wEtablissement.AppToken_2,  aTitle,  aBody,  aDate);
      if (wEtablissement.AppToken_3.isNotEmpty) SendPush( authToken,  wEtablissement.AppToken_3,  aTitle,  aBody,  aDate);
      if (wEtablissement.AppToken_4.isNotEmpty) SendPush( authToken,  wEtablissement.AppToken_4,  aTitle,  aBody,  aDate);
      if (wEtablissement.AppToken_5.isNotEmpty) SendPush( authToken,  wEtablissement.AppToken_5,  aTitle,  aBody,  aDate);


/*    request.fields.addAll({
      'tic12z': SrvToken,
      'zasq': 'push3',
      'token1': "${wEtablissement.AppToken_1}",
      'token2': "${wEtablissement.AppToken_2}",
      'token3': "${wEtablissement.AppToken_3}",
      'token4': "${wEtablissement.AppToken_4}",
      'token5': "${wEtablissement.AppToken_5}",
      'etabid': "${DbTools.gInventaire.etabid}",
      "title": "${aTitle}",
      "body": "${aBody}",
      "invid": "${DbTools.gInventaire.id}",
    });*/




      return true;

  }

  static String ReplaceWord(String aString, String aDate, String aAgence) {
    aString = aString.replaceAll("#ID#", "${DbTools.gInventaire.id}");
    aString = aString.replaceAll(
        "#Now#", "${DateFormat('dd-MM-yyyy hh:mm').format(DateTime.now())}");
    aString = aString.replaceAll("#Nom#", "${DbTools.gInventaire.nom}");
    aString = aString.replaceAll("#Date#", "${aDate}");

//    aString = aString.replaceAll("#Avis#", "${DbTools.gEtablissement.Url_Avis}");
    aString = aString.replaceAll("#Avis#", "${DbTools.AvisLink}");
    aString = aString.replaceAll("#Réduit#", "${DbTools.gInventaire.NomReduit}");


    aString = aString.replaceAll("#Ville#", "${DbTools.gInventaire.ville}");
    aString = aString.replaceAll("#Nature#", "${DbTools.gInventaire.NatureBien}");


    if (DbTools.gInventaire.AffAccept == 2)
      aString = aString.replaceAll("#50/100#", "50");
    else if (DbTools.gInventaire.AffAccept == 3)
      aString = aString.replaceAll("#50/100#", "100");
    else
      aString = aString.replaceAll("#50/100#", "???");




    aString = aString.replaceAll("#Signature#",
        "${DbTools.gEtablissement.Libelle}\n${DbTools.gEtablissement.tel}\n${DbTools.gEtablissement.mail}");

    aString = aString.replaceAll("#Date#", "${aDate}");

    aString = aString.replaceAll("#Agence#", "${aAgence}");

    return aString;
  }

}
