// ignore_for_file: empty_catches

import 'package:auto_app_server/push_service.dart';
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
  return List.from(booking.reversed);
}

Future<List> getUserBookingListMaster(String id, MySQLConnection sql) async {
  List booking = [];

  final response = await sql.execute(
    "SELECT * FROM booking where garage = $id",
    {},
  );

  for (final row in response.rows) {
    var data = row.assoc();
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
    try {
      DateTime
          .parse(data['timestamp']!)
          .millisecondsSinceEpoch > DateTime
          .now()
          .subtract(Duration(days: 3))
          .millisecondsSinceEpoch ?
      booking.add(
        {
          'garage_name': garage_name,
          'car_name': car.rows.first.assoc()['name'],
          'description': data['description'],
          'reason': data['reason'],
          'id': data['id'],
          'sid': data['sid'],
          'cid': data['cid'],
          'uid': data['uid'],
          'car_brand': car.rows.first.assoc()['brand'],
          'car_reg': car.rows.first.assoc()['car_reg'],
          'car_model': car.rows.first.assoc()['model'],
          'car_year': car.rows.first.assoc()['year'],
          'owner_name': data['owner_name'],
          'owner_email': data['owner_email'],
          'owner_phone': data['owner_phone'],
          'pickup': data['pickup'],
          'delivery': data['delivery'],
          'timestamp': data['timestamp'],
          'date_time': data['date_time'],
          'status': data['status'],
        },
      ) : {booking.add(
        {
          'garage_name': garage_name,
          'car_name': car.rows.first.assoc()['name'],
          'description': data['description'],
          'reason': data['reason'],
          'id': data['id'],
          'sid': data['sid'],
          'cid': data['cid'],
          'uid': data['uid'],
          'car_brand': car.rows.first.assoc()['brand'],
          'car_reg': car.rows.first.assoc()['car_reg'],
          'car_model': car.rows.first.assoc()['model'],
          'car_year': car.rows.first.assoc()['year'],
          'owner_name': data['owner_name'],
          'owner_email': data['owner_email'],
          'owner_phone': data['owner_phone'],
          'pickup': data['pickup'],
          'delivery': data['delivery'],
          'timestamp': data['timestamp'],
          'date_time': data['date_time'],
          'status': 'time is up',
        },
      ),
        await sql.execute(
            "update booking set status = 'time is up' where id = ${data['id']}"),
      };
    } catch (e) {}
  }
  return List.from(booking.reversed);
}

Future<void> updateBookingStatus(
    String id, String status, MySQLConnection sql, reason,garage) async {
  await sql.execute(
    "update booking set status = '$status', reason = '$reason', garage=$garage where id = $id",
  );
  final bookingRow = await sql.execute('select * from booking where id = $id');
  final tokenRow = await sql.execute('select * from users where id = ${bookingRow.rows.first.assoc()['uid']}');
  final managerTokenRow = await sql.execute('select * from users where id = 0');
  if(garage == 'null' || garage == null) {
    localPush(managerTokenRow.rows.first.assoc()['token'], 'Garage cancel this booking!', 'Reason:$reason');
  }
  localPush(tokenRow.rows.first.assoc()['token'], 'Your booking changed!', 'Status: $status ${status == 'Canceled' ? ', $reason' :''} ');
}

