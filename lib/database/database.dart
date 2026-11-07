import 'dart:io';

import 'package:mysql_client/mysql_client.dart';

class Database {
  static Future<MySQLConnection> connect({String? databaseName}) async {
    final env = Platform.environment;
    final connection = await MySQLConnection.createConnection(
      host: env['DB_HOST'] ?? '127.0.0.1',
      port: int.tryParse(env['DB_PORT'] ?? '') ?? 3306,
      userName: env['DB_USERNAME'] ?? 'root',
      password: env['DB_PASSWORD'] ?? '',
      databaseName: databaseName ?? env['DB_DATABASE'] ?? 'linea61',
    );
    await connection.connect();
    return connection;
  }
}
