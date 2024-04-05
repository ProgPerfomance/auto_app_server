import 'package:mysql_client/mysql_client.dart';

Future<String> generateCarHtml (MySQLConnection sql, id) async {
 final response = await sql.execute("select * from carlist where id=$id");

 String htmlContent = '''
      <html>
      <head>
        <title>{{id}}</title>
      </head>
      <body>
        <h1>Welcome to my HTML Page</h1>
        <p>This is a sample HTML page served by Dart server.</p>
      </body>
      </html>
    ''';
 return htmlContent;
}