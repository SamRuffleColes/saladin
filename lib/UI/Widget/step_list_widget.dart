import 'package:flutter/material.dart';
import 'package:saladin/Model/guide.dart';

class StepListWidget extends StatefulWidget {
  final List<GuideStep> steps;

  StepListWidget(this.steps);

  @override
  createState() => StepListState(steps);
}

class StepListState extends State<StepListWidget> {
  final List<GuideStep> steps;

  StepListState(this.steps);

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
        children: List.generate(steps.length, (index) => _listItem(index)),
        onReorder: (oldIndex, newIndex) => setState(() => _reorderSteps(oldIndex, newIndex)));
  }

  Widget _listItem(int index) {
    final GuideStep step = steps[index];
    return Card(
        key: ValueKey("value$index"),
        child: ListTile(leading: Icon(Icons.local_pizza), title: Text(step.verb), subtitle: Text(step.notes)));
  }

  _reorderSteps(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final GuideStep item = steps.removeAt(oldIndex);
    steps.insert(newIndex, item);
  }
}
