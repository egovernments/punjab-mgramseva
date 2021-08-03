import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:mgramseva/screeens/Profile/EditProfile.dart';
import 'package:mgramseva/screeens/HomeCard.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/CustomDropDown/select_drop_list.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/SideBar.dart';

class Home extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          Text(i18.common.MGRAM_SEVA),
          AppBar(),
          <Widget>[],
        ),
        drawer: DrawerWrapper(
          Drawer(child: SideBar()),
        ),
        body: HomeCard());
  }
}
