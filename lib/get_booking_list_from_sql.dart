import 'package:mysql_client/mysql_client.dart';

Future<List> getUserBookingList(String id, MySQLConnection sql) async {
  List booking = [];

  final response = await sql.execute(
    "SELECT * FROM booking where uid = $id",
    {},
  );

  for (final row in response.rows) {
    var data = row.assoc();
    final service = await sql.execute(
      "SELECT * FROM servises where id = ${data['sid']}",
      {},
    );
    booking.add(
      {
        'id': data['id'],
        'sid': data['sid'],
        'cid': data['cid'],
        'uid': data['uid'],
        'service_name': service.rows.first.assoc()['name'],
        'owner_name': data['owner_name'],
        'owner_email': data['owner_email'],
        'owner_phone': data['owner_phone'],
        'pickup': data['pickup'],
        'delivery': data['delivery'],
        'timestamp': data['timestamp'],
        'date_time': data['date_time'],
        'status': data['status'],
      },
    );
  }
  return booking;
}

Future<List> getUserBookingListMaster(String id, MySQLConnection sql) async {
  List booking = [];

  final response = await sql.execute(
    "SELECT * FROM booking where sid = $id",
    {},
  );

  for (final row in response.rows) {
    var data = row.assoc();
    final car = await sql.execute(
      "SELECT * FROM usercars where id = ${data['cid']}",
      {},
    );
    booking.add(
      {
        'car_name': car.rows.first.assoc()['name'],
        'description': data['description'],
        'reason': data['reason'],
        'id': data['id'],
        'sid': data['sid'],
        'cid': data['cid'],
        'uid': data['uid'],
        'owner_name': data['owner_name'],
        'owner_email': data['owner_email'],
        'owner_phone': data['owner_phone'],
        'pickup': data['pickup'],
        'delivery': data['delivery'],
        'timestamp': data['timestamp'],
        'date_time': data['date_time'],
        'status': data['status'],
      },
    );
  }
  return booking;
}

Future<List> updateBookingStatus(
    String id, String status, MySQLConnection sql) async {
  List booking = [];

  final response = await sql.execute(
    "update booking set status = '$status' where id = $id",
    {},
  );
  return booking;
}

Future<List> getNewBookingListMaster(String id, MySQLConnection sql) async {
  List booking = [];
  final response = await sql.execute(
    "SELECT * FROM booking where sid = $id and status = 'Pending'",
    {},
  );

  for (final row in response.rows) {
    var data = row.assoc();
    final car = await sql.execute(
      "SELECT * FROM usercars where id = ${data['cid']}",
      {},
    );
    booking.add(
      {
        'id': data['id'],
        'sid': data['sid'],
        'cid': data['cid'],
        'uid': data['uid'],
        'description': data['description'],
        'reason': data['reason'],
        'car_name': car.rows.first.assoc()['name'],
        'owner_name': data['owner_name'],
        'owner_email': data['owner_email'],
        'owner_phone': data['owner_phone'],
        'pickup': data['pickup'],
        'delivery': data['delivery'],
        'timestamp': data['timestamp'],
        'date_time': data['date_time'],
        'status': data['status'],
      },
    );
  }
  return booking;
}

Future<List> getManagerBookingList(MySQLConnection sql) async {
  List booking = [];

  final response = await sql.execute(
    "SELECT * FROM booking",
    {},
  );

  for (final row in response.rows) {
    var data = row.assoc();
    final service = await sql.execute(
      "SELECT * FROM servises where id = ${data['sid']}",
      {},
    );
    final car = await sql.execute(
      "SELECT * FROM usercars where id = ${data['cid']}",
      {},
    );
    var garage_name;
    try {
      final garage = await sql.execute(
        "SELECT * FROM users where id = ${data['garage']}",
      );
      garage_name = await garage.rows.first.assoc()['name'];
    } catch (e) {
      garage_name = '';
    }
    booking.add(
      {
        'id': data['id'],
        'sid': data['sid'],
        'cid': data['cid'],
        'uid': data['uid'],
        'garage': data['garage'],
        'garage_name': garage_name,
        'car_name': car.rows.first.assoc()['name'],
        'service_name': service.rows.first.assoc()['name'],
        'owner_name': data['owner_name'],
        'owner_email': data['owner_email'],
        'owner_phone': data['owner_phone'],
        'pickup': data['pickup'],
        'delivery': data['delivery'],
        'timestamp': data['timestamp'],
        'date_time': data['date_time'],
        'status': data['status'],
        'description': data['description'],
      },
    );
  }
  return List.from(booking.reversed);
}

Future<List> getManagerNewBookingList(MySQLConnection sql) async {
  List booking = [];

  final response = await sql.execute(
    "SELECT * FROM booking where status = 'Pending'",
    {},
  );

  for (final row in response.rows) {
    var data = row.assoc();
    final service = await sql.execute(
      "SELECT * FROM servises where id = ${data['sid']}",
      {},
    );
    final car = await sql.execute(
      "SELECT * FROM usercars where id = ${data['cid']}",
      {},
    );
    var garage_name;
    try {
      final garage = await sql.execute(
        "SELECT * FROM users where id = ${data['garage']}",
      );
      garage_name = await garage.rows.first.assoc()['name'];
    } catch (e) {
      garage_name = '';
    }
    booking.add(
      {
        'id': data['id'],
        'sid': data['sid'],
        'cid': data['cid'],
        'uid': data['uid'],
        'garage': data['garage'],
        'garage_name': garage_name,
        'car_name': car.rows.first.assoc()['name'],
        'service_name': service.rows.first.assoc()['name'],
        'owner_name': data['owner_name'],
        'owner_email': data['owner_email'],
        'owner_phone': data['owner_phone'],
        'pickup': data['pickup'],
        'delivery': data['delivery'],
        'timestamp': data['timestamp'],
        'date_time': data['date_time'],
        'status': data['status'],
        'description': data['description'],
      },
    );
  }
  return List.from(booking.reversed);
}
