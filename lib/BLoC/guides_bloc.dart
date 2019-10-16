import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saladin/Model/guide.dart';
import 'package:saladin/Resources/strings.dart';

import 'bloc.dart';

class GuidesBloc implements Bloc {
  final CollectionReference _guidesCollection = Firestore.instance.collection("Guides");

  final _controller = StreamController<List<Guide>>.broadcast();

  Stream<List<Guide>> get guidesStream => _controller.stream;

  void fetchAll(FirebaseUser user) async {
    QuerySnapshot querySnapshot =
        await _guidesCollection.where("uid", isEqualTo: user.uid).getDocuments(source: Source.serverAndCache);

    List<Guide> guides = querySnapshot.documents.map((doc) => _docToGuide(doc)).toList();

    _controller.sink.add(guides);
  }

  void create(FirebaseUser user, Guide guide) async {
    Firestore.instance.runTransaction((Transaction tx) async {
      final DocumentSnapshot newDoc = await tx.get(_guidesCollection.document());
      final Map<String, dynamic> data = {
        "name": guide.name,
        "uid": user.uid,
        "created": new DateTime.now().toUtc().toIso8601String()
      };
      await tx.set(newDoc.reference, data);
      return data;
    });
  }

  Guide _docToGuide(DocumentSnapshot doc) {
    String name = _thisOrUnknownIfNull(doc.data["name"]);
    return Guide(name);
  }

  String _thisOrUnknownIfNull(dynamic field) {
    if (field == null || !(field is String)) return Strings.unknown;
    return field;
  }

  @override
  void dispose() {
    _controller.close();
  }
}
