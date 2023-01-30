class JwtGen {
  static const String musickitKey = '''<>''';

  static const String alg = '<>';
  static const String kid = '<>';
  static const String iss = '<>';
  static const int sixMonthsInSeconds = 15776000;

  static String generate256SignedJWT() {
    return r'<>';

    // code below is currently not working, will have to fix

    // int iat = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    // int exp = iat + 500000;

    // var header = <String, dynamic>{"alg": "ES256", "kid": "----"};
    // var payload = <String, dynamic>{"iss": iss, "iat": iat, "exp": exp};

    // List<int> headerBytes = utf8.encode(json.encode(header));
    // List<int> payloadBytes = utf8.encode(json.encode(payload));

    // var base64Header = base64UrlEncode(headerBytes)
    //     .replaceAll('+', '-')
    //     .replaceAll('/', '_')
    //     .replaceAll("=", "");
    // var base64Payload = base64UrlEncode((payloadBytes))
    //     .replaceAll('+', '-')
    //     .replaceAll('/', '_')
    //     .replaceAll("=", "");

    // List<int> keyBytes = base64.decode(musickitKey);
    // List<int> signatureBytes = utf8.encode(('$base64Header.$base64Payload'));
    // var base64Signature =
    //     base64Encode((Hmac(sha256, keyBytes).convert(signatureBytes)).bytes)
    //         .replaceAll('+', '-')
    //         .replaceAll('/', '_')
    //         .replaceAll("=", "");
    // return '$base64Header.$base64Payload.$base64Signature';
  }
}
