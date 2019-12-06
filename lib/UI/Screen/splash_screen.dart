import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:saladin/Auth/auth.dart';
import 'package:saladin/Resources/app_palette.dart';
import 'package:saladin/Resources/dimensions.dart';
import 'package:saladin/Resources/strings.dart';
import 'package:saladin/UI/Screen/guides_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final Auth auth = Auth();

  @override
  void initState() {
    _checkIfAlreadySignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image(
          image: AssetImage("assets/images/splash.jpg"),
          alignment: Alignment.center,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity),
      Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(top: Dimensions.extraLargeSpacing, bottom: Dimensions.mediumSpacing),
          child: Column(children: [
            Text(Strings.appTitle, style: TextStyle(fontSize: 60.0, color: AppPalette.primary, decoration: TextDecoration.none, fontFamily: "Alfa Slab One")),
            Expanded(child: Container()),
            SignInButton(Buttons.Google, onPressed: _googleSignIn)
          ]))
    ]);
  }

  _checkIfAlreadySignedIn() {
    auth.currentUser().then((user) => _navigateToGuidesScreen()).catchError((e) => print(e));
  }

  _googleSignIn() {
    auth.googleSignIn().then((user) => _navigateToGuidesScreen()).catchError((e) => _showSignInError(e));
  }

  _navigateToGuidesScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GuidesScreen()));
  }

  _showSignInError(e) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(Strings.signInErrorTitle),
              content: Text(e.toString()),
              actions: <Widget>[
                FlatButton(
                  child: Text(Strings.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
