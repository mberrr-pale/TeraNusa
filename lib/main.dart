import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/supabase_config.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
    await SupabaseConfig.initialize();

    runApp(const ProviderScope(child: MyApp()));
  } catch (e, stackTrace) {
    debugPrint('Initialization error: $e');
    debugPrintStack(stackTrace: stackTrace);

    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Gagal menginisialisasi aplikasi. Silakan coba kembali.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
