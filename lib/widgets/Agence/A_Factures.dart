import 'dart:convert';

import 'package:TrocWeb_BackOff/Tools/Push.dart';
import 'package:TrocWeb_BackOff/Tools/gColors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';


class NOTIFICATIONS extends StatefulWidget {
  @override
  _NOTIFICATIONSState createState() => _NOTIFICATIONSState();
}

class _NOTIFICATIONSState extends State<NOTIFICATIONS> {

  int _messageCount = 0;

  String constructFCMPayload(String? token) {
    _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#$_messageCount) was created via FCM!',
      },
    });
  }


  Future<void> sendPushMessage() async {

    String? _token = "dfgCPinzu0JivTDGU-RGay:APA91bGsVqAnL8m93H_Q5gpgQi44QrB2dKSlH-gd4qwLpjQYqChJSxLphtrSpw7hkjuUWqOdH9-Enef4xTJuhMNoGEQkVp4Q3NLRGEvt_XXhazHDHBxj5fbZYuv0lUVrHohPLEbMLc5A";


    String wM = constructFCMPayload(_token);
    print('FCM wM ${wM}');

    try {
    final response = await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token),
      );
      print('FCM request for device sent! ${response.statusCode}');
    } catch (e) {
      print(e);
    }
  }


  sendPushMessageToWeb() async {
    String? _token = "dfgCPinzu0JivTDGU-RGay:APA91bGsVqAnL8m93H_Q5gpgQi44QrB2dKSlH-gd4qwLpjQYqChJSxLphtrSpw7hkjuUWqOdH9-Enef4xTJuhMNoGEQkVp4Q3NLRGEvt_XXhazHDHBxj5fbZYuv0lUVrHohPLEbMLc5A";
    try {
      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/thierrydaudierdecassini/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ya29.a0AcM612zi-4sLdzvL12HSSYtYN9jycJjIgI6cwejCNaLNVzjrdcJ9wRtyB1MJVKhQnevPJ55SzAcInFq-X5tUz83n0W1AQWavh0bw0w546YJMgC3YNxxb4xrQ9UWMLeCbLF5gV9G75c-bbltd7cpgGIiCMab5Z9E0LC5aH4qZaCgYKAdgSARMSFQHGX2Mi9aDT8w6mfhTKM7yQ9EvPwQ0175'
        },
        body: json.encode({
          'to': _token,
          'message': {
            'token': _token,
          },
          "notification": {
            "title": "Push Notification",
            "body": "Firebase  push notification"
          }
        }),
      )
          .then((value) => print(value.body));
      print('FCM request for web sent!');
    } catch (e) {
      print(e);
    }
  }


  static Future<void> sendNoficationToselectedUser() async {

    final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);

    String? authToken = await Push.getAuthToken();
    print('authToken: $authToken');

    authToken = "ya29.a0AcM612xOH3p43pl6pj0qtpzdaa6k_mteAMDW7mv-pPLSku0f1Ai_A20HPFbnRX-tM4A8odHvB_b9uNgEgoVwUotgVErE1xr4itswZm5AR9D1wbha295hYpjLewSww1IJ9G81JJAnuyEnKLq7jY71YAZM19VKlcZzne6moe7PaCgYKAT8SARMSFQHGX2MigXE_UBuGYrL8p9phSnxcWA0175";

    String? _token = "dfgCPinzu0JivTDGU-RGay:APA91bGsVqAnL8m93H_Q5gpgQi44QrB2dKSlH-gd4qwLpjQYqChJSxLphtrSpw7hkjuUWqOdH9-Enef4xTJuhMNoGEQkVp4Q3NLRGEvt_XXhazHDHBxj5fbZYuv0lUVrHohPLEbMLc5A";

    final String serverAccessToken =  "ya29.a0AcM612zi-4sLdzvL12HSSYtYN9jycJjIgI6cwejCNaLNVzjrdcJ9wRtyB1MJVKhQnevPJ55SzAcInFq-X5tUz83n0W1AQWavh0bw0w546YJMgC3YNxxb4xrQ9UWMLeCbLF5gV9G75c-bbltd7cpgGIiCMab5Z9E0LC5aH4qZaCgYKAdgSARMSFQHGX2Mi9aDT8w6mfhTKM7yQ9EvPwQ0175";
    String endpointFirebasecloudMessaging =
        'https://fcm.googleapis.com/v1/projects/thierrydaudierdecassini/messages:send';
    final Map<String, dynamic> message = {
      'message': {
        'token': _token,
        'notification': {
          'title': 'ttttt',
          'body': 'bbbbb',
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
// Required for background/terminated app state messages on iOS
              'contentAvailable': true,
              'badge': 1,
              'sound': "default"
            },
          },
        },
      }
    };
    final http.Response response = await http.post(
      Uri.parse(endpointFirebasecloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken'
      },
      body: jsonEncode(message),
    );
    if (response.statusCode == 200) {
      debugPrint("Successfully sent:${response.body}");
    } else {
      debugPrint("Failed with code:${response.body}");
    }
  }
/*

  Future<String> getAccessToken() async {
    final serviceAccountJson = json.decode(await File(‘path/to/your/serviceAccountKey.json’).readAsString());
    final credentials = auth.ServiceAccountCredentials.fromJson(serviceAccountJson);
    final client = await auth.clientViaServiceAccount(credentials, _scopes);
    final authClient = auth.AuthClient(client, credentials, _scopes);
    final accessCredentials = await auth.obtainAccessCredentialsViaServiceAccount(
      credentials,
      _scopes,
      client,
    );

    client.close();

    return accessCredentials.accessToken.data;
  }

*/
  static Future<void> sendNoficationToselectedUser2() async {

    await Push.SendPushNotifications("tecTilte","tecBody", DateTime.now().toIso8601String());

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Column(
        children: <Widget>[
            Row(
              children: <Widget>[


                ElevatedButton(
                  onPressed: () async {
//                    sendNoficationToselectedUser2();



                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.push,
                    padding: const EdgeInsets.all(12.0),
                  ),
                  child: Text('Push',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),


              ],
            ),

        ],
      ),
    ),
    );
  }



}
