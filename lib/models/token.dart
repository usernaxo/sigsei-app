import 'dart:convert';

import 'package:sigsei/models/usuario.dart';

class Token {

  Usuario user;
  String accessToken;
  String tokenType;
  int expiresIn;

  Token({
    required this.user,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory Token.fromJson(String str) => Token.fromMap(json.decode(str));

  factory Token.fromMap(Map<String, dynamic> json) => Token(
    user: Usuario.fromMap(json["user"]),
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
  );

}
