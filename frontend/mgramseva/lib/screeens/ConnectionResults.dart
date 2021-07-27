import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/ConnectionResults/ConnectionDetailsCard.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/SideBar.dart';

import 'Home.dart';

class SearchConsumerResult extends StatefulWidget {
  static const String routeName = 'search/consumer';

  @override
  State<StatefulWidget> createState() {
    return _SearchConsumerResultState();
  }
}

class _SearchConsumerResultState extends State<SearchConsumerResult> {
  _onSelectItem(int index, context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Home(index),
        ),
        ModalRoute.withName(Routes.home));
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
          Drawer(child: SideBar((value) => _onSelectItem(value, context))),
        ),
        body: FormWrapper(Container(
            child: Column(children: [
          HomeBack(),
          SearchConnectionDetailCard(),
        ]))));
  }
}
