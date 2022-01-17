import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class Secret {
  final String user;
  final String pwd;

  Secret({this.user = "", this.pwd = ""});

  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(user: jsonMap["user"], pwd: jsonMap["pwd"]);
  }
}

class SecretLoader {
  final String? secretPath;

  SecretLoader({this.secretPath});

  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(this.secretPath!,
        (jsonStr) async {
      final secret = Secret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}
