import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Connection to this app's Supabase project. The publishable key is safe in
/// app code: row level security in Supabase decides what each user may read or write.
class Backend {
  static const url = 'https://suiqreqnohwsplpsldhz.supabase.co';
  static const key = 'sb_publishable_CIxHmJiv3Sx82kPClB2mrw_wouKvg1j';
  static Object? initError;

  static Future<void> init() async {
    try {
      // Implicit flow: one-time codes typed in the app are checked directly.
      // (PKCE is only needed for browser redirects, which this app does not use.)
      await Supabase.initialize(
        url: url,
        anonKey: key,
        authOptions: const FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
      );
    } catch (e) {
      initError = e;
    }
  }

  static SupabaseClient get _db {
    if (initError != null) throw Exception('Could not connect to Supabase: $initError');
    return Supabase.instance.client;
  }

  static bool get isSignedIn {
    try {
      return _db.auth.currentUser != null;
    } catch (_) {
      return false;
    }
  }

  static String? get userEmail {
    try {
      return _db.auth.currentUser?.email;
    } catch (_) {
      return null;
    }
  }

  static Future<void> signIn(String email, String password) async {
    await _db.auth.signInWithPassword(email: email, password: password);
  }

  static Future<void> signUp(String email, String password, {String name = ''}) async {
    final res = await _db.auth.signUp(email: email, password: password, data: {'full_name': name});
    if (res.session == null) {
      throw Exception('Account created. Open the confirmation email, then sign in.');
    }
  }

  static Future<void> signOut() async {
    await _db.auth.signOut();
  }

  // One-time codes (OTP). The email or phone is remembered between the
  // "Send code" and "Verify" pages.
  static String? _pending;
  static bool _pendingPhone = false;

  static Future<void> sendCode(String contact, {bool phone = false}) async {
    final to = contact.isNotEmpty ? contact : (_pending ?? '');
    if (to.isEmpty) throw Exception(phone ? 'Enter your phone number with country code, e.g. +91…' : 'Enter your email address.');
    if (phone) {
      await _db.auth.signInWithOtp(phone: to);
    } else {
      await _db.auth.signInWithOtp(email: to);
    }
    _pending = to;
    _pendingPhone = phone;
  }

  static Future<void> verifyCode(String code, {String contact = '', bool phone = false}) async {
    code = code.replaceAll(RegExp(r'[^0-9]'), '');
    final to = contact.isNotEmpty ? contact : _pending;
    final byPhone = contact.isNotEmpty ? phone : _pendingPhone;
    if (to == null || to.isEmpty) throw Exception('Tap "Send code" first.');
    if (code.length < 4) throw Exception(byPhone ? 'Enter the code from the SMS.' : 'Enter the code from the email.');
    if (byPhone) {
      await _db.auth.verifyOTP(type: OtpType.sms, phone: to, token: code);
    } else {
      await _db.auth.verifyOTP(type: OtpType.email, email: to, token: code);
    }
  }

  static Future<List<Map<String, dynamic>>> list(String table, {int limit = 50}) async {
    final rows = await _db.from(table).select().limit(limit);
    return List<Map<String, dynamic>>.from(rows);
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    await _db.from(table).insert(data);
  }
}

String friendlyError(Object e) {
  if (e is AuthException) {
    final m = e.message;
    if (RegExp('error sending', caseSensitive: false).hasMatch(m)) {
      return 'Supabase could not send the email. Check Authentication → Emails → SMTP settings (host, port 587, Gmail app password).';
    }
    if (RegExp('expired or is invalid', caseSensitive: false).hasMatch(m)) {
      return 'That code is wrong or too old. Use the code from the NEWEST email only (each "Send code" replaces the last one), or tap Send code again.';
    }
    if (RegExp('rate limit', caseSensitive: false).hasMatch(m)) {
      return 'Too many codes were requested. Wait a few minutes and try again.';
    }
    return m;
  }
  if (e is PostgrestException) return e.message;
  return e.toString().replaceFirst('Exception: ', '');
}

/// Fills {{field}} placeholders from a data-list row, and {{user.email}}
/// from the signed-in user.
String fill(Map<String, dynamic>? item, String template) {
  return template.replaceAllMapped(RegExp(r'\{\{\s*([\w.]+)\s*\}\}'), (m) {
    final key = m[1]!;
    if (key == 'user.email') return Backend.userEmail ?? '';
    Object? value = item;
    for (final part in key.split('.')) {
      final index = int.tryParse(part);
      if (value is Map) {
        value = value[part];
      } else if (value is List && index != null && index < value.length) {
        value = value[index];
      } else {
        value = null;
      }
    }
    if (value is List) return value.join(', ');
    return value?.toString() ?? '';
  });
}

/// Shows [child] to signed-in users and [login] to everyone else.
class AuthGuard extends StatelessWidget {
  const AuthGuard({super.key, required this.child, this.login});

  final Widget child;
  final Widget? login;

  @override
  Widget build(BuildContext context) => Backend.isSignedIn ? child : (login ?? const SignInRequired());
}

class SignInRequired extends StatelessWidget {
  const SignInRequired({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Please sign in to see this page.', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
