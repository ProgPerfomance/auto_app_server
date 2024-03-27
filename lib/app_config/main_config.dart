import 'package:mysql_client/mysql_client.dart';

Future<void> setManagerNumber(MySQLConnection sql, number) async {
  await  sql.execute("update appconfins set conf_value ='$number' where conf_key = 'manager_phone'");
}