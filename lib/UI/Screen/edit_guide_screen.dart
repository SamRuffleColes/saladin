import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saladin/Auth/auth.dart';
import 'package:saladin/BLoC/guides_bloc.dart';
import 'package:saladin/Model/guide.dart';
import 'package:saladin/Resources/dimensions.dart';
import 'package:saladin/Resources/strings.dart';

class EditGuideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Strings.editGuideScreenTitle), automaticallyImplyLeading: false),
        body: Center(child: EditGuideWidget()));
  }
}

class EditGuideWidget extends StatefulWidget {
  @override
  createState() => EditGuideState();
}

class EditGuideState extends State<EditGuideWidget> {
  final Auth auth = Auth();
  final _formKey = GlobalKey<FormState>();
  final _bloc = GuidesBloc();

  File _image;
  String _name = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(Dimensions.standardPadding),
              child: TextFormField(
                  decoration: InputDecoration(
                      labelText: Strings.nameLabel, contentPadding: EdgeInsets.all(Dimensions.standardPadding)),
                  validator: (value) => value.isEmpty ? Strings.nameValidationError : null,
                  onSaved: (String value) => _name = value)),
          Container(child: _image == null ? Text("peas select img") : Image.file(_image)),
          Container(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: _selectImage,
              )),
          Container(
            padding: const EdgeInsets.all(Dimensions.largePadding),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _submit();
                } else {
                  _toast("boo");
                }
              },
              child: Text(Strings.save),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    Guide guide = Guide(_name);
    auth.currentUser().then((user) {
      _bloc.create(user, guide);
      Navigator.of(context).pop();
    });
  }

  Future _selectImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);

    _toast("arrived back");

    setState(() {
      _toast("setting image");
      _image = image;
    });
  }

  _toast(String message) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
