import 'package:flutter/material.dart';
import 'package:saladin/BLoC/miniature_paints_bloc.dart';
import 'package:saladin/Model/miniature_paint.dart';
import 'package:saladin/Resources/dimensions.dart';
import 'package:saladin/Resources/strings.dart';
import 'package:saladin/UI/Widget/filter_chips_widget.dart';

class MiniaturePaintsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.miniaturePaintsScreenTitle)),
      body: PaintsGridWidget(),
    );
  }
}

class PaintsGridWidget extends StatelessWidget {
  MiniaturePaintsBloc _bloc = MiniaturePaintsBloc();

  @override
  Widget build(BuildContext context) {
    final bool isPortraitOrientation = MediaQuery.of(context).orientation == Orientation.portrait;

    _bloc.fetchAll();

    return StreamBuilder(
        stream: _bloc.miniaturePaintsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<MiniaturePaint> miniaturePaints = snapshot.data;
            Set<String> manufacturers = miniaturePaints.map((mp) => mp.manufacturer).toSet();

            return Column(
              children: [
                FilterChips(
                    filterLabels: manufacturers.toList(),
                    onFiltersChanged: (selectedManufacturers) => _bloc.filterByManufacturer(selectedManufacturers)),
                Expanded(
                    child: SafeArea(
                        top: false,
                        bottom: false,
                        child: GridView.builder(
                            padding: EdgeInsets.all(Dimensions.standardPadding),
                            itemCount: miniaturePaints.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isPortraitOrientation ? 2 : 3,
                                crossAxisSpacing: Dimensions.standardPadding,
                                mainAxisSpacing: Dimensions.standardPadding,
                                childAspectRatio: isPortraitOrientation ? 1.0 : 1.3),
                            itemBuilder: (BuildContext context, int index) {
                              final miniaturePaint = miniaturePaints[index];
                              return _buildTile(context, miniaturePaint);
                            })))
              ],
            );
          }
        });
  }

  Widget _buildTile(BuildContext context, MiniaturePaint miniaturePaint) {
    return GestureDetector(
        onTap: () => Navigator.of(context).pop(miniaturePaint),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(miniaturePaint.name),
            subtitle: Text("${miniaturePaint.manufacturer} (${miniaturePaint.range})"),
          ),
          child: Container(color: miniaturePaint.color),
        ));
  }
}
