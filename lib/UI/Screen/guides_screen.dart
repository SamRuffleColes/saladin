import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saladin/Auth/auth.dart';
import 'package:saladin/BLoC/guides_bloc.dart';
import 'package:saladin/Model/guide.dart';
import 'package:saladin/Resources/app_palette.dart';
import 'package:saladin/Resources/dimensions.dart';
import 'package:saladin/Resources/strings.dart';
import 'package:saladin/UI/Screen/about_screen.dart';
import 'package:saladin/UI/Screen/edit_guide_screen.dart';
import 'package:saladin/UI/Screen/splash_screen.dart';
import 'package:saladin/Web/url_launcher_utils.dart';

enum OverflowOption { about, feedback, signOut }

class GuidesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Strings.guidesScreenTitle), automaticallyImplyLeading: false, actions: [
          PopupMenuButton<OverflowOption>(
              onSelected: (option) => _overflowOptionSelected(context, option),
              itemBuilder: (context) => <PopupMenuEntry<OverflowOption>>[
                    const PopupMenuItem<OverflowOption>(value: OverflowOption.about, child: Text(Strings.about)),
                    const PopupMenuItem<OverflowOption>(value: OverflowOption.feedback, child: Text(Strings.feedback)),
                    const PopupMenuItem<OverflowOption>(value: OverflowOption.signOut, child: Text(Strings.signOut))
                  ])
        ]),
        body: Center(child: GuidesListWidget()),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditGuideScreen())),
            label: Text(Strings.createNewGuide),
            icon: Icon(Icons.add),
            backgroundColor: AppPalette.accent));
  }

  _overflowOptionSelected(BuildContext context, OverflowOption option) {
    switch (option) {
      case OverflowOption.about:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutScreen()));
        break;
      case OverflowOption.feedback:
        launchFeedbackEmail();
        break;
      case OverflowOption.signOut:
        Auth().signOut().then(
            (_) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SplashScreen())));
        break;
    }
  }
}

class GuidesListWidget extends StatefulWidget {
  @override
  createState() => GuidesListState();
}

class GuidesListState extends State<GuidesListWidget> {
  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    final bloc = GuidesBloc();
    auth.currentUser().then((user) => bloc.fetchAll(user));

    final bool isPortraitOrientation = MediaQuery.of(context).orientation == Orientation.portrait;

    return StreamBuilder(
        stream: bloc.guidesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            final List<Guide> guides = snapshot.data;
            return Container(
              padding: const EdgeInsets.all(Dimensions.standardPadding),
              child: GridView.builder(
                  itemCount: guides.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isPortraitOrientation ? 2 : 3,
                      crossAxisSpacing: Dimensions.standardPadding,
                      mainAxisSpacing: Dimensions.standardPadding,
                      childAspectRatio: isPortraitOrientation ? 1.0 : 1.3),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildTile(guides[index]);
                  }),
            );
          }
        });
  }

  Widget _buildTile(Guide guide) {
    return GestureDetector(
        child: GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black45,
              title: Text(guide.name),
            ),
            child: Container(
              color: Colors.white,
              constraints: BoxConstraints.expand(),
              child: CachedNetworkImage(
                imageUrl: guide.image.url,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(child: CircularProgressIndicator(), padding: const EdgeInsets.all(Dimensions.largePadding)),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            )),
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditGuideScreen(guide: guide))));
  }
}
