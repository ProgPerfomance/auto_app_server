import 'package:mysql_client/mysql_client.dart';


Future<int> createUserCarFromSQL({
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
  required guarantee,
  required service_contact,
  required description,
  required year,
  required List images,
}) async {
  var resul = await sql.execute(
    "SELECT * FROM carlist",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  print(id_int);
  await sql.execute(
        "insert into carlist (id, brand,model,price_usd,price_aed,color,killometers,regional_specs,transmission,steering_whell,motor_trim,body,guarantee,service_contact,description,year) values (${id_int + 1}, '$name', '$brand', '$model', $price_usd, $price_usd, '$color', $killometers, '$regional_specs', '$transmission', $steering_whell, '$motor_trim','$body', '$guarantee', '$service_contact',);");
      return id_int+1;
      //   "insert into usertable (id, name, password_hash, city, email, country, age, freelancer, last_login, date_of_burn, avatar, skills, education, experience, about_me, client_visiting, servises, rating, reviews, email_succes) values (${id_int + 1}, '$name', '$password_hash', '$city', '$email', '$country', $age, $freelancer, '$last_login', '$date_of_burn', '$avatar', '$skills', '$education', '$experience', '$about_me', '$client_visiting', '$servises', $rating, '$reviews', $email_succes);");
  }