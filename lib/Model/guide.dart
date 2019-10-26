import 'package:saladin/Model/miniature_paint.dart';

class Guide {
  final String name;
  final String imageUrl;
  final List<GuideStep> steps;

  Guide(this.name, {this.imageUrl, this.steps});
}

class GuideStep {
  final String verb;
  final MiniaturePaint miniaturePaint;
  final String notes;

  GuideStep(this.verb, {this.miniaturePaint, this.notes});
}
