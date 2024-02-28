import 'package:mysql_client/mysql_client.dart';

Future<Map> authUserFromSQL({
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
      return {
        'uid':   int.parse(email.rows.first.assoc()['id'].toString()),
        'name': email.rows.first.assoc()['name'],
        'phone': email.rows.first.assoc()['phone'],
        'email':email.rows.first.assoc()['email'],
        'rules': email.rows.first.assoc()['rules'],
        'cid': email.rows.first.assoc()['cid'],
      };
    } else {
      await sql.close();
      return {'success': false};
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
        return {
          'uid':   int.parse(phone.rows.first.assoc()['id'].toString()),
          'name': phone.rows.first.assoc()['name'],
          'phone': phone.rows.first.assoc()['phone'],
          'email':phone.rows.first.assoc()['email'],
          'rules': phone.rows.first.assoc()['rules'],
          'cid': phone.rows.first.assoc()['cid'],
        };
      } else {
        await sql.close();
        return {'success': false};
      }
    } catch (e) {
      print(e);
      await sql.close();
      return {'success': false};
    }
  }

  //   "insert into usertable (id, name, password_hash, city, email, country, age, freelancer, last_login, date_of_burn, avatar, skills, education, experience, about_me, client_visiting, servises, rating, reviews, email_succes) values (${id_int + 1}, '$name', '$password_hash', '$city', '$email', '$country', $age, $freelancer, '$last_login', '$date_of_burn', '$avatar', '$skills', '$education', '$experience', '$about_me', '$client_visiting', '$servises', $rating, '$reviews', $email_succes);");
}
