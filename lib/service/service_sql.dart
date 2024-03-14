import 'package:mysql_client/mysql_client.dart';
Future<Map> getServiceInfo(String id, MySQLConnection sql) async {
  final response = await sql.execute(
    "SELECT * FROM servises where id = $id",
    {},
  );
  final included = await sql.execute(
    "SELECT * FROM service_blocs where sid = $id and included = 1",
    {},
  );
  final notIncluded = await sql.execute(
    "SELECT * FROM service_blocs where sid = $id and included = 0",
    {},
  );
  List includedList =[];
  List notIncludedList =[];
  for(var inc in included.rows) {
    includedList.add(inc.assoc()['title']);
  }
  for(var inc in notIncluded.rows) {
    notIncludedList.add(inc.assoc()['title']);
  }
final dataService= response.rows.first.assoc();
  return {
    'name': dataService['name'],
    'price': dataService['price'],
    'low_price': dataService['low_price'],
    'included': includedList,
    'not_included': notIncludedList,
  };
}
