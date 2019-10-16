import 'package:flutter/material.dart';

class FilterChips extends StatefulWidget {
  const FilterChips({Key key, this.filterLabels, this.onFiltersChanged}) : super(key: key);

  final List<String> filterLabels;
  final Function(Set<String>) onFiltersChanged;

  @override
  State<StatefulWidget> createState() => FilterChipsState(filterLabels, onFiltersChanged);
}

class FilterChipsState extends State<FilterChips> {
  final Set<String> _filters = <String>{};
  final Set<String> _selectedFilters = <String>{};
  final Function(Set<String>) onFiltersChanged;

  FilterChipsState(List<String> filterLabels, this.onFiltersChanged) {
    _filters.addAll(filterLabels.toSet());
    _selectedFilters.addAll(filterLabels.toSet());
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: _constructChildren(_filters).map<Widget>((Widget chip) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: chip,
      );
    }).toList());
  }

  List<Widget> _constructChildren(Set<String> labels) {
    return labels.map<Widget>((String name) {
      return FilterChip(
        key: ValueKey<String>(name),
        label: Text(name),
        selected: _selectedFilters.contains(name),
        onSelected: (bool value) {
          setState(() {
            if (!value) {
              _selectedFilters.remove(name);
            } else {
              _selectedFilters.add(name);
            }
            onFiltersChanged(_selectedFilters);
          });
        },
      );
    }).toList();
  }
}
