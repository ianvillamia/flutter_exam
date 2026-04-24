import 'package:flutter_exam/app/app.dart';
import 'package:flutter_exam/bootstrap.dart';
import 'package:flutter_modular/flutter_modular.dart';

Future<void> main() async {
  await bootstrap(
    () => ModularApp(module: AppModule(), child: const AppWidget()),
  );
}
