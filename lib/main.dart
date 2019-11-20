import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:saladin/Resources/strings.dart';

import 'UI/Screen/splash_screen.dart';

void main() {
  initialiseCrashlytics();
  runApp(SaladinApp());
}

void initialiseCrashlytics() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
}

class SaladinApp extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Strings.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreenWidget(),
        navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)]);
  }
}
