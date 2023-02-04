import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env.dev')
abstract class Env {
  @EnviedField(varName: 'DEV_TOKEN', obfuscate: true)
  static final devToken = _Env.devToken;
}
