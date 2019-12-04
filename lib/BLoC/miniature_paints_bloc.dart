import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saladin/Model/miniature_paint.dart';
import 'package:saladin/Resources/strings.dart';

import 'bloc.dart';

class MiniaturePaintsBloc implements Bloc {
  final CollectionReference _miniaturePaintsCollection = Firestore.instance.collection("MiniaturePaints");

  final _controller = StreamController<List<MiniaturePaint>>.broadcast();

  Stream<List<MiniaturePaint>> get miniaturePaintsStream => _controller.stream;

  void fetchAll() async {
    QuerySnapshot querySnapshot = await _miniaturePaintsCollection.getDocuments(source: Source.serverAndCache);
    List<MiniaturePaint> miniaturePaints = querySnapshot.documents.map((doc) => _docToMiniaturePaint(doc)).toList();
    miniaturePaints.sort((a, b) => a.name.compareTo(b.name));
    _controller.sink.add(miniaturePaints);
  }

  void filterByManufacturer(Set<String> selectedManufacturers) async {
    List<Query> queries = selectedManufacturers
        .map((manufacturer) => _miniaturePaintsCollection.where("manufacturer", isEqualTo: manufacturer))
        .toList();

    List<MiniaturePaint> miniaturePaints = [];
    for (var q in queries) {
      var snapshot = await q.getDocuments(source: Source.cache);
      var paintsToAdd = snapshot.documents.map((doc) => _docToMiniaturePaint(doc)).toList();
      miniaturePaints.addAll(paintsToAdd);
    }

    miniaturePaints.sort((a, b) => a.name.compareTo(b.name));
    _controller.sink.add(miniaturePaints);
  }

  MiniaturePaint _docToMiniaturePaint(DocumentSnapshot doc) {
    String name = _thisOrUnknownIfNull(doc.data["name"]);
    String manufacturer = _thisOrUnknownIfNull(doc.data["manufacturer"]);
    String range = _thisOrUnknownIfNull(doc.data["range"]);
    String sku = _thisOrEmptyIfNull(doc.data["sku"]);
    String color = _thisOrEmptyIfNull(doc.data["color"]);

    return MiniaturePaint(name, manufacturer, range, sku, color);
  }

  String _thisOrUnknownIfNull(dynamic field) {
    if (field == null || !(field is String)) return Strings.unknown;
    return field;
  }

  String _thisOrEmptyIfNull(dynamic field) {
    if (field == null || !(field is String)) return "";
    return field;
  }

  @override
  void dispose() {
    _controller.close();
  }
}
