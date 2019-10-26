import 'package:flutter/material.dart';
import 'package:saladin/Model/miniature_paint.dart';
import 'package:saladin/Resources/strings.dart';
import 'package:saladin/UI/Screen/miniature_paints_screen.dart';

/// This screen allows testing of the MiniaturePaint returned from the MiniaturePaintsScreen=

class PaintSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.miniaturePaintsScreenTitle)),
      body: PaintSelectionWidget(),
    );
  }
}

class PaintSelectionWidget extends StatefulWidget {
  @override
  createState() => PaintSelectionState();
}

class PaintSelectionState extends State<PaintSelectionWidget> {
  MiniaturePaint _selectedPaint;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      RaisedButton(
          child: Text("CHOOSE PAINT"),
          onPressed: () async {
            _selectedPaint = await Navigator.of(context)
                .push(MaterialPageRoute<MiniaturePaint>(builder: (context) => MiniaturePaintsScreen()));
          }),
      Text(_selectedPaint != null ? _selectedPaint.name : "none selected")
    ]));
  }
}

