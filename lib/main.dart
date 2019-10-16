import 'package:flutter/material.dart';
import 'package:saladin/BLoC/bloc_provider.dart';
import 'package:saladin/BLoC/miniature_paints_bloc.dart';
import 'package:saladin/Resources/strings.dart';
import 'package:saladin/UI/Screen/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MiniaturePaintsBloc>(
        bloc: MiniaturePaintsBloc(),
        child: MaterialApp(
          title: Strings.appTitle,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreenWidget(),
        ));
  }
}
