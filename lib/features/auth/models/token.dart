class Token {
  AccessToken access;
  String refresh;

  Token({
    required this.access,
    required this.refresh,
  });

  factory Token.fromMap(Map<String, dynamic> map) {
    return Token(
      access: AccessToken.fromMap(map['access']),
      refresh: map['refresh'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'access': access.toMap(),
      'refresh': refresh,
    };
  }
}

class AccessToken {
  String token;
  String expiresIn;

  AccessToken({
    required this.token,
    required this.expiresIn,
  });

  factory AccessToken.fromMap(Map<String, dynamic> map) {
    return AccessToken(
      token: map['token'],
      expiresIn: map['expires_in'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'expires_in': expiresIn,
    };
  }
}
