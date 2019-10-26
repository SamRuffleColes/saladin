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

    return StreamBuilder(
        stream: bloc.guidesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Guide> guides = snapshot.data;
            return ListView.separated(
                itemBuilder: (context, index) {
                  Guide guide = guides[index];
                  return Container(
                      padding: EdgeInsets.all(Dimensions.largePadding),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                              imageUrl: guide.imageUrl,
                              height: 200,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(), padding: EdgeInsets.all(Dimensions.largePadding)),
                              errorWidget: (context, url, error) => Icon(Icons.error)),
                          Text("${guide.name}")
                        ],
                      ));
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: guides.length);
          }
        });
  }
}
