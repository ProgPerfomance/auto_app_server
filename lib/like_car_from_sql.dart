import 'package:mysql_client/mysql_client.dart';

void likeCarFromSql({
  required uid,
  required cid,
  required sql,
    }) async {
  var resul = await sql.execute(
    "SELECT * FROM likes",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);

await sql.execute(
      "insert into likes (id, uid, pid) values (${id_int + 1}, $uid, $cid);");
}

void dislikeCarFromSql({
 required id,
  required MySQLConnection sql,
}) async {

  await sql.execute(
      "delete from likes where id =$id;");
}
