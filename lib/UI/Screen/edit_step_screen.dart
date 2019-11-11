import 'package:flutter/material.dart';
import 'package:saladin/Model/guide.dart';
import 'package:saladin/Model/miniature_paint.dart';
import 'package:saladin/Resources/dimensions.dart';
import 'package:saladin/Resources/strings.dart';
import 'package:saladin/UI/Screen/miniature_paints_screen.dart';
import 'package:saladin/UI/Widget/verb_selection_widget.dart';

class EditStepScreen extends StatefulWidget {
  @override
  createState() => EditStepState();
}

class EditStepState extends State<EditStepScreen> {
  final _formKey = GlobalKey<FormState>();

  MiniaturePaint _miniaturePaint;
  String _notes = "";
  VerbSelectionWidget verbSelectionWidget = VerbSelectionWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(Strings.editStepScreenTitle),
            actions: [IconButton(icon: Icon(Icons.save), onPressed: _onSavePressed)]),
        body: Container(
          padding: const EdgeInsets.all(Dimensions.largePadding),
          child: Center(
              child: Form(
                  key: _formKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(child: Text("Verb"), padding: const EdgeInsets.only(left: Dimensions.standardPadding)),
                    verbSelectionWidget,
                    Container(
                        child: Text("Paint"),
                        padding: const EdgeInsets.only(top: Dimensions.largePadding, left: Dimensions.standardPadding)),
                    Container(
                      padding: const EdgeInsets.only(top: Dimensions.largePadding, bottom: Dimensions.largePadding),
                      child: Row(children: [
                        Expanded(
                            child: Card(
                                color: _miniaturePaint == null ? Colors.white : _miniaturePaint.color,
                                child: Container(
                                    height: Dimensions.buttonHeight,
                                    padding: const EdgeInsets.all(Dimensions.standardPadding),
                                    child: Visibility(
                                      visible: _miniaturePaint != null,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(_miniaturePaint?.name ?? "",
                                              style: TextStyle(backgroundColor: Colors.black45, color: Colors.white)),
                                          Text(
                                              "${_miniaturePaint?.manufacturer ?? ""} (${_miniaturePaint?.range ?? ""})",
                                              style: TextStyle(backgroundColor: Colors.black45, color: Colors.white))
                                        ],
                                      ),
                                    )))),
                        RaisedButton(
                            child: Container(
                                height: Dimensions.buttonHeight,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Icon(Icons.palette), Text(Strings.change)])),
                            onPressed: _selectPaint)
                      ]),
                    ),
                    TextFormField(
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            labelText: Strings.notesLabel, contentPadding: EdgeInsets.all(Dimensions.standardPadding)),
                        onSaved: (String value) => _notes = value)
                  ]))),
        ));
  }

  _selectPaint() async => _miniaturePaint = await Navigator.of(context)
      .push(MaterialPageRoute<MiniaturePaint>(builder: (context) => MiniaturePaintsScreen()));

  _onSavePressed() {
    String verb = verbSelectionWidget.verb;

    if (_formKey.currentState.validate() && verb.isNotEmpty) {
      _formKey.currentState.save();
      GuideStep step = GuideStep(verb, miniaturePaint: _miniaturePaint, notes: _notes);
      Navigator.of(context).pop(step);
    } else {
      //toast validation errors
    }
  }
}
