import 'package:mysql_client/mysql_client.dart';

Future<int> authUserFromSQL({
  required email_or_phone,
  required password_hash,
  required MySQLConnection sql,
}) async {
  final email = await sql.execute(
    "SELECT * FROM users where email = '$email_or_phone'",
    {},
  );
  try {
    print(email.rows.first);
    print(email.rows.first.assoc()['password_hast']);
    if (password_hash == email.rows.first.assoc()['password_hast']) {
      await sql.close();
      return int.parse(email.rows.first.assoc()['id'].toString());
    } else {
      await sql.close();
      return 1;
    }
  } catch (e) {
    try {
      print(e);
      final phone = await sql.execute(
        "SELECT * FROM users where phone = '$email_or_phone'",
        {},
      );
      print(phone.rows.first.assoc()['password_hast']);
      if (password_hash == phone.rows.first.assoc()['password_hast']) {
        await sql.close();
        return int.parse(phone.rows.first.assoc()['id'].toString());
      } else {
        await sql.close();
        return 1;
      }
    } catch (e) {
      print(e);
      await sql.close();
      return 1;
    }
  }

  //   "insert into usertable (id, name, password_hash, city, email, country, age, freelancer, last_login, date_of_burn, avatar, skills, education, experience, about_me, client_visiting, servises, rating, reviews, email_succes) values (${id_int + 1}, '$name', '$password_hash', '$city', '$email', '$country', $age, $freelancer, '$last_login', '$date_of_burn', '$avatar', '$skills', '$education', '$experience', '$about_me', '$client_visiting', '$servises', $rating, '$reviews', $email_succes);");
}
