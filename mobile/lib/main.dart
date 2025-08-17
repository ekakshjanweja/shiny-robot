import 'package:flutter/material.dart';
import 'package:mobile/src/app.dart';
import 'package:mobile/src/core/audio/providers/audio_service_provider.dart';
import 'package:mobile/src/core/constants/config.dart';
import 'package:better_auth_flutter/better_auth_flutter.dart';
import 'package:mobile/src/core/local_storage/kv_store.dart';
import 'package:mobile/src/modules/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AudioServiceProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> bootstrap() async {
  await BetterAuthFlutter.initialize(
    url: Uri(
      scheme: AppConfig.scheme,
      host: AppConfig.host,
      port: AppConfig.port,
      path: "/api/auth",
    ).toString(),
  );
  await KVStore.init();
}
