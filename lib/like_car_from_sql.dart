import 'package:mysql_client/mysql_client.dart';

void likeCarFromSql({
  required uid,
  required cid,
    }) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp');
  await sql.connect();
  print(sql.connected);
  // make query (notice third parameter, iterable=true)
  var resul = await sql.execute(
    "SELECT * FROM likes",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  print(id_int);

  var result = await sql.execute(
      "insert into likes (id, uid, pid) values (${id_int + 1}, $uid, $cid);");
  await sql.close();
}

void dislikeCarFromSql({
 required id,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp');
  await sql.connect();
  print(sql.connected);
  var result = await sql.execute(
      "delete from likes where id =$id;");
  await sql.close();
}
