import 'package:flutter/material.dart';
import 'package:saladin/Model/guide.dart';
import 'package:saladin/Resources/app_palette.dart';

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
    return Dismissible(
      key: ObjectKey(step),
      direction: DismissDirection.endToStart,
      background: Container(
          color: AppPalette.urgency,
          child: const Center(child: ListTile(trailing: Icon(Icons.delete, color: Colors.white, size: 36.0)))),
      onDismissed: (direction) => setState(() => steps.removeAt(index)),
      child: Card(
          key: ValueKey("value$index"),
          child: ListTile(leading: _leadingItem(step), title: Text(step.verb), subtitle: Text(step.notes))),
    );
  }

  _reorderSteps(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final GuideStep item = steps.removeAt(oldIndex);
    steps.insert(newIndex, item);
  }

  Widget _leadingItem(GuideStep step) {
    if (step.miniaturePaint != null) {
      return Container(color: step.miniaturePaint.color, width: 25.0, height: 25.0);
    } else {
      return Icon(Icons.drag_handle);
    }
  }
}
