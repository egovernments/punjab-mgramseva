import 'package:flutter/material.dart';
import 'package:mgramseva/components/HouseConnectionandBill/GenerateNewBill.dart';
import 'package:mgramseva/components/HouseConnectionandBill/HouseConnectionDetailCard.dart';
import 'package:mgramseva/components/HouseConnectionandBill/NewConsumerBill.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/routers/Routers.dart';

class HouseholdDetail extends StatefulWidget {
  static const String routeName = 'household/details';
  @override
  State<StatefulWidget> createState() {
    return _HouseholdDetailState();
  }
}

class _HouseholdDetailState extends State<HouseholdDetail> {
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
        body: SingleChildScrollView(
            child: FormWrapper(Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              HomeBack(),
              HouseConnectionDetailCard(),
              GenerateNewBill(),
              NewConsumerBill()
            ]))));
  }
}
