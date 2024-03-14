import 'package:mysql_client/mysql_client.dart';

Future<void> changeProfileName(MySQLConnection sql, {required uid, required name})async {
 await sql.execute("update users set name='$name' where id = $uid");
}