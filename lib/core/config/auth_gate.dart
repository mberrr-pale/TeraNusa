import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  StreamSubscription<AuthState>? authSubscription;

  bool loading = true;
  bool authenticated = false;

  @override
  void initState() {
    super.initState();

    initializeAuth();
  }

  void initializeAuth() {
    final supabase = Supabase.instance.client;

    // Periksa session awal.
    authenticated = supabase.auth.currentSession != null;

    loading = false;

    // Dengarkan perubahan autentikasi.
    authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (!mounted) return;

      setState(() {
        authenticated = data.session != null;
      });
    });
  }

  @override
  void dispose() {
    authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authenticated) {
      return const HomePage();
    }

    return const LoginPage();
  }
}
