import 'package:mysql_client/mysql_client.dart';

class Database {
  static Future<MySQLConnection> connect({String? databaseName = 'linea61'}) async {
    final connection = await MySQLConnection.createConnection(
      host: '127.0.0.1',
      port: 3306,
      userName: 'root',
      password: '',
      databaseName: databaseName,
    );
    await connection.connect();
    return connection;
  }
}
