import 'package:flutter/material.dart';
import 'package:mgramseva/screeens/HomeCard.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/SideBar.dart';

import 'customAppbar.dart';

class Home extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        drawer: DrawerWrapper(
          Drawer(child: SideBar()),
        ),
        body: HomeCard());
  }
}
