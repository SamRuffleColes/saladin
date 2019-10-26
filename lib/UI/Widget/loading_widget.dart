import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String _message;

  LoadingWidget(this._message);

  @override
  Widget build(BuildContext context) {
    return Column(children: [CircularProgressIndicator(), Text(_message)]);
  }
}
