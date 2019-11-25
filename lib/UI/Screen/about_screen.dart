import 'package:flutter/material.dart';
import 'package:saladin/Resources/app_palette.dart';
import 'package:saladin/Resources/dimensions.dart';
import 'package:saladin/Resources/strings.dart';
import 'package:saladin/Web/url_launcher_utils.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Strings.about)),
        body: Container(
          padding: EdgeInsets.only(
              top: Dimensions.largeSpacing, left: Dimensions.largePadding, right: Dimensions.largePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.only(bottom: Dimensions.largeSpacing),
                  child: Text(Strings.aboutBody, textAlign: TextAlign.center)),
              Container(
                  padding: EdgeInsets.only(bottom: Dimensions.smallSpacing),
                  child: InkWell(
                      child: Text(Strings.feedbackEmailAddress, style: TextStyle(color: AppPalette.hyperlink)),
                      onTap: () => launchFeedbackEmail())),
              InkWell(
                  child: Text(Strings.openSourceLicences, style: TextStyle(color: AppPalette.hyperlink)),
                  onTap: () => launchOpenSourceLicences())
            ],
          ),
        ));
  }
}
