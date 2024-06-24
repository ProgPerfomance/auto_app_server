import 'package:dio/dio.dart';

void globalPush(title, body) async {
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
