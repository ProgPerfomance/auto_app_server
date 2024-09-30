/*import 'package:dio/dio.dart';
final tokenn = 'ya29.a0AXooCgvhsAALX_klBMnZeIxZhutGgxvz1y-YsGan0xaHqGZ0ccZGXsxENvxq31hOygT0eQZRNcdTNfDnI8mMTJZeDIah_Ziua1nysbgx5RQ-i7fjPrXREaTQ3_QiwXE_6FVR19XH2p8BWoNerS99jiI2Jj2JoYV_TAP6aCgYKAV0SARISFQHGX2Mi5UwYp_CrUfHJvd299OF8Lg0171';
void getToken () async {
  Dio dio = Dio();

  final url = 'https://oauth2.googleapis.com/token';
  final headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'User-Agent': 'google-oauth-playground'
  };
  final data = {
    'code': '4%2F0ATx3LY623Hyl_l9uPhg2AfQCK8z3FYtdTsF1LPjCjLw-Z3oB4o2psw3yMcZ7kOgxHdzvLw',
    'redirect_uri': 'https://developers.google.com/oauthplayground',
    'client_id': '4204035592370-fbpp31uhfovka8fsis111tluatldo5jg.apps.googleusercontent.com',
    'client_secret': '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',
    'scope': '',
    'grant_type': 'authorization_code'
  };

  try {
    final response = await dio.post(url, data: data, options: Options(headers: headers));
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
  } catch (e) {
    print('Error: $e');
  }
}

void globalPush(title, body) async {
  Dio dio = Dio();
  await dio.post(
      'https://fcm.googleapis.com/v1/projects/dwd-app-3e56e/messages:send',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization':
        "Bearer $tokenn",
      }),
      data: {
        "message": {
          "topic": "main",
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {"story_id": "story_12345"}
        }
      });
}

void localPush(token, title, body) async {
  Dio dio = Dio();
  await dio.post(
      'https://fcm.googleapis.com/v1/projects/dwd-app-3e56e/messages:send',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization':
        "Bearer $tokenn",
      }),
      data: {
        "message": {
          "token": token,
          "notification": {
            "body": body,
            "title": title,
          }
        }
      });
}*/
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
final serviceAccountJson = File('private.json').readAsStringSync();

const String firebaseMessagingUrl = 'https://fcm.googleapis.com/v1/projects/dwd-app-3e56e/messages:send';



void main() async {

  const title = 'Hello';
  const body = 'This is a test notification';

}

Future<void> globalPush(title, body) async {
  // Load the service account credentials
  final serviceAccountCredentials = ServiceAccountCredentials.fromJson(serviceAccountJson);

  // Get an authenticated HTTP client
  final client = await clientViaServiceAccount(
    serviceAccountCredentials,
    [ 'https://www.googleapis.com/auth/firebase.messaging' ],
  );

  // Create the message payload


  final response = await client.post(
    Uri.parse(firebaseMessagingUrl),
    headers: { 'Content-Type': 'application/json' },
    body: jsonEncode({
      "message": {
        "topic": "main",
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {"story_id": "story_12345"}
      }
    }),
  );

  if (response.statusCode == 200) {
    print('Message sent successfully');
  } else {
    print('Failed to send message: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  client.close();
}



Future<void> localPush(token, title, body) async {
  // Load the service account credentials
  final serviceAccountCredentials = ServiceAccountCredentials.fromJson(serviceAccountJson);

  // Get an authenticated HTTP client
  final client = await clientViaServiceAccount(
    serviceAccountCredentials,
    [ 'https://www.googleapis.com/auth/firebase.messaging' ],
  );

  // Create the message payload


  final response = await client.post(
    Uri.parse(firebaseMessagingUrl),
    headers: { 'Content-Type': 'application/json' },
    body: jsonEncode( {
      "message": {
        "token": token,
        "notification": {
          "body": body,
          "title": title,
        }
      }}),
  );

  if (response.statusCode == 200) {
    print('Message sent successfully');
  } else {
    print('Failed to send message: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  client.close();
}


// void globalPush(title, body) async {
//   Dio dio = Dio();
//   // getToken();
//   await dio.post(
//       'https://fcm.googleapis.com/v1/projects/dwd-app-3e56e/messages:send',
//       options: Options(headers: {
//         'Content-Type': 'application/json',
//         'Authorization':
//         "Bearer $tokenn",
//       }),
//       data: {
//         "message": {
//           "topic": "main",
//           "notification": {
//             "title": title,
//             "body": body,
//           },
//           "data": {"story_id": "story_12345"}
//         }
//       });
// }
//
// void localPush(token, title, body) async {
// //  getToken();
//   Dio dio = Dio();
//   await dio.post(
//       'https://fcm.googleapis.com/v1/projects/dwd-app-3e56e/messages:send',
//       options: Options(headers: {
//         'Content-Type': 'application/json',
//         'Authorization':
//         "Bearer $tokenn",
//       }),
//       data: {
//         "message": {
//           "token": token,
//           "notification": {
//             "body": body,
//             "title": title,
//           }
//         }
//       });
// }

