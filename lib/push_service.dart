import 'package:dio/dio.dart';

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
  getToken();
  await dio.post(
      'https://fcm.googleapis.com/v1/projects/dwd-app-3e56e/messages:send',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization':
            "Bearer ya29.a0AXooCgsDu6VmQ3AwKehG0iDRG4QbBv4LIrH4BrPgSaZO7yAoG9j3AKAYKGTMxJjAo2FOar5eewvwaXjZcUR6fspmqkGpY3kj1JDaBXHPSQmUvx8jCwDbiXOMNe0kditIlN-VGx0VqiCHYcX4qRswdKZYDCOZa6EZVA_TaCgYKAbASARISFQHGX2MixJNexXG5gbweDXaIIAcDfg0171",
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
  getToken();
  Dio dio = Dio();
  await dio.post(
      'https://fcm.googleapis.com/v1/projects/dwd-app-3e56e/messages:send',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization':
            "Bearer ya29.a0AXooCgsDu6VmQ3AwKehG0iDRG4QbBv4LIrH4BrPgSaZO7yAoG9j3AKAYKGTMxJjAo2FOar5eewvwaXjZcUR6fspmqkGpY3kj1JDaBXHPSQmUvx8jCwDbiXOMNe0kditIlN-VGx0VqiCHYcX4qRswdKZYDCOZa6EZVA_TaCgYKAbASARISFQHGX2MixJNexXG5gbweDXaIIAcDfg0171",
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
}
