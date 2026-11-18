import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final internetStatusProvider = StreamProvider<bool>((ref) async* {
  final connection = InternetConnection();

  // Periksa status internet pertama kali.
  yield await connection.hasInternetAccess;

  // Dengarkan perubahan status internet.
  await for (final status in connection.onStatusChange) {
    yield status == InternetStatus.connected;
  }
});
