import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // Obtener usuario y sesión actual
  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;

  // Registro compatible con Web, Móvil y sin error de redirección
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    
    return await _client.auth.signUp(
      email: cleanEmail,
      password: password.trim(),
      emailRedirectTo: kIsWeb ? Uri.base.origin : null,
    );
  }

  // Inicio de sesión
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    
    return await _client.auth.signInWithPassword(
      email: cleanEmail,
      password: password.trim(),
    );
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}