import 'package:dio/dio.dart';

void globalPush(title, body) async {
  Dio dio = Dio();
  await dio.post(
      'https://fcm.googleapis.com/v1/projects/dwd-app-3e56e/messages:send',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization':
            "Bearer ya29.a0AXooCguznPfeLv6qCmsfSv7y-LWcThqyDQfIbnfhNQpahYAOs14Fb47EFTHb-Kt8HPUxX2JufSh8aTZmHRvcH7S7Lsf0QEAMj_KCXepYNOTzGkodV482z7fzck2G8z-3XIA8pf6RhzpfPm8tAOKynCB5ac-BQHIE8Lr8aCgYKAWYSARISFQHGX2MiYrXV6JmnrcZUdeXPLJ9rcA0171",
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
            "Bearer ya29.a0AXooCguznPfeLv6qCmsfSv7y-LWcThqyDQfIbnfhNQpahYAOs14Fb47EFTHb-Kt8HPUxX2JufSh8aTZmHRvcH7S7Lsf0QEAMj_KCXepYNOTzGkodV482z7fzck2G8z-3XIA8pf6RhzpfPm8tAOKynCB5ac-BQHIE8Lr8aCgYKAWYSARISFQHGX2MiYrXV6JmnrcZUdeXPLJ9rcA0171",
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
