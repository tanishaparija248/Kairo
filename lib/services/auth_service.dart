import 'dart:convert';
import 'package:supertokens_flutter/http.dart' as st_http;
import 'package:supertokens_flutter/supertokens.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Check if the user is currently logged in with SuperTokens
  Future<bool> isLoggedin() async {
    return await SuperTokens.doesSessionExist();
  }

  /// Sign in with email and password using the SuperTokens SDK client
  Future<void> signIn(String email, String password) async {
    final url = Uri.parse('https://api.lemma.work/st/auth/signin');
    
    // We use st_http.post because it automatically handles session headers
    final response = await st_http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'rid': 'emailpassword',
      },
      body: jsonEncode({
        'formFields': [
          {'id': 'email', 'value': email},
          {'id': 'password', 'value': password},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['status'] == 'OK') {
        return;
      } else {
        throw Exception(body['message'] ?? 'Sign in failed');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  /// Sign out the user from SuperTokens
  Future<void> signOut() async {
    await SuperTokens.signOut();
  }
}
