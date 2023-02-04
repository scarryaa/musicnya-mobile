@JS()
library app.js;

import 'package:js/js.dart';

@JS()
external dynamic configureMusicKit(String devToken);

@JS()
external String startAuthentication();

@JS()
external bool checkIfUserIsAuthorized();
