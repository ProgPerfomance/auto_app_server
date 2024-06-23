import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:uuid/uuid.dart';

void sendMail(mail) async {
  final smtpServer = gmail('jekcatpopov@gmail.com', 'favq gose ivmu qwvi');

  final message = Message()
    ..from = Address('jekcatpopov@gmail.com', 'DWD')
    ..recipients.add('jekcatpopov@mail.ru')
    ..subject = 'Forgot password'
    ..text = ''
    ..html = "<h1>New password</h1>\n<p>$mail</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. \n${e.toString()}');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
