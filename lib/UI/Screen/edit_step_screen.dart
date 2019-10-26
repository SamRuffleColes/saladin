import 'package:flutter/material.dart';
import 'package:saladin/Resources/dimensions.dart';
import 'package:saladin/Resources/strings.dart';

class EditStepScreen extends StatefulWidget {
  @override
  createState() => EditStepState();
}

class EditStepState extends State<EditStepScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Strings.editStepScreenTitle)),
        body: Center(
            child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                  TextFormField(
//                      decoration: InputDecoration(
//                          labelText: Strings.nameLabel, contentPadding: EdgeInsets.all(Dimensions.standardPadding)),
//                      validator: (value) => value.isEmpty ? Strings.nameValidationError : null,
//                      onSaved: (String value) => _name = value)
                ]))));
  }
}
