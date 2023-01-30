import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/services/authentication_service.dart';
import 'package:musicnya/services/locator_service.dart';
import 'package:musicnya/services/navigation_service.dart';

class AuthenticationPromptView extends StatefulWidget {
  const AuthenticationPromptView({super.key});

  @override
  State<StatefulWidget> createState() => AuthenticationPromptViewState();
}

class AuthenticationPromptViewState extends State<AuthenticationPromptView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: SizedBox(
                height: screenHeight / 2,
                width: screenWidth,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Connect Musicnya to Apple Music?",
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: screenWidth / 1.5,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding),
                              child: Text(
                                textAlign: TextAlign.center,
                                "To use all Musicnya features, it is recommended to connect to your Apple Music account.",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.w400),
                              ))),
                      OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => primaryColor),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => secondaryColor)),
                          onPressed: () {
                            GetIt.I<AuthenticationService>()
                                .startAuthentication();
                          },
                          child: const Text("Continue to Apple Music")),
                      OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.redAccent),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => secondaryColor)),
                          onPressed: () {
                            serviceLocator<AuthenticationService>()
                                .userRefused = true;
                            Navigator.of(serviceLocator<NavigationService>()
                                    .navigatorKey
                                    .currentContext!)
                                .pushNamed('/');
                          },
                          child: const Text("Remind me later")),
                    ]))));
  }
}
