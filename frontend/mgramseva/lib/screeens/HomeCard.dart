import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mgramseva/icons/home_icons_icons.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/home_provider.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:mgramseva/utils/role_actions.dart';

import 'HomeWalkThrough/HomeWalkThroughList.dart';

final String assetName = 'assets/svg/HHRegister.svg';

class HomeCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeCard();
  }
}

class _HomeCard extends State<HomeCard> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> getList(HomeProvider homeProvider) {
    return RoleActionsFiltering().getFilteredModules().map((item) {
      return GridTile(
        child: new GestureDetector(
            onTap: () => Navigator.pushNamed(context, item.link,
                arguments: item.arguments),
            child: new Card(
                key: homeProvider.homeWalkthrougList
                    .where((element) => element.label == item.label)
                    .first
                    .key,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(item.iconData, size: 35),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Center(
                          child: new Text(
                        ApplicationLocalizations.of(context)
                            .translate(item.label),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      )),
                    )
                  ],
                ))),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 760) {
        return Container(
            child: commonProvider.userDetails!.selectedtenant != null &&
                    commonProvider.userDetails!.userRequest != null
                ? (new GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: .8,
                    children: getList(homeProvider),
                  ))
                : Text(""));
      } else {
        return Container(
            margin: EdgeInsets.only(left: 75, right: 75),
            child: commonProvider.userDetails!.selectedtenant != null &&
                    commonProvider.userDetails!.userRequest != null
                ? (new GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 3,
                    children: getList(homeProvider),
                  ))
                : Text(""));
      }
    });
  }
}
