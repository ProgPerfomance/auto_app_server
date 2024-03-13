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
}) async {
  var resul = await sql.execute(
    "SELECT * FROM carlist",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  print(id_int);
 // await sql.execute("insert into carlist (id,name) values(${id_int+1}, '$name')");
  await sql.execute(
      "insert into carlist (id, name, brand, model, price_usd, price_aed, color, killometers,regional_specs,transmission,motor_trim, body, guarantee,service_contact,description,year,ccid) values (${id_int + 1}, '$name', '$brand', '$model', $price_usd, $price_aed, '$color', $killometers, '$regional_specs','$transmission', '$motor_trim', '$body','$guarantee','$service_contact','$description',$year, '$ccid')");
  return id_int + 1;
  //   "insert into usertable (id, name, password_hash, city, email, country, age, freelancer, last_login, date_of_burn, avatar, skills, education, experience, about_me, client_visiting, servises, rating, reviews, email_succes) values (${id_int + 1}, '$name', '$password_hash', '$city', '$email', '$country', $age, $freelancer, '$last_login', '$date_of_burn', '$avatar', '$skills', '$education', '$experience', '$about_me', '$client_visiting', '$servises', $rating, '$reviews', $email_succes);");
}
