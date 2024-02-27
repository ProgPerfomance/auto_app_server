import 'package:mysql_client/mysql_client.dart';

void createAdverbFromSql(
    {
      required sql,
      required name,
    required brand,
    required model,
    required price_usd,
    required price_aed,
    required color,
    required killometers,
    required regional_specs,
    required transmission,
    required steering_whell,
     required motor_trim,
    required body,
    required state,
      required year,
    required guarantee,
    required service_contact}) async {
  // make query (notice third parameter, iterable=true)
  var resul = await sql.execute(
    "SELECT * FROM carlist",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  print(id_int);

  var result = await sql.execute(
      "insert into users (id, name, brand, model,price_usd,price_aed,color,killometers,regional_specs,transmission,steering_whell,motor_trim,body,state,guarantee,service_contact, year) values (${id_int + 1}, '$name', '$brand', '$model', $price_usd, $price_aed, '$color', $killometers, '$regional_specs', '$transmission', $steering_whell, '$motor_trim', '$body', '$state', '$guarantee', '$service_contact, $year');");
  await sql.close();
}
