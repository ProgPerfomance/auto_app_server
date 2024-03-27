import 'package:mysql_client/mysql_client.dart';

Future<int> createCarFromSQL({
  required MySQLConnection sql,
  required String name,
  required String brand,
  required String model,
  required String price_usd,
  required String price_aed,
  required String color,
  required String killometers,
  required String regional_specs,
  required String transmission,
  required String motor_trim,
  required String body,
  required String guarantee,
  required String service_contact,
  required String description,
  required String year,
  required String ccid,
  required cash,
}) async {
  var resul = await sql.execute(
    "SELECT * FROM carlist",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  await sql.execute(
      "insert into carlist (id, name, brand, model, price_usd, price_aed, color, killometers,regional_specs,transmission,motor_trim, body, guarantee,service_contact,description,year,ccid, status, cash) values (${id_int + 1}, '$name', '$brand', '$model', $price_usd, $price_aed, '$color', $killometers, '$regional_specs','$transmission', '$motor_trim', '$body','$guarantee','$service_contact','$description',$year, '$ccid', 1, $cash)");
  return id_int + 1;
}

Future updateCarFromSQL({
  required MySQLConnection sql,
  required String name,
  required String brand,
  required String model,
  required String price_usd,
  required String price_aed,
  required String color,
  required String killometers,
  required String regional_specs,
  required String transmission,
  required String motor_trim,
  required String body,
  required String guarantee,
  required String service_contact,
  required String description,
  required String year,
  required String ccid,
  required cash,
}) async {
  var resul = await sql.execute(
    "SELECT * FROM carlist",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  await sql.execute(
      "update carlist set brand='$brand', model='$model', price_usd=$price_usd, price_aed=$price_aed, color='$color', killometers=$killometers, regional_specs='$regional_specs', transmission='$transmission' where id=$id");
}
