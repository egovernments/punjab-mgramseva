import 'package:flutter/material.dart';
import 'package:mgramseva/screeens/EditProfile.dart';
import 'package:mgramseva/screeens/HomeCard.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/SideBar.dart';

class Home extends StatefulWidget {
  static const String routeName = 'home';

  final int selectedDrawerIndex;
  Home(this.selectedDrawerIndex);
  State<StatefulWidget> createState() {
    return _HomeState(this.selectedDrawerIndex);
  }
}

class _HomeState extends State<Home> {
  late int selectedDrawerIndex;

  _HomeState(this.selectedDrawerIndex);

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new HomeCard();
      case 2:
        return new EditProfile();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    print(index);
    setState(() => selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          Text('mGramSeva'),
          AppBar(),
          <Widget>[Icon(Icons.more_vert)],
        ),
        drawer: DrawerWrapper(
          Drawer(child: SideBar(_onSelectItem)),
        ),
        body: _getDrawerItemWidget(selectedDrawerIndex));
  }
}
