import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saladin/Auth/auth.dart';
import 'package:saladin/BLoC/guides_bloc.dart';
import 'package:saladin/Model/guide.dart';
import 'package:saladin/Resources/app_palette.dart';
import 'package:saladin/Resources/dimensions.dart';
import 'package:saladin/Resources/strings.dart';
import 'package:saladin/UI/Screen/edit_step_screen.dart';
import 'package:saladin/UI/Widget/loading_widget.dart';
import 'package:saladin/UI/Widget/step_list_widget.dart';

class EditGuideScreen extends StatefulWidget {
  @override
  createState() => EditGuideState();
}

class EditGuideState extends State<EditGuideScreen> {
  final Auth auth = Auth();
  final _formKey = GlobalKey<FormState>();
  final _bloc = GuidesBloc();

  File _image;
  String _name = "";
  bool _isUploading = false;

  final List<GuideStep> _steps = [
    GuideStep("Basecoat", notes: "Basecoat the entire miniature in blue"),
    GuideStep("Drybush", notes: "Gently drybrush the miniature's legs"),
    GuideStep("Edge Highlight", notes: "Edge highlight the lot in light blue"),
    GuideStep("Varnish", notes: "Use rattlecan spray varnish to cover the lot"),
    GuideStep("Basecoat", notes: "Basecoat the entire miniature in blue"),
    GuideStep("Drybush", notes: "Gently drybrush the miniature's legs"),
    GuideStep("Edge Highlight", notes: "Edge highlight the lot in light blue"),
    GuideStep("Varnish", notes: "Use rattlecan spray varnish to cover the lot")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.editGuideScreenTitle),
          automaticallyImplyLeading: false,
          actions: [IconButton(icon: Icon(Icons.save), onPressed: _onSavePressed)],
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: _addStep,
            label: Text(Strings.addNewStep),
            icon: Icon(Icons.add),
            backgroundColor: AppPalette.accent),
        body: Center(
            child: Form(
          key: _formKey,
          child: _isUploading
              ? LoadingWidget(Strings.uploadingGuide)
              : Container(
                  padding: const EdgeInsets.all(Dimensions.largePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                          decoration: InputDecoration(
                              labelText: Strings.nameLabel, contentPadding: EdgeInsets.all(Dimensions.standardPadding)),
                          validator: (value) => value.isEmpty ? Strings.nameValidationError : null,
                          onSaved: (String value) => _name = value),
                      Container(
                          padding: const EdgeInsets.all(Dimensions.largePadding),
                          alignment: Alignment.center,
                          child: _image == null
                              ? FlatButton(
                                  child: Container(
                                      padding: const EdgeInsets.all(Dimensions.largePadding),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: AppPalette.trim, width: Dimensions.borderWidth)),
                                      child:
                                          Column(children: [Icon(Icons.image), Text(Strings.selectImageFromDevice)])),
                                  onPressed: _selectImage)
                              : Image.file(_image, alignment: Alignment.center, fit: BoxFit.fitWidth)),
                      Expanded(child: StepListWidget(_steps))
                    ],
                  )),
        )));
  }

  _onSavePressed() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _submit();
    } else {
      _toast(Strings.submitGuideValidationErrors);
    }
  }

  _submit() {
    setState(() => _isUploading = true);
    Guide guide = Guide(_name);
    auth.currentUser().then((user) => _createGuide(user, guide));
  }

  _createGuide(FirebaseUser user, Guide guide) {
    _bloc
        .create(user, _image, guide)
        .then((guide) => Navigator.of(context).pop())
        .catchError((e) => _onCreateGuideError());
  }

  _onCreateGuideError() {
    _toast(Strings.errorUploadingGuide);
    setState(() => _isUploading = false);
  }

  Future _selectImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() => _image = image);
  }

  _toast(String message) => Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));

  _addStep() async {
    final GuideStep step =
        await Navigator.of(context).push(MaterialPageRoute<GuideStep>(builder: (context) => EditStepScreen()));

    if (step != null) {
      _steps.add(step);
    }
  }
}
