import 'package:flutter/material.dart';
import 'package:saladin/Resources/dimensions.dart';

class LoadingWidget extends StatelessWidget {
  final String _message;

  LoadingWidget(this._message);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(padding: EdgeInsets.only(bottom: Dimensions.largePadding), child: CircularProgressIndicator()),
          Text(_message)
        ]);
  }
}
