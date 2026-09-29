import 'package:untitled1/database/database.dart';

Future<void> main() async {
  print('Iniciando seeders...');

  final connection = await Database.connect();
  try {
    // TODO: Crear seeders para el sistema de control de turnos
    // - Turnos (mañana, tarde, noche)
    // - Rutas de ejemplo
    // - Paradas de ejemplo
    // - Usuarios de prueba
    // - Conductores de prueba
    // - Propietarios de prueba
    // - Micros de ejemplo

    print('Seeders ejecutados correctamente.');
  } catch (e) {
    print('Error al ejecutar seeders: $e');
  } finally {
    await connection.close();
  }
}
