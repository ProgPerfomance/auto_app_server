import 'package:mysql_client/mysql_client.dart';

Future<void> createChat({
  required uid1,
  required uid2,
  required chatSubject,
  required MySQLConnection sql,
}) async {
  var resul = await sql.execute(
    "SELECT * FROM chats",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  var result = await sql.execute(
      "insert into chats (id, uid1, uid2, sid) values (${id_int + 1}, $uid1, $uid2, $chatSubject)");
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
      "SELECT * FROM users where id = ${uid != data['uid1'] ?data['uid1'] :data['uid2']}",
      {},
    );
    final lastMessage = await sql.execute(
      "SELECT * FROM messages where cid = ${data['cid']}",
      {},
    );
    chats.add(
      {
        'cid': data['id'],
        'uid_opponent': data['uid1'] != uid ? data['uid1'] : data['uid2'],
        'opponent_name': user.rows.first.assoc()['name'],
        'sid': data['sid'],
        'last_message': lastMessage.rows.first.assoc()['message'],
        'timestamp':lastMessage.rows.first.assoc()['timestamp'],
      },
    );
  }
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
