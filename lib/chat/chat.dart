// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:mysql_client/mysql_client.dart';

Future<int> createChat({
  required uid1,
  required uid2,
  required chatSubject,
  required type,
  required MySQLConnection sql,
}) async {
  var resul = await sql.execute(
    "SELECT * FROM chats",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  var result = await sql.execute(
      "insert into chats (id, uid1, uid2, sid, type) values (${id_int + 1}, $uid1, $uid2, $chatSubject, '$type')");
  return id_int + 1;
}

Future<List> getUserChats({
  required uid,
  required MySQLConnection sql,
}) async {
  List chats = [];
  print('uid $uid');
  final response = await sql.execute(
    "SELECT * FROM chats where uid1 = $uid or uid2 = $uid",
    {},
  );

  for (final row in response.rows) {
    var data = row.assoc();
    print(data);
    final user = await sql.execute(
      "SELECT * FROM users where id = ${uid != data['uid1'] ? data['uid1'] : data['uid2']}",
      {},
    );
    var timestamp;
    var msgText;
    var senderUid;
    var messageId;
    try {
      final lastMessage = await sql.execute(
        "SELECT * FROM messages where cid = ${data['id']}",
      );
      timestamp = lastMessage.rows.first.assoc()['timestamp'];
      msgText = lastMessage.rows.first.assoc()['message'];
      senderUid = lastMessage.rows.first.assoc()['uid'];
      messageId = int.parse(lastMessage.rows.first.assoc()['id'] as String);
    } catch (e) {
      timestamp = null;
      msgText = null;
      senderUid = null;
      messageId = null;
    }
    var car =
        await sql.execute("select * from carlist where id =${data['sid']}");
    data['type'] == 'car'
        ? chats.add(
            {
              'cid': data['id'],
              'uid_opponent': data['uid1'] != uid ? data['uid1'] : data['uid2'],
              'opponent_name': user.rows.first.assoc()['name'],
              'sid': data['sid'],
              'type': data['type'],
              'last_message': msgText,
              'timestamp': timestamp,
              'sender_uid': senderUid,
              'message_id': messageId,
              'car_name': car.rows.first.assoc()['name'],
              'car_id': car.rows.first.assoc()['id'],
              'car_ccid': car.rows.first.assoc()['ccid'],
            },
          )
        : chats.add(
            {
              'cid': data['id'],
              'uid_opponent': data['uid1'] != uid ? data['uid1'] : data['uid2'],
              'opponent_name': user.rows.first.assoc()['name'],
              'sid': data['sid'],
              'type': data['type'],
              'last_message': msgText,
              'timestamp': timestamp,
              'sender_uid': senderUid,
              'message_id': messageId,
            },
          );
  }
  chats.sort((a, b) => (b['message_id'] ?? 0).compareTo(a['message_id'] ?? 0));

  return chats;
}

Future<void> createMessageFromSQL(
    {required cid,
    required uid,
    required msg,
    required MySQLConnection sql}) async {
  var resul = await sql.execute(
    "SELECT * FROM messages",
    {},
  );

  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  await sql.execute(
      "insert into messages (id, cid, uid, message, timestamp) values (${id_int + 1}, $cid, $uid, '$msg', '${DateTime.now()}')");
}

Future<List> getMessagesFromSQL(cid, {required MySQLConnection sql}) async {
  List messages = [];
  final response = await sql.execute(
    "SELECT * FROM messages where cid = $cid",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    messages.add(
      {
        'id': data['id'],
        'chat_id': data['chat_id'],
        'uid': data['uid'],
        'msg_text': data['message'],
      },
    );
  }
  return messages;
}
