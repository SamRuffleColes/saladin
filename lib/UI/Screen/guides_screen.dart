import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saladin/Auth/auth.dart';
import 'package:saladin/BLoC/guides_bloc.dart';
import 'package:saladin/Model/guide.dart';
import 'package:saladin/Resources/app_palette.dart';
import 'package:saladin/Resources/dimensions.dart';
import 'package:saladin/Resources/strings.dart';
import 'package:saladin/UI/Screen/edit_guide_screen.dart';

class GuidesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Strings.guidesScreenTitle), automaticallyImplyLeading: false),
        body: Center(child: GuidesListWidget()),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditGuideScreen())),
            label: Text(Strings.createNewGuide),
            icon: Icon(Icons.add),
            backgroundColor: AppPalette.accent));
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
              subtitle: Text("nice mini is nice"),
            ),
            child: CachedNetworkImage(
              imageUrl: guide.image.url,
              fit: BoxFit.fill,
              placeholder: (context, url) =>
                  Container(child: CircularProgressIndicator(), padding: const EdgeInsets.all(Dimensions.largePadding)),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )),
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditGuideScreen(guide: guide))));

//    return GridTile(
//      footer: GridTileBar(
//        backgroundColor: Colors.black45,
//        title: Text(guide.name),
//        subtitle: Text("nice mini is nice"),
//      ),
//      child: GestureDetector(
//          child: Icon(Icons.edit, color: Colors.white),
//          onTap: () =>
//              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditGuideScreen(guide: guide)))),
//    );
  }
}
