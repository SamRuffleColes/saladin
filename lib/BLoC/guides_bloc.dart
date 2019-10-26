import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:saladin/Model/guide.dart';
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

    return Future.error("the error");
//    if (image != null) {
//      StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child(imageId).putFile(image);
//      await uploadTask.onComplete;
//      if (!uploadTask.isSuccessful) {
//        imageId = "";
//      }
//    }
//
//    return Firestore.instance.runTransaction((Transaction tx) async {
//      final DocumentSnapshot newDoc = await tx.get(_guidesCollection.document());
//      final Map<String, dynamic> data = {
//        "name": guide.name,
//        "userId": user.uid,
//        "imageId": imageId,
//        "created": new DateTime.now().toUtc().toIso8601String()
//      };
//      await tx.set(newDoc.reference, data);
//      return data;
//    }).then((data) => _mapToGuide(data));
  }

  Future<Guide> _mapToGuide(Map<String, dynamic> map) async {
    String name = _thisOrUnknownIfNull(map["name"]);

    String imageId = map["imageId"];
    if (imageId.isEmpty) {
      return Guide(name);
    } else {
      String imageUrl = "";
      try {
        imageUrl = await FirebaseStorage.instance.ref().child(imageId).getDownloadURL();
      } catch (e) {
        print(e);
      }
      return Guide(name, imageUrl: imageUrl);
    }
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
