import 'package:saladin/Resources/strings.dart';
import 'package:url_launcher/url_launcher.dart';

launchFeedbackEmail() async {
  _launch("mailto:${Strings.feedbackEmailAddress}?subject=App%20Feedback&body=Please%20email%20us%20your%20feedback:");
}

launchOpenSourceLicences() async {
  _launch("http://brushtips.uk.co.uk");
}

_launch(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "Could not launch $url";
  }
}