Future<List> getNewBookingListMaster(String id, MySQLConnection sql) async {
  List booking = [];
  final response = await sql.execute(
    "SELECT * FROM booking where garage = $id and status = 'Pending'",
    {},
  );

  for (final row in response.rows) {
    var data = row.assoc();
    final car = await sql.execute(
      "SELECT * FROM usercars where id = ${data['cid']}",
      {},
    );
    try {
      DateTime
          .parse(data['timestamp']!)
          .millisecondsSinceEpoch > DateTime
          .now()
          .subtract(Duration(days: 3))
          .millisecondsSinceEpoch ?
      booking.add(
        {
          'car_name': car.rows.first.assoc()['name'],
          'description': data['description'],
          'reason': data['reason'],
          'id': data['id'],
          'sid': data['sid'],
          'cid': data['cid'],
          'uid': data['uid'],
          'car_brand': car.rows.first.assoc()['brand'],
          'car_reg': car.rows.first.assoc()['car_reg'],
          'car_model': car.rows.first.assoc()['model'],
          'car_year': car.rows.first.assoc()['year'],
          'owner_name': data['owner_name'],
          'owner_email': data['owner_email'],
          'owner_phone': data['owner_phone'],
          'pickup': data['pickup'],
          'delivery': data['delivery'],
          'timestamp': data['timestamp'],
          'date_time': data['date_time'],
          'status': data['status'],
        },
      ) : {booking.add(
        {
          'car_name': car.rows.first.assoc()['name'],
          'description': data['description'],
          'reason': data['reason'],
          'id': data['id'],
          'sid': data['sid'],
          'cid': data['cid'],
          'uid': data['uid'],
          'car_brand': car.rows.first.assoc()['brand'],
          'car_reg': car.rows.first.assoc()['car_reg'],
          'car_model': car.rows.first.assoc()['model'],
          'car_year': car.rows.first.assoc()['year'],
          'owner_name': data['owner_name'],
          'owner_email': data['owner_email'],
          'owner_phone': data['owner_phone'],
          'pickup': data['pickup'],
          'delivery': data['delivery'],
          'timestamp': data['timestamp'],
          'date_time': data['date_time'],
          'status': 'time is up',
        },
      ),
        await sql.execute(
            "update booking set status = 'time is up' where id = ${data['id']}"),

      };
    }catch (e) {}
  }
  return List.from(booking.reversed);
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
    try {
      DateTime
          .parse(data['timestamp']!)
          .millisecondsSinceEpoch > DateTime
          .now()
          .subtract(Duration(days: 3))
          .millisecondsSinceEpoch ?
      booking.add(
        {
          'id': data['id'],
          'sid': data['sid'],
          'cid': data['cid'],
          'uid': data['uid'],
          'garage': data['garage'],
          'garage_name': garage_name,
          'car_brand': car.rows.first.assoc()['brand'],
          'car_reg': car.rows.first.assoc()['car_reg'],
          'car_model': car.rows.first.assoc()['model'],
          'car_year': car.rows.first.assoc()['year'],
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
      ) : {booking.add(
        {
          'id': data['id'],
          'sid': data['sid'],
          'cid': data['cid'],
          'uid': data['uid'],
          'garage': data['garage'],
          'garage_name': garage_name,
          'car_brand': car.rows.first.assoc()['brand'],
          'car_reg': car.rows.first.assoc()['car_reg'],
          'car_model': car.rows.first.assoc()['model'],
          'car_year': car.rows.first.assoc()['year'],
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
      ),
        await sql.execute(
            "update booking set status = 'time is up' where id = ${data['id']}"),
      };
    } catch (e) {}
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
    try {
      DateTime.parse(data['timestamp']!).millisecondsSinceEpoch > DateTime.now().subtract(Duration(days: 3)).millisecondsSinceEpoch || data['status'] != 'Pending' ?

      booking.add(
        {
          'id': data['id'],
          'sid': data['sid'],
          'cid': data['cid'],
          'uid': data['uid'],
          'garage': data['garage'],
          'garage_name': garage_name,
          'car_brand': car.rows.first.assoc()['brand'],
          'car_reg': car.rows.first.assoc()['car_reg'],
          'car_model': car.rows.first.assoc()['model'],
          'car_year': car.rows.first.assoc()['year'],
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
      ) : {booking.add(
        {
          'id': data['id'],
          'sid': data['sid'],
          'cid': data['cid'],
          'uid': data['uid'],
          'garage': data['garage'],
          'garage_name': garage_name,
          'car_brand': car.rows.first.assoc()['brand'],
          'car_reg': car.rows.first.assoc()['car_reg'],
          'car_model': car.rows.first.assoc()['model'],
          'car_year': car.rows.first.assoc()['year'],
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
      ),
        await  sql.execute("update booking set status = 'time is up' where id = ${data['id']}"),
      };

    }  catch (e) {

    };
  }
  return List.from(booking.reversed);
}


Future<Map> getBookingInfo (MySQLConnection sql, id) async {
  Map booking = {};
  final response = await sql.execute(
    "SELECT * FROM booking where id =$id",
    {},
  );


  var data = await response.rows.first.assoc();
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
  DateTime.parse(data['timestamp']!).millisecondsSinceEpoch > DateTime.now().subtract(Duration(days: 3)).millisecondsSinceEpoch ?
  booking =
  {
    'id': data['id'],
    'sid': data['sid'],
    'cid': data['cid'],
    'uid': data['uid'],
    'garage': data['garage'],
    'garage_name': garage_name,
    'car_brand': car.rows.first.assoc()['brand'],
    'car_reg': car.rows.first.assoc()['car_reg'],
    'car_model': car.rows.first.assoc()['model'],
    'car_year': car.rows.first.assoc()['year'],
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

  } : {booking =
  {
    'id': data['id'],
    'sid': data['sid'],
    'cid': data['cid'],
    'uid': data['uid'],
    'garage': data['garage'],
    'garage_name': garage_name,
    'car_brand': car.rows.first.assoc()['brand'],
    'car_reg': car.rows.first.assoc()['car_reg'],
    'car_model': car.rows.first.assoc()['model'],
    'car_year': car.rows.first.assoc()['year'],
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
    await  sql.execute("update booking set status = 'time is up' where id = ${data['id']}"),
  };
  return booking;
}

Future<void> editBooking(MySQLConnection sql, {required id, required dateTime, required ownerName, required ownerEmail, required ownerPhone, required delivery, required pickUp}) async {
  await sql.execute("update booking set delivery = '$delivery', pickup = '$pickUp', date_time= '$dateTime', owner_name='$ownerName', owner_email='$ownerEmail', owner_phone='$ownerPhone'  where id = $id");
}