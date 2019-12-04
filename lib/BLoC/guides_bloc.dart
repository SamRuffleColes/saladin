import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

    List<Guide> guides = await Future.wait(querySnapshot.documents.map((doc) => _docToGuide(doc)).toList());

    _controller.sink.add(guides);
  }

  Future<void> create(FirebaseUser user, File image, Guide guide) async {
    String newImageId = "";

    if (image != null) {
      newImageId = Uuid().v1();
      StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child(newImageId).putFile(image);
      await uploadTask.onComplete;
      if (uploadTask.isSuccessful) {
        if (guide.image.id.isNotEmpty) {
          Future<void> deleteTask = FirebaseStorage.instance.ref().child(guide.image.id).delete();
          await deleteTask;
        }
      } else {
        if (guide.image.id.isEmpty) {
          newImageId = "";
        }
      }
    }

    if (guide.id.isEmpty) {
      //create new
      return Firestore.instance.runTransaction((Transaction tx) async {
        final DocumentSnapshot newDoc = await tx.get(_guidesCollection.document());

        final Map<String, dynamic> data = {
          "name": guide.name,
          "userId": user.uid,
          "imageId": newImageId,
          "steps": _stepsToMapList(guide.steps),
          "documentVersion": 1,
          "updated": new DateTime.now().toUtc().toIso8601String()
        };
        await tx.set(newDoc.reference, data);
      });
    } else {
      //update existing
      return Firestore.instance.runTransaction((Transaction tx) async {
        final DocumentSnapshot docToUpdate = await tx.get(_guidesCollection.document(guide.id));

        String imageId = "";
        if (newImageId.isEmpty) {
          if (guide.image.id.isNotEmpty) {
            imageId = guide.image.id;
          }
        } else {
          imageId = newImageId;
        }

        final Map<String, dynamic> data = {
          "id": guide.id,
          "name": guide.name,
          "imageId": imageId,
          "steps": _stepsToMapList(guide.steps),
          "documentVersion": 1,
          "updated": new DateTime.now().toUtc().toIso8601String()
        };

        await tx.update(docToUpdate.reference, data);
      });
    }
  }

  Future<void> delete(FirebaseUser user, Guide guide) async {
    if (guide.image.id.isNotEmpty) {
      Future<void> deleteTask = FirebaseStorage.instance.ref().child(guide.image.id).delete();
      await deleteTask;
    }

    return _guidesCollection.document(guide.id).delete().catchError((error) => Future.error(error));
  }

  Future<Guide> _docToGuide(DocumentSnapshot doc) async {
    String id = doc.documentID;
    String name = _thisOrUnknownIfNull(doc.data["name"]);

    List<GuideStep> steps = _thisOrEmptyListIfNull(doc.data["steps"]);

    String imageId = doc.data["imageId"];
    if (imageId.isEmpty) {
      return Guide(name: name, id: id, steps: steps);
    } else {
      String imageUrl = "";
      try {
        imageUrl = await FirebaseStorage.instance.ref().child(imageId).getDownloadURL();
      } catch (e) {
        print(e);
      }
      return Guide(name: name, id: id, image: ImageData(imageId, imageUrl), steps: steps);
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
    String sku = _thisOrEmptyIfNull(miniaturePaintMap["sku"]);
    String color = _thisOrEmptyIfNull(miniaturePaintMap["color"]);
    return MiniaturePaint(name, manufacturer, range, sku, color);
  }

  String _thisOrEmptyIfNull(dynamic field) {
    if (field == null || !(field is String)) return "";
    return field;
  }

  List<Map<String, dynamic>> _stepsToMapList(List<GuideStep> steps) => steps.map((step) {
        Map<String, dynamic> map = {"verb": step.verb, "notes": step.notes};
        if (step.miniaturePaint != null) {
          map["miniaturePaint"] = {
            "name": step.miniaturePaint.name,
            "manufacturer": step.miniaturePaint.manufacturer,
            "range": step.miniaturePaint.range,
            "color": step.miniaturePaint.colorOrGradientToString()
          };
        }
        return map;
      }).toList();

  @override
  void dispose() {
    _controller.close();
  }
}
