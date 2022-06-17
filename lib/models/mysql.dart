// import 'package:mysql1/mysql1.dart';
// import '../widgets/new_transaction.dart';

  // Future getConnection() async {
  //   final conn = await MySqlConnection.connect(ConnectionSettings(
  //     host: '127.0.0.1',
  //     port: 3306,
  //     user: 'root',
  //     password: 'Chandu@1234',
  //     db: 'transaction'
  //   ));

  //   var result = await conn.query(
  //       'insert into spends (title, amount, created_at) values (?, ?, ?)',
  //       ['home', 45.26, '2022-06-17']
  //     );
  //     print('inserted row id=${result.insertId}');

  //     await conn.close();
  // }



import 'package:mysql1/mysql1.dart';

class Mysql{
  static String host = '127.0.0.1',
                user = 'root',
                password = 'Chandu@1234',
                db = 'transaction';
  static int port  = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings (
      host: host,
      port: port,
      user: user,
      password: password,
      db: db
    );
    return await MySqlConnection.connect(settings);
  }
}