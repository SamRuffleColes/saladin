import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:saladin/Model/HexColor.dart';
import 'package:saladin/Model/guide.dart';
import 'package:saladin/Model/miniature_paint.dart';
import 'package:saladin/Resources/strings.dart';
import 'package:uuid/uuid.dart';

import 'bloc.dart';

class GuidesBloc implements Bloc {
  final CollectionReference _guidesCollection = Firestore.instance.collection("Guides");

  final _controller = StreamController<List<Guide>>.broadcast();

  Stream<List<Guide>> get guidesStream => _controller.stream;

  void fetchAll(FirebaseUser user) async {
    QuerySnapshot querySnapshot =
        await _guidesCollection.where("userId", isEqualTo: user.uid).getDocuments(source: Source.serverAndCache);

    List<Guide> guides = await Future.wait(querySnapshot.documents.map((doc) => _mapToGuide(doc.data)).toList());

    _controller.sink.add(guides);
  }

  Future<Guide> create(FirebaseUser user, File image, Guide guide) async {
    String imageId = Uuid().v1();

    if (image != null) {
      StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child(imageId).putFile(image);
      await uploadTask.onComplete;
      if (!uploadTask.isSuccessful) {
        imageId = "";
      }
    }

    return Firestore.instance.runTransaction((Transaction tx) async {
      final DocumentSnapshot newDoc = await tx.get(_guidesCollection.document());

      final Map<String, dynamic> data = {
        "name": guide.name,
        "userId": user.uid,
        "imageId": imageId,
        "steps": _stepsToMapList(guide.steps),
        "created": new DateTime.now().toUtc().toIso8601String()
      };
      await tx.set(newDoc.reference, data);
      return data;
    }).then((data) => _mapToGuide(data));
  }

  Future<Guide> _mapToGuide(Map<String, dynamic> map) async {
    String name = _thisOrUnknownIfNull(map["name"]);

    List<GuideStep> steps = _thisOrEmptyListIfNull(map["steps"]);

    String imageId = map["imageId"];
    if (imageId.isEmpty) {
      return Guide(name, steps: steps);
    } else {
      String imageUrl = "";
      try {
        imageUrl = await FirebaseStorage.instance.ref().child(imageId).getDownloadURL();
      } catch (e) {
        print(e);
      }
      return Guide(name, imageUrl: imageUrl, steps: steps);
    }
  }

  String _thisOrUnknownIfNull(dynamic field) {
    if (field == null || !(field is String)) return Strings.unknown;
    return field;
  }

  List<GuideStep> _thisOrEmptyListIfNull(List<dynamic> stepsMaps) {
    if (stepsMaps == null || stepsMaps.isEmpty) {
      return [];
    } else {
      return stepsMaps.map((stepMap) => _mapToStep(stepMap)).toList();
    }
  }

  GuideStep _mapToStep(dynamic stepMap) {
    String verb = _thisOrUnknownIfNull(stepMap["verb"]);
    MiniaturePaint paint = _mapToMiniaturePaint(stepMap["miniaturePaint"]);
    String notes = _thisOrUnknownIfNull(stepMap["notes"]);
    return GuideStep(verb, miniaturePaint: paint, notes: notes);
  }

  MiniaturePaint _mapToMiniaturePaint(dynamic miniaturePaintMap) {
    if (miniaturePaintMap == null || miniaturePaintMap.isEmpty) {
      return null;
    }
    String name = _thisOrUnknownIfNull(miniaturePaintMap["name"]);
    String manufacturer = _thisOrUnknownIfNull(miniaturePaintMap["manufacturer"]);
    String range = _thisOrUnknownIfNull(miniaturePaintMap["range"]);
    HexColor color = _thisOrWhiteIfNotColor(miniaturePaintMap["color"]);
    return MiniaturePaint(name, manufacturer, range, color);
  }

  HexColor _thisOrWhiteIfNotColor(dynamic field) {
    if (field == null || !(field is String)) return HexColor.white();
    return HexColor(field);
  }

  List<Map<String, dynamic>> _stepsToMapList(List<GuideStep> steps) => steps.map((step) {
        Map<String, dynamic> map = {"verb": step.verb, "notes": step.notes};
        if (step.miniaturePaint != null) {
          map["miniaturePaint"] = {
            "name": step.miniaturePaint.name,
            "manufacturer": step.miniaturePaint.manufacturer,
            "range": step.miniaturePaint.range,
            "color": step.miniaturePaint.color.toHex()
          };
        }
        return map;
      }).toList();

  @override
  void dispose() {
    _controller.close();
  }
}
