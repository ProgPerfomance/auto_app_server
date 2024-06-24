import 'package:auto_app_server/push_service.dart';
import 'package:mysql_client/mysql_client.dart';


Future<void> sellCarRequest(
{
 required var uid,
required  var cid,
  required var type,
required  var owner_name,
required  var owner_email,
required  var owner_phone,
 required var any_car_accidents,
required  var gcc,
 required var servise_history,
  required MySQLConnection sql,
}
) async {

  var resul = await sql.execute(
    "SELECT * FROM sell_requests",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  print(id_int);

  var result = await sql.execute(
      "insert into sell_requests (id, uid, cid, owner_name, owner_email, owner_phone, any_car_accidents, gcc, servise_history, type) values (${id_int+1}, $uid, $cid, '$owner_name', '$owner_email', '$owner_phone', $any_car_accidents, $gcc, $servise_history, $type);");
  final tokenRow = await sql.execute('select * from users where id = 0');
  localPush(tokenRow.rows.first.assoc()['token'], 'New sell car request!', '$owner_name, E-mail: $owner_email');
}
