import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class TokenScret {
  final String username;
  final String password;

  TokenScret({this.username = "", this.password = ""});

  factory TokenScret.fromJson(Map<String, dynamic> jsonMap) {
    return new TokenScret(
        username: jsonMap["username"], password: jsonMap["password"]);
  }
}

class SecretLoader {
  final String? secretPath;

  SecretLoader({this.secretPath});

  Future<TokenScret> load() {
    return rootBundle.loadStructuredData<TokenScret>(this.secretPath!,
        (jsonStr) async {
      final secret = TokenScret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}
