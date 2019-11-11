import 'package:flutter/material.dart';
import 'package:saladin/Resources/dimensions.dart';
import 'package:saladin/Resources/strings.dart';

class VerbSelectionWidget extends StatefulWidget {
  VerbSelectionState state;

  String get verb {
    if (state._selectedVerb == state._otherVerb) {
      return state._otherFieldController.text;
    } else {
      return state._selectedVerb;
    }
  }

  @override
  createState() => state = VerbSelectionState();
}

class VerbSelectionState extends State<VerbSelectionWidget> {
  List<String> _verbs = [];
  String _otherVerb;
  String _selectedVerb;

  var _otherFieldController = TextEditingController();

  VerbSelectionState() {
    _otherVerb = Strings.other;
    _verbs.addAll(Strings.stepVerbs);
    _verbs.add(_otherVerb);
    _selectedVerb = _verbs[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
            children: _verbs
                .map((verb) => Container(
                      padding: EdgeInsets.all(Dimensions.smallPadding),
                      child: ChoiceChip(
                          key: ValueKey(verb),
                          label: Text(verb),
                          selected: verb == _selectedVerb,
                          onSelected: (value) {
                            if (value) setState(() => _selectedVerb = verb);
                          }),
                    ))
                .toList()),
        Visibility(
          visible: _selectedVerb == _otherVerb,
          child: TextFormField(
            controller: _otherFieldController,
            decoration: InputDecoration(
                labelText: Strings.verbLabel, contentPadding: const EdgeInsets.all(Dimensions.standardPadding)),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _otherFieldController.dispose();
    super.dispose();
  }
}
