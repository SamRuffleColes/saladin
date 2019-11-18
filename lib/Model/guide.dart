import 'package:saladin/Model/miniature_paint.dart';

class Guide {
  String id;
  String name;
  ImageData image;
  List<GuideStep> steps;

  Guide({this.name = "", this.id = "", this.image = const ImageData("", ""), this.steps}) {
    if (steps == null) {
      steps = [];
    }
  }
}

class ImageData {
  final String id;
  final String url;

  const ImageData(this.id, this.url);
}

class GuideStep {
  final String verb;
  final MiniaturePaint miniaturePaint;
  final String notes;

  GuideStep(this.verb, {this.miniaturePaint, this.notes});
}
